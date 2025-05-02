// https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/screens/dashboard/dashboard_screen.dart';
import 'package:medicall/screens/home/home_screen.dart';
import 'package:medicall/screens/login/login_screen.dart';
import 'package:medicall/screens/emergency_status/timeline_screen.dart';

part 'routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Don't have to touch to add routes, `$appRoutes` will be regenerated
final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/timeline',
  routes: $appRoutes,
);

// Example route
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<LoginRoute>(path: '/login'),
    TypedGoRoute<DashboardRoute>(path: '/dashboard'),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@immutable
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@immutable
class DashboardRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashboardScreen();
  }
}
@TypedGoRoute<TimelineRoute>(
  path: '/timeline',
)
@immutable
class TimelineRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const timelineScreen();
  }
}