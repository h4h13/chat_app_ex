import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/ext/build_context_ext.dart';
import 'package:chat_app_ex/core/localization_cubit.dart';
import 'package:chat_app_ex/core/services/services.dart';
import 'package:chat_app_ex/features/home/view/widgets/user_management_dialogs.dart';
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const LoggedInUser(),
            const SizedBox(height: 20),

            // User Management Options
            Column(
              children: <Widget>[
                _buildMenuTile(
                  context,
                  icon: Icons.edit,
                  title: context.locale.editProfile,
                  onTap: () => _showEditProfileDialog(context),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.lock,
                  title: context.locale.changePassword,
                  onTap: () => _showChangePasswordDialog(context),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.delete_forever,
                  title: context.locale.deleteAccount,
                  onTap: () => _showDeleteAccountDialog(context),
                  isDestructive: true,
                ),
              ],
            ),

            const Spacer(),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
                child: Text(
                  context.locale.signOut,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const EditProfileDialog(),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ChangePasswordDialog(),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const DeleteAccountDialog(),
    );
  }
}

class LoggedInUser extends StatelessWidget {
  const LoggedInUser({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = getIt<APIServices>().user;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getIt<APIServices>().getUser(user.uid),
      builder:
          (
            _,
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
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 0),
              trailing: const LanguageSwitcherWidget(),
              leading: CircleAvatar(
                backgroundColor: Colors.primaries.elementAt(
                  user.uid.hashCode % Colors.primaries.length,
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(userName),
              subtitle: Text(userEmail),
            );
          },
    );
  }
}

class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String locale) {
        context.read<LocalizationCubit>().changeLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'en', child: Text('English')),
          const PopupMenuItem<String>(value: 'ar', child: Text('Arabic')),
        ];
      },
    );
  }
}
