// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $counterScreenRoute,
    ];

RouteBase get $counterScreenRoute => GoRouteData.$route(
      path: '/',
      factory: $CounterScreenRouteExtension._fromState,
    );

extension $CounterScreenRouteExtension on CounterPageRoute {
  static CounterPageRoute _fromState(GoRouterState state) => CounterPageRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
