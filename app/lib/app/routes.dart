// https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/screens/dashboard/dashboard_screen.dart';
import 'package:medicall/screens/doctor/doctor.dart';
import 'package:medicall/screens/patient/patient.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

part 'routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

// Don't have to touch to add routes, `$appRoutes` will be regenerated
final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
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
  path: '/timeline/:reportId/:status',
)
@immutable
class TimelineRoute extends GoRouteData {
  final String reportId;
  final String status;

  const TimelineRoute({
    required this.reportId,
    required this.status,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    
    final currentStatus = TaskStatusStep.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatusStep.departure,
    );

    return TimelineScreen(
      reportId: reportId,
      currentStatus: currentStatus,
    );
  }
}


@TypedShellRoute<DoctorShellRoute>(
  routes: [
    TypedGoRoute<DoctorHomeRoute>(path: '/doctor/home'),
    TypedGoRoute<DoctorReportsRoute>(path: '/doctor/reports'),
    TypedGoRoute<DoctorNotificationsRoute>(path: '/doctor/notifications'),
    TypedGoRoute<DoctorProfileRoute>(path: '/doctor/profile'),
  ],
)
@immutable
class DoctorShellRoute extends ShellRouteData {
  const DoctorShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return DoctorShell(child: navigator);
  }
}

@immutable
class DoctorHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DoctorHomeScreen();
  }
}

@immutable
class DoctorReportsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DoctorReportsScreen();
  }
}

@immutable
class DoctorNotificationsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DoctorNotificationsScreen();
  }
}

@immutable
class DoctorProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DoctorProfileScreen();
  }
}

@TypedGoRoute<PatientIdRoute>(path: '/patient-id')
@immutable
class PatientIdRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PatientIdScreen();
  }
}

@TypedGoRoute<HealthDetailRoute>(path: '/health-detail')
@immutable
class HealthDetailRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HealthDetailScreen();
  }
}

@TypedGoRoute<FeedbackRoute>(path: '/feedback')
@immutable
class FeedbackRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FeedbackScreen();
  }
}
