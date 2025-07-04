import 'dart:developer';

import 'package:chat_app_ex/features/login/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState.authState());

  final AuthRepository _authRepository;

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Email and password must not be empty',
        ),
      );
      return;
    }
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+ *');
    if (!emailRegex.hasMatch(email)) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Please enter a valid email address',
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final UserCredential user = await _authRepository.signIn(email, password);
      emit(state.copyWith(isLoading: false, userCredential: user));
      // Success will be handled by authStateChanges listener
    } on FirebaseAuthException catch (e) {
      log('Login error: ${e.message}');
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Login failed'));
    }
  }

  void signUp({
    required String name,
    required String country,
    required String mobile,
    required String password,
    required String email,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Email and password must not be empty',
        ),
      );
      return;
    }
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
    if (!emailRegex.hasMatch(email)) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Please enter a valid email address',
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final UserCredential user = await _authRepository.signUp(
        name: name,
        country: country,
        mobile: mobile,
        email: email,
        password: password,
      );
      emit(state.copyWith(isLoading: false, userCredential: user));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Signup failed'));
    }
  }

  void signOut() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(isLoading: false, userCredential: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Logout failed'));
    }
  }
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.authState({
    String? errorMessage,
    @Default(null) UserCredential? userCredential,
    @Default(false) bool isLoading,
  }) = _AuthState;
}
