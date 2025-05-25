import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/repositories/doctor/doctor_repository.dart';
import 'package:medicall/screens/dashboard/cubit/visits_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: showVisits(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: FilledButton(
          onPressed: () {
            CallRoute().push<BuildContext>(context);
          },
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            elevation: const WidgetStatePropertyAll(4),
            minimumSize:
                WidgetStateProperty.all(const Size(double.infinity, 50)),
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: const Text('Call For Help'),
        ),
      ),
    );
  }

  Widget showVisits() {
    return BlocProvider(
      create: (context) => Visits(DoctorRepository())..getAllDoctors(),
      child: BlocBuilder<Visits, VisitsState>(
        builder: (context, state) {
          if (state is VisitsInitial || state is VisitsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is VisitsLoaded) {
            final now = DateTime.now();
            final todaysVisits = state.visits
                .where(
                  (visit) =>
                      visit.date.year == now.year &&
                      visit.date.month == now.month &&
                      visit.date.day == now.day,
                )
                .toList();
            final otherVisits = state.visits
                .where(
                  (visit) =>
                      visit.date.year != now.year ||
                      visit.date.month != now.month ||
                      visit.date.day != now.day,
                )
                .toList();
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Todays Visits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todaysVisits.length,
                    itemBuilder: (context, index) {
                      final visit = todaysVisits[index];
                      return visitItem(visit, context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Other Visits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: otherVisits.length,
                    itemBuilder: (context, index) {
                      final visit = otherVisits[index];
                      return visitItem(visit, context);
                    },
                  ),
                ),
              ],
            );
          }
          return const Text('You have no visits!');
        },
      ),
    );
  }

  Widget visitItem(Visit visit, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(visit.doctor.imageUrl),
        radius: 28,
      ),
      title: Text(
        visit.doctor.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        DateFormat('dd MMM yyyy, HH:mm').format(visit.date),
      ),
      onTap: () {
        print('Going to doctor with id:${visit.doctor.id}');
        CallRoute().push<BuildContext>(context);
        // Add navigation or action here if needed
      },
    );
  }
}
