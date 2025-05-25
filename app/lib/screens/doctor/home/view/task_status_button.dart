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
  final state = context.watch<DoctorReportsCubit>().state;

  final assignedTasks = state.reports
      .where((r) => r.assignedDoctorId == widget.currentDoctorId && !r.completed)
      .toList();

  _initialTaskCount ??= assignedTasks.length;
  final nexttask=assignedTasks.length > 1 ? assignedTasks[1] : null;
  final nextPatientName = nexttask?.name ?? null;
  final nextAppointmentTime = nexttask?.time ?? null;
  if (assignedTasks.isEmpty) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 100),
          Row(
            
            mainAxisSize: MainAxisSize.min,
            
            children: [
              Icon(Icons.emoji_events, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text('All appointments completed.', style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(height: 8),
          Text('Great work!', style: TextStyle(fontSize: 18)),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  if (_currentTaskIndex >= assignedTasks.length) {
    _currentTaskIndex = 0;
    _statusStep = TaskStatusStep.departure;
  }

  final currentTask = assignedTasks[_currentTaskIndex];
  _statusStep = currentTask.statusStep;

  String statusText;
  IconData actionIcon;
  switch (_statusStep) {
    case TaskStatusStep.departure:
      statusText = 'Depart to Patient';
      actionIcon = Icons.directions_car;
      break;
    case TaskStatusStep.arrival:
      statusText = 'Mark Arrival';
      actionIcon = Icons.location_on;
      break;
    case TaskStatusStep.complete:
      statusText = 'Complete Visit';
      actionIcon = Icons.check_circle;
      break;
    default:
      throw UnimplementedError();
  }

  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    //margin: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Appoinment', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10),
          Text(currentTask.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(currentTask.time, style: const TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: Icon(actionIcon),
            label: Text(statusText, style: const TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(174, 154, 239, 153), 
              //color
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() {
                final oldStatusStep = _statusStep;

                if (_statusStep == TaskStatusStep.departure) {
                  _statusStep = TaskStatusStep.arrival;
                } else if (_statusStep == TaskStatusStep.arrival) {
                  _statusStep = TaskStatusStep.complete;
                } else if (_statusStep == TaskStatusStep.complete) {
                  context.read<DoctorReportsCubit>().setCompleted(id: currentTask.id, value: true);
                  widget.onStatusChanged?.call(currentTask.id, _statusStep);
                  _currentTaskIndex++;
                  _statusStep = _currentTaskIndex >= assignedTasks.length
                      ? TaskStatusStep.departure
                      : TaskStatusStep.departure;
                  return;
                }

                context.read<DoctorReportsCubit>().setStatusStep(
                      id: currentTask.id,
                      oldStatus: oldStatusStep,
                      status: _statusStep,
                    );
                widget.onStatusChanged?.call(currentTask.id, _statusStep);
              });
            },
          ),
          const SizedBox(height: 15),
          if(nexttask != null)
            Text('Next: $nextPatientName at $nextAppointmentTime', style: const TextStyle(fontSize: 16, color: Colors.black))
          else
            Text('No more appoinments for today', style: TextStyle(fontSize: 16, color: Colors.black)),
          //Text(
          //  'Task ${_initialTaskCount! - assignedTasks.length + 1} of $_initialTaskCount',
          //  style: const TextStyle(fontSize: 16, color: Colors.black),
          //),
          
        ],
      ),
    ),
  );
}

}
