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
    final updatedReports = state.reports;
    for (final report in updatedReports) {
      if (report.id == id) {
        report.resolved = value;
        break;
      }
    }

    emit(
      state.copyWith(
        reports: updatedReports,
      ),
    );
  }
}
