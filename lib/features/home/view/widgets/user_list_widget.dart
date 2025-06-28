import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/services/services.dart';
import 'package:chat_app_ex/features/home/view/widgets/user_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final bool isDesktop =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getIt<APIServices>().getMyUsersId(),
          builder:
              (
                _,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                asyncSnapshot,
              ) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading users',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${asyncSnapshot.error}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (!asyncSnapshot.hasData ||
                    asyncSnapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start by adding some friends to chat with',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final List<MapEntry<String, dynamic>> users = asyncSnapshot
                    .data!
                    .docs
                    .where((
                      QueryDocumentSnapshot<Map<String, dynamic>> element,
                    ) {
                      return element.id != getIt<APIServices>().user.uid;
                    })
                    .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                      return MapEntry<String, dynamic>(doc.id, doc.data());
                    })
                    .toList();

                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No other users found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You are the only user in the system',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: users.length,
                  padding: isDesktop
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (BuildContext context, int index) =>
                      isDesktop
                      ? const SizedBox.shrink()
                      : Divider(
                          height: 1,
                          indent: 72,
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.5),
                        ),
                  itemBuilder: (BuildContext context, int index) {
                    final MapEntry<String, dynamic> user = users[index];
                    return UserWidget(
                      key: ValueKey<String>(user.key),
                      user: user,
                    );
                  },
                );
              },
        );
      },
    );
  }
}
