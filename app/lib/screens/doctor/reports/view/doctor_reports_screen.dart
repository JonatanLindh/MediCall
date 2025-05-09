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

    return BlocProvider(
      create: (context) {
        final cubit = DoctorReportsCubit();

        searchController.addListener(() {
          cubit.searchChanged(searchController.text);
        });

        return cubit;
      },
      child: Scaffold(
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
                            title: Text(
                              'Unresolved (${state.unresolvedCount})',
                            ),
                            onTap: () {
                              filter(context, ReportStatus.unresolved);
                              context.pop();
                            },
                          ),
                          ListTile(
                            title: Text('Resolved (${state.resolvedCount})'),
                            onTap: () {
                              filter(context, ReportStatus.resolved);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton(
                      state: state,
                      filter: ReportStatus.unresolved,
                      text: 'Unresolved (${state.unresolvedCount})',
                    ),
                    FilterButton(
                      state: state,
                      filter: ReportStatus.resolved,
                      text: 'Resolved (${state.resolvedCount})',
                    ),
                    FilterButton(
                      state: state,
                      filter: ReportStatus.all,
                      text: 'All (${state.allCount})',
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = state.filteredReports[index];
                      return ListTile(
                        title: Text(report.name),
                        subtitle: Text(report.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(report.time),
                            Checkbox(
                              value: report.resolved,
                              onChanged: (val) {
                                if (val == null) return;
                                context
                                    .read<DoctorReportsCubit>()
                                    .setResolved(id: report.id, value: val);
                              },
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
