import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medicall/app/app_export.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/repositories/geo/bloc/geo_bloc.dart';
import 'package:medicall/repositories/geo/repo/geo_repository.dart';
import 'package:medicall/screens/patient/doctor_location/bloc/doctor_bloc.dart';

class TimelineStep {
  const TimelineStep(this.title, {required this.isActive});
  final String title;
  final bool isActive;
}

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FloatingActionButtons(),
      body: const DoctorStatus(),
    );
  }
}

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          FilledButton(
            onPressed: () => CallRoute().push<void>(context),
            style: FilledButton.styleFrom(
              backgroundColor: c.secondary,
              foregroundColor: c.onSecondary,
            ),
            child: const Text(
              'Call',
              style: TextStyle(fontSize: 17),
            ),
          ),
          FilledButton(
            onPressed: () {
              // Implement message functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Message functionality not implemented :(',
                  ),
                  // width: 400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  showCloseIcon: true,
                  elevation: 2,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: c.tertiary,
              foregroundColor: c.onTertiary,
            ),
            child: const Text(
              'Message',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

final List<TimelineStep> steps = [
  const TimelineStep('Receiving the emergency call', isActive: true),
  const TimelineStep('Dispatching emergency resources', isActive: true),
  const TimelineStep('Help is on the way', isActive: true),
  const TimelineStep('Arrival at the scene', isActive: false),
  const TimelineStep('Care completed', isActive: false),
];

class DoctorStatus extends HookWidget {
  const DoctorStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final showCoordinates = useState(false);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          GestureDetector(
            onTap: () => showCoordinates.value = !showCoordinates.value,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    ImageConstant.imgMap,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DoctorBloc, DoctorState>(
                        builder: (context, state) {
                          return PositionShower(
                            icon: Icons.medical_services_rounded,
                            showPos: showCoordinates.value,
                            title: 'Doctor',
                            position: state is DoctorAvailable
                                ? state.position
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      if (showCoordinates.value)
                        BlocBuilder<GeoBloc, GeoState>(
                          builder: (context, state) {
                            return PositionShower(
                              icon: Icons.person_pin_circle_rounded,
                              showPos: showCoordinates.value,
                              title: 'Patient',
                              position: state is GeoGotPosition
                                  ? StrippedPosition.fromPosition(
                                      state.position,
                                    )
                                  : null,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Doctor en route',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              // color: const Color(0xFFF6F4F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.black54,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '10:30 AM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Estimated arrival',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Timeline(),
        ],
      ),
    );
  }
}

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(
                    step.isActive ? Icons.check_rounded : Icons.circle_outlined,
                    color: step.isActive ? Colors.black : Colors.grey,
                    size: step.isActive ? 24 : 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.title,
                    style: TextStyle(
                      color: step.isActive ? Colors.black : appTheme.gray600,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (!isLast)
              Container(
                decoration: BoxDecoration(
                  color: step.isActive ? Colors.black : appTheme.gray600,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 4,
                ), // Indent for line
                width: 2,
                height: 15,
              ),
          ],
        );
      }),
    );
  }
}

class PositionShower extends StatelessWidget {
  const PositionShower({
    required this.title,
    required this.showPos,
    required this.icon,
    this.position,
    super.key,
  });

  final String title;
  final StrippedPosition? position;
  final bool showPos;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.redAccent,
            size: 24,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              if (showPos)
                Text(
                  position == null
                      ? 'No location data available'
                      : 'Latitude: ${position!.latitude}, Longitude: ${position!.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
