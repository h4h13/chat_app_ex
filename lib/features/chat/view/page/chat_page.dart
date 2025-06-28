import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/services/services.dart';
import 'package:chat_app_ex/features/chat/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatId, required this.toUserId});

  final String chatId;
  final String toUserId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getIt<APIServices>().getUser(widget.toUserId),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> asyncSnapshot,
          ) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text('Error: ${asyncSnapshot.error}'));
            }
            if (!asyncSnapshot.hasData || !asyncSnapshot.data!.exists) {
              return const Center(child: Text('User not found.'));
            }
            final Map<String, dynamic> userData = asyncSnapshot.data!.data()!;
            final String userEmail = userData['email'] ?? 'Unknown User';
            final String userName = userData['name'] ?? 'Unknown User';
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                centerTitle: false,
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.primaries.elementAt(
                      widget.toUserId.hashCode % Colors.primaries.length,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(userName),
                  subtitle: Text(userEmail),
                ),
              ),
              bottomNavigationBar: SendMessageWidget(
                chatId: widget.chatId,
                toUserId: widget.toUserId,
              ),
              body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getIt<APIServices>().getChatMessages(widget.chatId),
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No messages yet.'));
                      }
                      final List<MapEntry<String, dynamic>> messages = snapshot
                          .data!
                          .docs
                          .map((
                            QueryDocumentSnapshot<Map<String, dynamic>> doc,
                          ) {
                            return MapEntry<String, dynamic>(
                              doc.id,
                              doc.data(),
                            );
                          })
                          .toList();

                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final MapEntry<String, dynamic> message =
                              messages[index];
                          return MessageWidget(
                            message: message,
                            chatId: widget.chatId,
                          );
                        },
                      );
                    },
              ),
            );
          },
    );
  }
}

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({
    super.key,
    required this.chatId,
    required this.toUserId,
  });
  final String chatId;
  final String toUserId;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void sendMessage(String message) {
    final String senderId = getIt<APIServices>().user.uid;
    final String receiverId = widget.toUserId;
    final String? senderEmail = getIt<APIServices>().user.email;
    final Timestamp timestamp = Timestamp.now();
    final Message newMessage = Message(
      senderId: senderId,
      receiverId: receiverId,
      content: message,
      timestamp: timestamp,
      senderEmail: senderEmail,
    );
    getIt<APIServices>().sendMessage(widget.chatId, newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilder(
                key: _formKey,
                child: FormBuilderTextField(
                  name: 'message',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Message cannot be empty',
                    ),
                    FormBuilderValidators.maxLength(
                      500,
                      errorText: 'Message cannot exceed 500 characters',
                    ),
                  ]),
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final String? message =
                    _formKey.currentState?.fields['message']?.value;
                if (message != null && message.isNotEmpty) {
                  sendMessage(message);
                  _formKey.currentState?.fields['message']?.didChange('');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key, required this.message, required this.chatId});
  final MapEntry<String, dynamic> message;
  final String chatId;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool _isExpanded = false;

  void _confirmDeleteMessage() {
    final String chatId = widget.chatId;
    final String messageId = widget.message.key;
    getIt<APIServices>()
        .deleteMessage(chatId, messageId)
        .then(
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Message deleted successfully'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error deleting message: $error'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
  }

  void _deleteMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteMessage();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> messageData = widget.message.value;

    final String content = messageData['content'] ?? '';
    final Timestamp timestamp = messageData['timestamp'];
    final DateTime dateTime = timestamp.toDate();
    final String senderId = messageData['senderId'] ?? '';
    final String receiverId = getIt<APIServices>().user.uid;
    final bool isSender = senderId == receiverId;
    final Alignment alignment = isSender
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final String formattedDate = DateFormat('kk:mm a').format(dateTime);
    return GestureDetector(
      onLongPress: _deleteMessage,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        alignment: alignment,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: isSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            ChatBubble(message: content, isSender: isSender),
            const SizedBox(height: 4.0),
            if (_isExpanded)
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.isSender});
  final String message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isSender ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16.0, color: Colors.black87),
      ),
    );
  }
}
