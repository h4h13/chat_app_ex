import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/ext/build_context_ext.dart';
import 'package:chat_app_ex/core/router/router.dart';
import 'package:chat_app_ex/core/services/services.dart';
import 'package:chat_app_ex/features/home/vide_model/home_cubit.dart';
import 'package:chat_app_ex/features/home/view/widgets/profile_widget.dart';
import 'package:chat_app_ex/features/home/view/widgets/user_list_widget.dart';
import 'package:chat_app_ex/features/chat/view/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

// HomePage with logout button
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getIt<APIServices>().firebaseToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return _buildResponsiveLayout(context, sizingInformation);
      },
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    final DeviceScreenType deviceType = sizingInformation.deviceScreenType;

    if (deviceType == DeviceScreenType.desktop) {
      return _buildDesktopLayout(context);
    } else if (deviceType == DeviceScreenType.tablet) {
      return _buildTabletLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.locale.appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'View Map',
            onPressed: () {
              const MapRoute().push(context);
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface,
            1,
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          return NavigationBar(
            selectedIndex: state.currentIndex,
            onDestinationSelected: (int index) {
              context.read<HomeCubit>().changeIndex(index);
            },
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const Icon(Icons.chat_rounded),
                label: context.locale.chats,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person),
                label: context.locale.profile,
              ),
            ],
          );
        },
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          if (state.currentIndex == 0) {
            return const UserListWidget();
          } else if (state.currentIndex == 1) {
            return const ProfileWidget();
          }
          return const Center(child: Text('Select a tab'));
        },
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, HomeState state) {
        final bool isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        if (isLandscape) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(context.locale.appTitle),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.map),
                  tooltip: 'View Map',
                  onPressed: () {
                    const MapRoute().push(context);
                  },
                ),
              ],
            ),
            body: Row(
              children: <Widget>[
                NavigationRail(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  selectedIndex: state.currentIndex,
                  onDestinationSelected: (int index) {
                    context.read<HomeCubit>().changeIndex(index);
                  },
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: const Icon(Icons.chat_rounded),
                      label: Text(context.locale.chats),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.person),
                      label: Text(context.locale.profile),
                    ),
                  ],
                ),
                Expanded(child: _buildMainContent(context, state)),
              ],
            ),
          );
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, HomeState state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(context.locale.appTitle),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.map),
                tooltip: 'View Map',
                onPressed: () {
                  const MapRoute().push(context);
                },
              ),
            ],
          ),
          body: Row(
            children: <Widget>[
              NavigationRail(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                selectedIndex: state.currentIndex,
                onDestinationSelected: (int index) {
                  context.read<HomeCubit>().changeIndex(index);
                },
                extended: true,
                destinations: <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: const Icon(Icons.chat_rounded),
                    label: Text(context.locale.chats),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.person),
                    label: Text(context.locale.profile),
                  ),
                ],
              ),

              if (state.currentIndex == 0) ...<Widget>[
                const SizedBox(
                  width: 350,
                  child: Expanded(child: UserListWidget()),
                ),
                Expanded(child: _buildChatArea(context, state)),
              ] else ...<Widget>[
                Expanded(child: _buildMainContent(context, state)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, HomeState state) {
    if (state.currentIndex == 0) {
      return const UserListWidget();
    } else if (state.currentIndex == 1) {
      return const ProfileWidget();
    }
    return const Center(child: Text('Select a tab'));
  }

  Widget _buildChatArea(BuildContext context, HomeState state) {
    if (state.selectedUserId != null && state.selectedChatId != null) {
      return ChatPage(
        chatId: state.selectedChatId!,
        toUserId: state.selectedUserId!,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'Select a conversation to start chatting',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose from your existing conversations or start a new one',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
