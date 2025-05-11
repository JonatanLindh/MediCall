// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $timelineRoute,
      $doctorShellRoute,
      $patientIdRoute,
      $healthDetailRoute,
      $feedbackRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/login',
          factory: $LoginRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/dashboard',
          factory: $DashboardRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DashboardRouteExtension on DashboardRoute {
  static DashboardRoute _fromState(GoRouterState state) => DashboardRoute();

  String get location => GoRouteData.$location(
        '/dashboard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $timelineRoute => GoRouteData.$route(
      path: '/timeline',
      factory: $TimelineRouteExtension._fromState,
    );

extension $TimelineRouteExtension on TimelineRoute {
  static TimelineRoute _fromState(GoRouterState state) => TimelineRoute();

  String get location => GoRouteData.$location(
        '/timeline',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $doctorShellRoute => ShellRouteData.$route(
      navigatorKey: DoctorShellRoute.$navigatorKey,
      factory: $DoctorShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/doctor/home',
          factory: $DoctorHomeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/doctor/reports',
          factory: $DoctorReportsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/doctor/notifications',
          factory: $DoctorNotificationsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/doctor/profile',
          factory: $DoctorProfileRouteExtension._fromState,
        ),
      ],
    );

extension $DoctorShellRouteExtension on DoctorShellRoute {
  static DoctorShellRoute _fromState(GoRouterState state) =>
      const DoctorShellRoute();
}

extension $DoctorHomeRouteExtension on DoctorHomeRoute {
  static DoctorHomeRoute _fromState(GoRouterState state) => DoctorHomeRoute();

  String get location => GoRouteData.$location(
        '/doctor/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DoctorReportsRouteExtension on DoctorReportsRoute {
  static DoctorReportsRoute _fromState(GoRouterState state) =>
      DoctorReportsRoute();

  String get location => GoRouteData.$location(
        '/doctor/reports',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DoctorNotificationsRouteExtension on DoctorNotificationsRoute {
  static DoctorNotificationsRoute _fromState(GoRouterState state) =>
      DoctorNotificationsRoute();

  String get location => GoRouteData.$location(
        '/doctor/notifications',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DoctorProfileRouteExtension on DoctorProfileRoute {
  static DoctorProfileRoute _fromState(GoRouterState state) =>
      DoctorProfileRoute();

  String get location => GoRouteData.$location(
        '/doctor/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $patientIdRoute => GoRouteData.$route(
      path: '/patient-id',
      factory: $PatientIdRouteExtension._fromState,
    );

extension $PatientIdRouteExtension on PatientIdRoute {
  static PatientIdRoute _fromState(GoRouterState state) => PatientIdRoute();

  String get location => GoRouteData.$location(
        '/patient-id',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $healthDetailRoute => GoRouteData.$route(
      path: '/health-detail',
      factory: $HealthDetailRouteExtension._fromState,
    );

extension $HealthDetailRouteExtension on HealthDetailRoute {
  static HealthDetailRoute _fromState(GoRouterState state) =>
      HealthDetailRoute();

  String get location => GoRouteData.$location(
        '/health-detail',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $feedbackRoute => GoRouteData.$route(
      path: '/feedback',
      factory: $FeedbackRouteExtension._fromState,
    );

extension $FeedbackRouteExtension on FeedbackRoute {
  static FeedbackRoute _fromState(GoRouterState state) => FeedbackRoute();

  String get location => GoRouteData.$location(
        '/feedback',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
