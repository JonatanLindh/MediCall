// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $doctorShellRoute,
      $patientShellRoute,
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
          path: '/register',
          factory: $RegisterRouteExtension._fromState,
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

extension $RegisterRouteExtension on RegisterRoute {
  static RegisterRoute _fromState(GoRouterState state) => RegisterRoute();

  String get location => GoRouteData.$location(
        '/register',
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

RouteBase get $patientShellRoute => ShellRouteData.$route(
      navigatorKey: PatientShellRoute.$navigatorKey,
      factory: $PatientShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/patient/dashboard',
          factory: $PatientDashboardRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/patient/id',
          factory: $PatientIdRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/patient/details',
          factory: $PatientHealthDetailRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/patient/timeline',
          factory: $PatientTimelineRouteExtension._fromState,
        ),
      ],
    );

extension $PatientShellRouteExtension on PatientShellRoute {
  static PatientShellRoute _fromState(GoRouterState state) =>
      const PatientShellRoute();
}

extension $PatientDashboardRouteExtension on PatientDashboardRoute {
  static PatientDashboardRoute _fromState(GoRouterState state) =>
      PatientDashboardRoute();

  String get location => GoRouteData.$location(
        '/patient/dashboard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PatientIdRouteExtension on PatientIdRoute {
  static PatientIdRoute _fromState(GoRouterState state) => PatientIdRoute();

  String get location => GoRouteData.$location(
        '/patient/id',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PatientHealthDetailRouteExtension on PatientHealthDetailRoute {
  static PatientHealthDetailRoute _fromState(GoRouterState state) =>
      PatientHealthDetailRoute();

  String get location => GoRouteData.$location(
        '/patient/details',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PatientTimelineRouteExtension on PatientTimelineRoute {
  static PatientTimelineRoute _fromState(GoRouterState state) =>
      PatientTimelineRoute();

  String get location => GoRouteData.$location(
        '/patient/timeline',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
