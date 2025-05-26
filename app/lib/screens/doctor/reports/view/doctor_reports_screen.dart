import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/screens/doctor/reports/cubit/doctor_reports_cubit.dart';
import 'package:medicall/screens/patient/login/bloc/login_bloc.dart';

class DoctorReportsScreen extends HookWidget {
  const DoctorReportsScreen({super.key});

  void filter(BuildContext context, ReportStatus status) {
    context.read<DoctorReportsCubit>().filterStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final cubit = context.read<DoctorReportsCubit>();

    final doctorId = context.read<LoginBloc>().getDoctorId();

    ReportStatus selectedStatus;
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
            icon: const Icon(Icons.add),
            onPressed: () =>
                context.read<DoctorReportsCubit>().setMockReports(),
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
                    final isAssigned = report.doctorName != null;
                    print('r: ${report.doctorId} d: $doctorId');
                    final isAssignedToMe = report.doctorId == doctorId;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: const AssetImage(
                          'assets/images/woman.webp',
                        ), // Replace with actual image path
                        backgroundColor: Colors
                            .grey[200], // Fallback color if image fails to load
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.name,
                            style: const TextStyle(
                              //fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ), // Assuming 'name' is a String property of Report
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
                                  '${report.doctorName}',
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
                                  child: const Text(
                                    'Unassign',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFFFA8CD),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                            else
                              // If the report is assigned to another doctor, show the assigned doctor's name
                              Text(
                                '${report.doctorName}',
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
                                      doctorId: doctorId,
                                    );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Assign to me',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9AEF99),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
    final isSelected = state.statusFilter == filter;

    return GestureDetector(
      onTap: () => context.read<DoctorReportsCubit>().filterStatus(filter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the text bold
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
          Container(
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFA8CD) : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
