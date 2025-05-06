import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/app/routes.dart';

class DoctorShell extends StatelessWidget {
  const DoctorShell({required this.child, super.key});

  final Widget child;

  int getCurrentIndex(BuildContext context) {
    print(GoRouterState.of(context).uri.pathSegments);
    final location = GoRouterState.of(context).uri.pathSegments[1];
    print(location);
    if (location == 'home') {
      return 0;
    } else if (location == 'reports') {
      return 1;
    } else if (location == 'notifications') {
      return 2;
    } else if (location == 'profile') {
      return 3;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0:
              DoctorHomeRoute().go(context);
            case 1:
              DoctorReportsRoute().go(context);
            case 2:
              DoctorNotificationsRoute().go(context);
            case 3:
              DoctorProfileRoute().go(context);
          }
        },
      ),
    );
  }
}
