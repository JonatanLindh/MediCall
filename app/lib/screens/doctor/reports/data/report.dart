import 'package:flutter/material.dart';

enum TaskStatusStep {
  departure,
  arrival,
  complete,
}

class Report {
  Report({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    this.assignedDoctorId,
    required this.completed,
    required this.statusStep,

  });

  final String id;
  final String name;
  final String description;
  final String time;

  final String? assignedDoctorId; // null 
  final bool completed; // true 
  final TaskStatusStep statusStep; // default is receiving


  Report copyWith({
    String? id,
    String? name,
    String? description,
    String? time,
    String? assignedDoctorId,
    bool? completed,
    TaskStatusStep? statusStep,
  }) {
    return Report(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
      assignedDoctorId: this.assignedDoctorId,
      completed: completed ?? this.completed,
      statusStep: statusStep ?? this.statusStep,
    );
  }
}



final List<Report> fakeReports = [
  Report(
    id: '1',
    name: 'Anna Ericsson',
    description: 'Suspected heart attack',
    time: '09:34 AM',
    assignedDoctorId: null, // not assigned
    completed: false, 
    statusStep: TaskStatusStep.departure,
  ),
  Report(
    id: '2',
    name: 'Sven Pettersson',
    description: 'Fever',
    time: 'April 14',
    assignedDoctorId: 'Dr. Emma Lundgren',
    completed: true, 
    statusStep: TaskStatusStep.complete,
  ),
  Report(
    id: '3',
    name: 'Lisa Karlsson',
    description: 'Blood pressure abnormal',
    time: '11:00 AM',
    assignedDoctorId: 'Dr. Johan Nilsson',
    completed: false, 
    statusStep: TaskStatusStep.departure,
  ),
  Report(
    id: '4',
    name: 'Erik Andersson',
    description: 'Severe headache',
    time: 'April 14',
    assignedDoctorId: 'Dr. Johan Nilsson', 
    completed: false, 
    statusStep: TaskStatusStep.departure,
  ),
];
