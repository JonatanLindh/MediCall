import 'package:bloc/bloc.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

part 'doctor_reports_state.dart';

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
