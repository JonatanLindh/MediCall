import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/contants/api.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

part 'doctor_reports_state.dart';

const String doctorId = 'cmav7q0450000woy0jw7em246';

class DoctorReportsCubit extends Cubit<DoctorReportsState> {
  DoctorReportsCubit()
      : super(
          DoctorReportsInitial(),
        ) //{print('DoctorReportsCubit created！！！: $this');  }
  ;
  // TODO: Add method to fetch reports from backend API
  void filterStatus(ReportStatus status) {
    emit(state.copyWith(statusFilter: status));
  }

  void searchChanged(String searchText) {
    emit(
      state.copyWith(
        searchText: searchText,
      ),
    );
  }

  void setCompleted({required String id, required bool value}) {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(completed: value);
      }
      return report;
    }).toList();

    setDoctorStatus(
      doctorId: doctorId,
      status: value ? 'completed' : 'not completed',
    );

    emit(
      state.copyWith(
        reports: updatedReports,
      ),
    );
  }

  void assignToDoctor({required String id, required String doctorId}) {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(assignedDoctorId: doctorId);
      }
      return report;
    }).toList();

    emit(
      state.copyWith(
        reports: updatedReports,
      ),
    );
  }

  void unassignDoctor({required String id}) {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(assignedDoctorId: null);
      }
      return report;
    }).toList();

    emit(
      state.copyWith(reports: updatedReports),
    );
  }

  void setStatusStep({required String id, required TaskStatusStep status}) {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(statusStep: status);
      }
      return report;
    }).toList();

    emit(
      state.copyWith(reports: updatedReports),
    );
  }
}

Future<void> setDoctorStatus({
  required String doctorId,
  required String status,
}) async {
  await http
      .patch(
    Uri.parse('$apiUrl/doctors/$doctorId/status'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: '{"status": "$status"}',
  )
      .then((response) {
    if (response.statusCode == 200) {
      // Successfully updated
    } else {
      // Handle error
      log('Failed to update doctor status: ${response.statusCode}');
    }
  });
}

Future<String> getDoctorStatus(String doctorId) async {
  final response = await http.get(
    Uri.parse('$apiUrl/doctors/$doctorId/status'),
  );

  if (response.statusCode == 200) {
    return response.body; // Assuming the response body contains the status
  } else {
    log('Failed to load doctor status: ${response.statusCode}');
    throw Exception('Failed to load doctor status');
  }
}
