import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/screens/doctor/reports/cubit/doctor_reports_cubit.dart';

class DoctorReportsScreen extends HookWidget {
  const DoctorReportsScreen({super.key});

  void filter(BuildContext context, ReportStatus status) {
    context.read<DoctorReportsCubit>().filterStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final cubit = context.read<DoctorReportsCubit>();

    useEffect(
      () {
        void listener() => cubit.searchChanged(searchController.text);
        searchController.addListener(listener);
        searchController.addListener(() {
          cubit.searchChanged(searchController.text);
        });
        return null;
      },
      [searchController],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) =>
                    BlocBuilder<DoctorReportsCubit, DoctorReportsState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Unassigned (${state.unassignedCount})'),
                          onTap: () {
                            filter(context, ReportStatus.unassigned);
                            context.pop();
                          },
                        ),
                        ListTile(
                          title: Text('Assigned (${state.assignedCount})'),
                          onTap: () {
                            filter(context, ReportStatus.assigned);
                            context.pop();
                          },
                        ),
                        ListTile(
                          title: Text('Completed (${state.completedCount})'),
                          onTap: () {
                            filter(context, ReportStatus.completed);
                            context.pop();
                          },
                        ),
                        ListTile(
                          title: Text('All (${state.allCount})'),
                          onTap: () {
                            filter(context, ReportStatus.all);
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DoctorReportsCubit, DoctorReportsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search reports...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterButton(
                      state: state,
                      filter: ReportStatus.unassigned,
                      text: 'Unassigned (${state.unassignedCount})',
                    ),
                    FilterButton(
                      state: state,
                      filter: ReportStatus.assigned,
                      text: 'Assigned (${state.assignedCount})',
                    ),
                    FilterButton(
                      state: state,
                      filter: ReportStatus.completed,
                      text: 'Completed (${state.completedCount})',
                    ),
                    FilterButton(
                      state: state,
                      filter: ReportStatus.all,
                      text: 'All (${state.allCount})',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = state.filteredReports[index];
                    final isAssigned = report.assignedDoctorId != null;
                    const currentDoctorId =
                        'Dr. Johan Nilsson'; // assigned doctor id, need to be replaced with the current doctor's id!!
                    final isAssignedToMe = report.assignedDoctorId ==
                        currentDoctorId; // replace with the current doctor's id
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(report
                              .name), // Assuming 'name' is a String property of Report
                          const SizedBox(height: 4),
                        ],
                      ),
                      subtitle: Text(report.description),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            report.time,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isAssigned)
                            if (isAssignedToMe)
                              if (report.completed)
                                // If the report is assigned to me and completed, show Doctor's name
                                Text(
                                  '${report.assignedDoctorId}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              else
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<DoctorReportsCubit>()
                                        .unassignDoctor(
                                          id: report.id,
                                        );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Unassign'),
                                )
                            else
                              // If the report is assigned to another doctor, show the assigned doctor's name
                              Text(
                                '${report.assignedDoctorId}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              )
                          else
                            TextButton(
                              onPressed: () {
                                context
                                    .read<DoctorReportsCubit>()
                                    .assignToDoctor(
                                      id: report.id,
                                      doctorId: currentDoctorId,
                                    );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Assign to me'),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    required this.state,
    required this.filter,
    required this.text,
    super.key,
  });

  final ReportStatus filter;
  final DoctorReportsState state;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: state.statusFilter == filter
            ? Theme.of(context).highlightColor
            : Colors.transparent,
      ),
      onPressed: () => context.read<DoctorReportsCubit>().filterStatus(filter),
      child: Text(text),
    );
  }
}
