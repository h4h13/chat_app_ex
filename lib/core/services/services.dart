import 'dart:developer';

import 'package:chat_app_ex/features/chat/data/chat_user.dart';
import 'package:chat_app_ex/features/chat/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class APIServices {
  APIServices(this.firestore, this.firebaseAuth, this.firebaseMessaging);

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseMessaging firebaseMessaging;

  User get user => firebaseAuth.currentUser!;

  late ChatUser me = ChatUser(
    id: user.uid,
    name: user.displayName ?? '',
    email: user.email ?? '',
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore.collection('users').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Future<DocumentReference<Map<String, dynamic>>>> sendMessage(
    String chatId,
    Message message,
  ) async {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
    return firestore.collection('users').doc(userId).snapshots();
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<void> firebaseToken() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then((String? value) {
      me = me.copyWith(pushToken: value);
      log('Firebase Token: ${me.pushToken}');
    });
  }

  Future<void> updateUserProfile({String? name, String? email}) async {
    final Map<String, dynamic> updates = <String, dynamic>{};

    if (name != null && name.isNotEmpty) {
      updates['name'] = name;
      await user.updateDisplayName(name);
    }

    if (email != null && email.isNotEmpty && email != user.email) {
      await user.updateEmail(email);
      updates['email'] = email;
    }

    if (updates.isNotEmpty) {
      await firestore.collection('users').doc(user.uid).update(updates);

      me = me.copyWith(name: name ?? me.name, email: email ?? me.email);
    }
  }

  /// Get all chat IDs where the current user is a participant
  /// Chat IDs are in format: userId1_userId2 (sorted alphabetically)
  /// Also supports querying by participants field for better performance
  Future<List<String>> getUserChatIds([String? userId]) async {
    final String targetUserId = userId ?? user.uid;

    try {
      // First try to query by participants field (more efficient)
      final QuerySnapshot<Map<String, dynamic>> participantChats =
          await firestore
              .collection('chats')
              .where('participants', arrayContains: targetUserId)
              .get();

      if (participantChats.docs.isNotEmpty) {
        return participantChats.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> chat) => chat.id)
            .toList();
      }
    } catch (e) {
      log(
        'Participants field query failed, falling back to document ID parsing: $e',
      );
    }

    // Fallback: get all chats and filter by document ID
    final QuerySnapshot<Map<String, dynamic>> allChats = await firestore
        .collection('chats')
        .get();

    return allChats.docs
        .where((QueryDocumentSnapshot<Map<String, dynamic>> chat) {
          final List<String> participantIds = chat.id.split('_');
          return participantIds.contains(targetUserId);
        })
        .map((QueryDocumentSnapshot<Map<String, dynamic>> chat) => chat.id)
        .toList();
  }

  /// Create a chat ID from two user IDs (sorted alphabetically)
  String createChatId(String userId1, String userId2) {
    final List<String> chatIds = <String>[userId1, userId2];
    chatIds.sort();
    return chatIds.join('_');
  }

  Future<void> deleteUserAccount({String? password, String? email}) async {
    try {
      // Reauthenticate user before sensitive operations
      if (password != null && email != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      // Delete user document first
      await firestore.collection('users').doc(user.uid).delete();

      // Get all chat IDs for this user
      final List<String> userChatIds = await getUserChatIds();

      // Delete all chats and their messages efficiently
      final List<Future<void>> deletionTasks = userChatIds.map((
        String chatId,
      ) async {
        final DocumentReference<Map<String, dynamic>> chatRef = firestore
            .collection('chats')
            .doc(chatId);

        // Delete all messages in this chat
        final QuerySnapshot<Map<String, dynamic>> messages = await chatRef
            .collection('messages')
            .get();

        // Delete messages in batch
        final List<Future<void>> messageDeletions = messages.docs.map((
          QueryDocumentSnapshot<Map<String, dynamic>> message,
        ) {
          return message.reference.delete();
        }).toList();

        await Future.wait(messageDeletions);

        // Delete the chat document
        await chatRef.delete();
      }).toList();

      // Execute all chat deletions concurrently
      await Future.wait(deletionTasks);

      // Finally delete the Firebase Auth user
      await user.delete();
    } catch (e) {
      log('Error deleting user account: $e');
      if (e.toString().contains('requires-recent-login')) {
        throw Exception('Recent authentication required. Please log in again.');
      }
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    await user.updatePassword(newPassword);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Get a stream of a specific chat document
  Stream<DocumentSnapshot<Map<String, dynamic>>> getChat(String chatId) {
    return firestore.collection('chats').doc(chatId).snapshots();
  }

  /// Check if a chat exists between two users
  Future<bool> chatExists(String userId1, String userId2) async {
    final String chatId = createChatId(userId1, userId2);
    final DocumentSnapshot<Map<String, dynamic>> chatDoc = await firestore
        .collection('chats')
        .doc(chatId)
        .get();
    return chatDoc.exists;
  }

  /// Create a new chat between two users if it doesn't exist
  Future<String> createOrGetChat(String otherUserId) async {
    final String chatId = createChatId(user.uid, otherUserId);
    final DocumentReference<Map<String, dynamic>> chatRef = firestore
        .collection('chats')
        .doc(chatId);

    final DocumentSnapshot<Map<String, dynamic>> chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      // Create the chat document with basic metadata
      await chatRef.set(<String, dynamic>{
        'createdAt': FieldValue.serverTimestamp(),
        'participants': <String>[user.uid, otherUserId],
        'lastMessage': null,
        'lastMessageTimestamp': null,
      });
    }

    return chatId;
  }
}
