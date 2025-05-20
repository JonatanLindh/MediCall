import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/screens/doctor/reports/cubit/doctor_reports_cubit.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

class AssignedTaskStatusButton extends StatefulWidget {
  final String currentDoctorId;
  final void Function(String reportId, TaskStatusStep status)? onStatusChanged;

  const AssignedTaskStatusButton({
    Key? key,
    required this.currentDoctorId,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<AssignedTaskStatusButton> createState() => _AssignedTaskStatusButtonState();
}

class _AssignedTaskStatusButtonState extends State<AssignedTaskStatusButton> {
  int _currentTaskIndex = 0;
  TaskStatusStep _statusStep = TaskStatusStep.departure;

  @override
  Widget build(BuildContext context) {
    // Get all assigned but not completed tasks for the current doctor from Cubit state
    final state = context.watch<DoctorReportsCubit>().state;
    final assignedTasks = state.reports.where((r) =>
      r.assignedDoctorId == widget.currentDoctorId && !r.completed).toList();

    // If no assigned tasks, show a message
  if (assignedTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  'All caught up.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Take care of yourself.',
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

    // Map current status step to display text
    String statusText;
    switch (_statusStep) {
      case TaskStatusStep.departure:
        statusText = 'Departure';
        break;
      case TaskStatusStep.arrival:
        statusText = 'Arrival';
        break;
      case TaskStatusStep.complete:
        statusText = 'Complete';
        break;
        throw UnimplementedError();
    }

    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (_statusStep == TaskStatusStep.departure) {
            _statusStep = TaskStatusStep.arrival;
          } else if (_statusStep == TaskStatusStep.arrival) {
            _statusStep = TaskStatusStep.complete;
          } else if (_statusStep == TaskStatusStep.complete) {
            // Mark current task as completed and update Cubit state
            context.read<DoctorReportsCubit>().setCompleted(id: currentTask.id, value: true);

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
              status: _statusStep,
              );          

          // Trigger callback on every status change
          widget.onStatusChanged?.call(currentTask.id, _statusStep);
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentTask.name, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(statusText, style: const TextStyle(fontSize: 18, color: Colors.blue)),
        ],
      ),
    );
  }
}
