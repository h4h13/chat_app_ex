import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/ext/build_context_ext.dart';
import 'package:chat_app_ex/core/services/services.dart';
import 'package:chat_app_ex/core/widgets/chat_textfiled.dart';
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final APIServices _apiServices = getIt<APIServices>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final User user = _apiServices.user;

    return AlertDialog(
      title: Text(context.locale.editProfile),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ChatTextField(
                textFieldName: 'name',
                hintText: context.locale.name,
                initialValue: user.displayName ?? '',
                validators: <FormFieldValidator<String?>>[
                  FormBuilderValidators.required(errorText: 'Name is required'),
                ],
              ),
              const SizedBox(height: 16),
              ChatTextField(
                textFieldName: 'email',
                hintText: context.locale.email,
                initialValue: user.email ?? '',
                keyboardType: TextInputType.emailAddress,
                validators: <FormFieldValidator<String?>>[
                  FormBuilderValidators.required(
                    errorText: 'Email is required',
                  ),
                  FormBuilderValidators.email(errorText: 'Invalid email'),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(context.locale.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateProfile,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.locale.updateProfile),
        ),
      ],
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> values = _formKey.currentState!.value;
      await _apiServices.updateUserProfile(
        name: values['name'],
        email: values['email'],
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.locale.profileUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final APIServices _apiServices = getIt<APIServices>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.locale.changePassword),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ChatTextField(
                maxLines: 1,
                textFieldName: 'newPassword',
                hintText: context.locale.newPassword,
                obscureText: true,
                validators: <FormFieldValidator<String?>>[
                  FormBuilderValidators.required(
                    errorText: 'Password is required',
                  ),
                  FormBuilderValidators.minLength(
                    6,
                    errorText: 'Password must be at least 6 characters',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ChatTextField(
                maxLines: 1,
                textFieldName: 'confirmPassword',
                hintText: context.locale.confirmPassword,
                obscureText: true,
                validators: <FormFieldValidator<String?>>[
                  FormBuilderValidators.required(
                    errorText: 'Please confirm password',
                  ),
                  (String? value) {
                    final newPassword =
                        _formKey.currentState?.fields['newPassword']?.value;
                    if (value != newPassword) {
                      return context.locale.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(context.locale.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.locale.changePassword),
        ),
      ],
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> values = _formKey.currentState!.value;
      await _apiServices.updatePassword(values['newPassword']);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.locale.passwordUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error changing password: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final APIServices _apiServices = getIt<APIServices>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.locale.confirmDelete),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.locale.deleteAccountWarning,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              context.locale.confirmPasswordPrompt,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 8),
            FormBuilder(
              key: _formKey,
              child: ChatTextField(
                maxLines: 1,
                textFieldName: 'password',
                hintText: 'Password',
                obscureText: true,
                validators: <FormFieldValidator<String?>>[
                  FormBuilderValidators.required(
                    errorText: context.locale.passwordRequired,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(context.locale.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _deleteAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.locale.delete),
        ),
      ],
    );
  }

  Future<void> _deleteAccount() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() => _isLoading = true);

    try {
      final String password =
          _formKey.currentState!.value['password'] as String;
      final String email = _apiServices.user.email!;

      await _apiServices.deleteUserAccount(password: password, email: email);

      if (mounted) {
        Navigator.of(context).pop();
        context.read<AuthCubit>().signOut();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.locale.accountDeleted)));
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error deleting account: $e';
        if (e.toString().contains('requires-recent-login')) {
          errorMessage = 'Recent authentication required. Please log in again.';
        } else if (e.toString().contains('wrong-password')) {
          errorMessage = 'Incorrect password. Please try again.';
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
