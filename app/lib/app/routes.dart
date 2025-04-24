import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/counter/view/counter_page.dart';

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
@TypedGoRoute<CounterPageRoute>(
  path: '/',
)
@immutable
class CounterPageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CounterPage();
  }
}
