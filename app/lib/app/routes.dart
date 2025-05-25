// https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/repositories/geo/repo/geo_repository.dart';
import 'package:medicall/screens/call/call_screen.dart';
import 'package:medicall/screens/dashboard/dashboard_screen.dart';
import 'package:medicall/screens/doctor/doctor.dart';
import 'package:medicall/screens/patient/doctor_location/bloc/doctor_bloc.dart';
import 'package:medicall/screens/patient/login/view/register_screen.dart';
import 'package:medicall/screens/patient/patient.dart';
import 'package:medicall/screens/message/message_screen.dart';


part 'routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

// Don't have to touch to add routes, `$appRoutes` will be regenerated
final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: $appRoutes,
);

// Example route
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<LoginRoute>(path: '/login'),
    TypedGoRoute<RegisterRoute>(path: '/register'),
    TypedGoRoute<CallRoute>(path: '/call'),
    TypedGoRoute<MessageRoute>(path: '/message'),
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
class RegisterRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegisterScreen();
  }
}

@immutable
class CallRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CallScreen();
  }
}

@TypedGoRoute<TimelineRoute>(
  path: '/timeline',
)
@immutable
class TimelineRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TimelineScreen();
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
    return const DoctorHomeScreen();
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

@TypedShellRoute<PatientShellRoute>(
  routes: [
    TypedGoRoute<PatientDashboardRoute>(path: '/patient/dashboard'),
    TypedGoRoute<PatientIdRoute>(path: '/patient/id'),
    TypedGoRoute<PatientHealthDetailRoute>(path: '/patient/details'),
    TypedGoRoute<PatientTimelineRoute>(path: '/patient/timeline'),
  ],
)
@immutable
class PatientShellRoute extends ShellRouteData {
  const PatientShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return BlocProvider(
      create: (context) => DoctorBloc(
        geoRepository: context.read<GeoRepository>(),
      ),
      child: navigator,
    );
  }
}

@immutable
class PatientDashboardRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashboardScreen();
  }
}

@immutable
class PatientTimelineRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TimelineScreen();
  }
}

@immutable
class PatientIdRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PatientIdScreen();
  }
}

@immutable
class PatientHealthDetailRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HealthDetailScreen();
  }
}

@immutable
class FeedbackRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FeedbackScreen();
  }
}

@immutable
class MessageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MessageScreen();
  }
}
