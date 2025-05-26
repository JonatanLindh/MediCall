import 'dart:convert';

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
    required this.completed,
    required this.statusStep,
    required this.patientId,
    required this.doctorId,
    this.doctorName,
  });

  factory Report.fromJson(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;

    final patient = json['patient'] != null
        ? (json['patient'] is String
            ? jsonDecode(json['patient'] as String) as Map<String, dynamic>
            : json['patient'] as Map<String, dynamic>)
        : null;

    final doctor = json['doctor'] != null
        ? (json['doctor'] is String
            ? jsonDecode(json['doctor'] as String) as Map<String, dynamic>
            : json['doctor'] as Map<String, dynamic>)
        : null;

    return Report(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      name: patient?['firstName'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      time: json['time'] as String? ?? '',
      doctorName: doctor?['firstName'] as String?,
      doctorId: doctor?['id'] as String?,
      completed: json['completed'] as bool? ?? false,
      statusStep: json['statusStep'] != null
          ? TaskStatusStep.values.firstWhere(
              (e) => e.toString() == 'TaskStatusStep.${json['statusStep']}',
              orElse: () => TaskStatusStep.departure,
            )
          : TaskStatusStep.departure,
    );
  }

  final String id;
  final String name;
  final String description;
  final String time;
  final String? doctorName;
  final String patientId;
  final String? doctorId;
  final bool completed;
  final TaskStatusStep statusStep;

  Report copyWith({
    String? id,
    String? name,
    String? description,
    String? time,
    Object? doctorId = const Object(),
    bool? completed,
    TaskStatusStep? statusStep,
  }) {
    return Report(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
      doctorId: identical(doctorId, const Object())
          ? this.doctorId
          : doctorId as String?, // allow null
      completed: completed ?? this.completed,
      statusStep: statusStep ?? this.statusStep,
      patientId: patientId,
      doctorName: doctorName,
    );
  }
}

class MockReport {
  MockReport({
    required this.name,
    required this.description,
    required this.time,
  });

  final String name;
  final String description;
  final String time;
}

final List<MockReport> fakeReports = [
  MockReport(
    name: 'Anna Ericsson',
    description: 'Suspected heart attack',
    time: '09:30 AM',
  ),
  MockReport(
    name: 'Sven Pettersson',
    description: 'Fever',
    time: 'April 14',
  ),
  MockReport(
    name: 'Lisa Karlsson',
    description: 'Blood pressure abnormal',
    time: '11:00 AM',
  ),
  MockReport(
    name: 'Erik Andersson',
    description: 'Severe headache',
    time: '13:00 PM',
  ),
];
