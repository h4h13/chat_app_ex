import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signUp({
    required String name,
    required String country,
    required String mobile,
    required String email,
    required String password,
  });
  Future<void> signOut();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<UserCredential> signUp({
    required String name,
    required String country,
    required String mobile,
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    if (user != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .set(<String, String>{
            'name': name,
            'country': country,
            'mobile': mobile,
            'email': email,
          })
          .onError((Object? error, StackTrace stackTrace) {
            print('$error');
          });
    }
    return userCredential;
  }
}
