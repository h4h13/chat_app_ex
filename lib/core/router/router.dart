import 'dart:async';

import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/features/chat/view/page/chat_page.dart';
import 'package:chat_app_ex/features/home/vide_model/home_cubit.dart';
import 'package:chat_app_ex/features/home/view/page/home_page.dart';
import 'package:chat_app_ex/features/login/view/page/login_page.dart';
import 'package:chat_app_ex/features/login/view/page/signup_page.dart';
import 'package:chat_app_ex/features/login/view/page/splash_page.dart';
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart';
import 'package:chat_app_ex/features/map/view/page/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

part 'router.g.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: const LoginRoute().location,
  refreshListenable: AuthNotifier(),
  routes: $appRoutes,
  redirect: (BuildContext context, GoRouterState state) {
    final User? user = FirebaseAuth.instance.currentUser;
    final bool isLoggingIn =
        state.fullPath == '/login' || state.fullPath == '/signup';

    if (user == null && !isLoggingIn) return '/login';
    if (user != null && isLoggingIn) return '/home';
    return null;
  },
);

@lazySingleton
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    _subscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with _$SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with _$LoginRoute {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<SignupRoute>(path: '/signup')
class SignupRoute extends GoRouteData with _$SignupRoute {
  const SignupRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupPage();
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/home',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<ChatRoute>(path: 'chat/:id'),
    TypedGoRoute<MapRoute>(path: 'map'),
  ],
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => getIt<HomeCubit>(),
      child: const HomePage(),
    );
  }
}

class ChatRoute extends GoRouteData with _$ChatRoute {
  const ChatRoute({required this.id, this.toUserId});
  final String id;
  final String? toUserId;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(chatId: id, toUserId: toUserId ?? '');
  }
}

class MapRoute extends GoRouteData with _$MapRoute {
  const MapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MapPage();
  }
}

class ErrorRoute extends GoRouteData {
  ErrorRoute({required this.error});
  final Exception error;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ErrorScreen(error: error);
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});
  final Exception error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('An error occurred: ${error.toString()}')),
    );
  }
}
