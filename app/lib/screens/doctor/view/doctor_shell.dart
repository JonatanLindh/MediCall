import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/repositories/geo/geo.dart';

class DoctorShell extends StatelessWidget {
  const DoctorShell({required this.child, super.key});

  final Widget child;

  int getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.pathSegments[1];

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
      body: BlocListener<GeoBloc, GeoState>(
        listener: (context, state) async {
          if (state is GeoGotPosition) {
            await context.read<GeoRepository>().uploadPosition(
                  'cmav7q0450000woy0jw7em246',
                  state.position,
                );
          }
        },
        child: child,
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, -2),
      ),
    ],
  ),
  child: NavigationBar(
    backgroundColor: Colors.white,
    indicatorColor:  Color.fromARGB(158, 255, 168, 206),
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
          return;
        case 1:
          DoctorReportsRoute().go(context);
          return;
        case 2:
          DoctorNotificationsRoute().go(context);
          return;
        case 3:
          DoctorProfileRoute().go(context);
          return;
      }
    },
  ),
),

    );
  }
}
