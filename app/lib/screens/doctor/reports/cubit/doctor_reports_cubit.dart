import 'package:bloc/bloc.dart';
import 'package:medicall/screens/doctor/reports/data/report.dart';

part 'doctor_reports_state.dart';

class DoctorReportsCubit extends Cubit<DoctorReportsState> {
  DoctorReportsCubit() : super(DoctorReportsInitial());

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

  void setResolved({required String id, required bool value}) {
    final updatedReports = state.reports.map((report) {
      if (report.id == id) {
        return report.copyWith(resolved: value);
      }
      return report;
    }).toList();

    emit(
      state.copyWith(
        reports: updatedReports,
      ),
    );
  }
}
