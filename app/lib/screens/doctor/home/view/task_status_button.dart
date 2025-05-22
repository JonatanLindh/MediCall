import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/screens/doctor/reports/cubit/doctor_reports_cubit.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

class AssignedTaskStatusButton extends StatefulWidget {
  const AssignedTaskStatusButton({
    required this.currentDoctorId,
    super.key,
    this.onStatusChanged,
  });
  final String currentDoctorId;
  final void Function(String reportId, TaskStatusStep status)? onStatusChanged;

  @override
  State<AssignedTaskStatusButton> createState() =>
      _AssignedTaskStatusButtonState();
}

class _AssignedTaskStatusButtonState extends State<AssignedTaskStatusButton> {
  int _currentTaskIndex = 0;
  TaskStatusStep _statusStep = TaskStatusStep.departure;
  int? _initialTaskCount;

  @override
  Widget build(BuildContext context) {
    // Get all assigned but not completed tasks for the current doctor from Cubit state
    final state = context.watch<DoctorReportsCubit>().state;
    final assignedTasks = state.reports
        .where(
          (r) => r.assignedDoctorId == widget.currentDoctorId && !r.completed,
        )
        .toList();

    _initialTaskCount ??= assignedTasks.length; // Store the initial task count
    // If no assigned tasks, show a message
    if (assignedTasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.green, size: 24),
                SizedBox(width: 04),
                Text(
                  'All tasks completed.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Great work!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    // Prevent index out of range
    if (_currentTaskIndex >= assignedTasks.length) {
      _currentTaskIndex = 0;
      _statusStep = TaskStatusStep.departure;
    }

    final currentTask = assignedTasks[_currentTaskIndex];
    final taskLength = assignedTasks.length;
    _statusStep = currentTask.statusStep;

    // Map current status step to display text
    String statusText;
    switch (_statusStep) {
      case TaskStatusStep.departure:
        statusText = 'Departure';
      case TaskStatusStep.arrival:
        statusText = 'Arrival';
      case TaskStatusStep.complete:
        statusText = 'Complete';
        break;
        throw UnimplementedError();
    }

    return ElevatedButton(
      onPressed: () {
        setState(() {
          final oldStatusStep = _statusStep;

          if (_statusStep == TaskStatusStep.departure) {
            _statusStep = TaskStatusStep.arrival;
          } else if (_statusStep == TaskStatusStep.arrival) {
            _statusStep = TaskStatusStep.complete;
          } else if (_statusStep == TaskStatusStep.complete) {
            // Mark current task as completed and update Cubit state
            context
                .read<DoctorReportsCubit>()
                .setCompleted(id: currentTask.id, value: true);

            // Call external callback (if any)
            widget.onStatusChanged?.call(currentTask.id, _statusStep);

            // Move to the next task
            _currentTaskIndex++;

            // If all tasks are done, reset to first task and initial status
            if (_currentTaskIndex >= assignedTasks.length) {
              _currentTaskIndex = 0;
              _statusStep = TaskStatusStep.departure;
            } else {
              _statusStep = TaskStatusStep.departure;
            }
            return;
          }
          context.read<DoctorReportsCubit>().setStatusStep(
                id: currentTask.id,
                oldStatus: oldStatusStep,
                status: _statusStep,
              );

          // Trigger callback on every status change
          widget.onStatusChanged?.call(currentTask.id, _statusStep);
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentTask.name, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            statusText,
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 4),
              Text(
                'Task ${_initialTaskCount! - assignedTasks.length + 1} of $_initialTaskCount',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
