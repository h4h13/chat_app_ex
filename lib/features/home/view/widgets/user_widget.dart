import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/router/router.dart';
import 'package:chat_app_ex/core/services/services.dart';
import 'package:chat_app_ex/features/home/vide_model/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key, required this.user});
  final MapEntry<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = user.value as Map<String, dynamic>;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop;

        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final isSelected = isDesktop && state.selectedUserId == user.key;

            return Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.5)
                    : null,
                border: isSelected
                    ? Border(
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                      )
                    : null,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries.elementAt(
                    user.key.hashCode % Colors.primaries.length,
                  ),
                  child: userData['photoUrl'] != null
                      ? ClipOval(
                          child: Image.network(
                            userData['photoUrl'] as String,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, color: Colors.white),
                          ),
                        )
                      : const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  userData['name'] ?? 'No Name',
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                subtitle: Text(
                  userData['mobile'] ?? 'No Mobile',
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isDesktop
                    ? Icon(
                        Icons.chevron_right,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : null,
                onTap: () {
                  final String chatUserId = user.key;
                  final String chatId = getIt<APIServices>().createChatId(
                    getIt<APIServices>().user.uid,
                    chatUserId,
                  );

                  if (isDesktop) {
                    // For desktop, update the selected user in the state
                    context.read<HomeCubit>().selectUser(chatUserId, chatId);
                  } else {
                    // For mobile/tablet, navigate to chat page
                    ChatRoute(id: chatId, toUserId: chatUserId).push(context);
                  }
                },
                selected: isSelected,
              ),
            );
          },
        );
      },
    );
  }
}
