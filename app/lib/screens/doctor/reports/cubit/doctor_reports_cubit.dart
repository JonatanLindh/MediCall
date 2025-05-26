import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/contants/api.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

part 'doctor_reports_state.dart';

class DoctorReportsCubit extends Cubit<DoctorReportsState> {
  DoctorReportsCubit()
      : super(
          DoctorReportsInitial(),
        ) {
    initReports();
  }

  // TODO: Add method to fetch reports from backend API
  void filterStatus(ReportStatus status) {
    emit(state.copyWith(statusFilter: status));
  }

  Future<void> initReports() async {
    try {
      final reports = await getReports();
      emit(
        state.copyWith(
          reports: reports,
        ),
      );
    } catch (e) {
      log('Error fetching reports: $e');
      emit(state.copyWith(reports: []));
    }
  }

  Future<void> setMockReports() async {
    try {
      final reports = await mockReports();
      emit(
        state.copyWith(
          reports: reports,
          statusFilter: ReportStatus.all,
        ),
      );
    } catch (e) {
      log('Error fetching mock reports: $e');
      emit(state.copyWith(reports: []));
    }
  }

  void searchChanged(String searchText) {
    emit(
      state.copyWith(
        searchText: searchText,
      ),
    );
  }

  Future<void> setCompleted({required String id, required bool value}) async {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(completed: value);
      }
      return report;
    }).toList();

    await updateReport(
      id: id,
      completed: value,
    );

    emit(
      state.copyWith(
        reports: updatedReports,
      ),
    );
  }

  Future<void> assignToDoctor({
    required String id,
    required String doctorId,
  }) async {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(doctorId: doctorId);
      }
      return report;
    }).toList();

    await updateReport(
      id: id,
      assignToDoctorId: doctorId,
    );

    print('Assigning report $id to doctor $doctorId');

    emit(
      state.copyWith(
        reports: updatedReports,
      ),
    );
  }

  Future<void> unassignDoctor({required String id}) async {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(doctorId: null);
      }
      return report;
    }).toList();

    await updateReport(id: id, unassign: true);

    emit(
      state.copyWith(reports: updatedReports),
    );
  }

  Future<void> setStatusStep({
    required String id,
    required TaskStatusStep oldStatus,
    required TaskStatusStep status,
  }) async {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(statusStep: status);
      }
      return report;
    }).toList();

    await updateReport(
      id: id,
      status: status.toString(),
    );

    emit(
      state.copyWith(reports: updatedReports),
    );
  }
}

Future<String> createReport({
  required String patientId,
  required String description,
  required String time,
}) async {
  final body = <String, dynamic>{
    'patientId': patientId,
    'description': description,
    'time': time,
  };

  final response = await http.post(
    Uri.parse('$apiUrl/reports'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 201) {
    return response.body; // Assuming the response body contains the report ID
  } else {
    log('Failed to create report: ${response.statusCode}');
    throw Exception('Failed to create report');
  }
}

Future<Report> getReport(String reportId) async {
  final response = await http.get(
    Uri.parse('$apiUrl/reports/$reportId'),
  );

  if (response.statusCode == 200) {
    return Report.fromJson(response.body); // Assuming the response body is JSON
  } else {
    log('Failed to load report: ${response.statusCode}');
    throw Exception('Failed to load report');
  }
}

Future<List<Report>> getReports() async {
  final response = await http.get(Uri.parse('$apiUrl/reports'));

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.map((e) {
      final reportJson = e is String ? e : jsonEncode(e);
      return Report.fromJson(reportJson);
    }).toList();
  } else {
    log('Failed to load reports: ${response.statusCode}');
    throw Exception('Failed to load reports');
  }
}

Future<void> updateReport({
  required String id,
  String? status,
  bool? completed,
  String? assignToDoctorId,
  bool? unassign,
}) async {
  final body = <String, dynamic>{
    'status': status,
    'completed': completed,
    'assignToDoctorId': assignToDoctorId,
    'unassign': unassign,
  }..removeWhere((key, value) => value == null);

  await http
      .patch(
    Uri.parse('$apiUrl/reports/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  )
      .then((response) {
    if (response.statusCode != 200) {
      log('Failed to update report: ${response.statusCode}');
      throw Exception('Failed to update report');
    }
  });
}

Future<List<String>> getPatientIds() async {
  final response = await http.get(Uri.parse('$apiUrl/patients'));

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body) as List<dynamic>;

    // ignore: avoid_dynamic_calls
    return jsonList.map((e) {
      final entry = e is String
          ? jsonDecode(e) as Map<String, dynamic>
          : e as Map<String, dynamic>;
      return entry['id'] as String;
    }).toList();
  } else {
    log('Failed to load patients: ${response.statusCode}');
    throw Exception('Failed to load patients');
  }
}

Future<List<Report>> mockReports() async {
  final patients = await getPatientIds();

  for (final report in fakeReports) {
    final patientId = patients[Random().nextInt(patients.length)];
    await createReport(
      patientId: patientId,
      description: report.description,
      time: report.time,
    );
  }

  return getReports();
}
