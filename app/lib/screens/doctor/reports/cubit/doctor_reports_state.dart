part of 'doctor_reports_cubit.dart';

enum ReportStatus { unassigned, assigned, completed, all }

class DoctorReportsState {
  DoctorReportsState(this.reports, this.statusFilter, this.searchText)
      : unassignedCount = reports.where((r) => r.assignedDoctorId == null).length,
        assignedCount = reports.where((r) => r.assignedDoctorId != null && !r.completed).length,
        completedCount = reports.where((r) => r.assignedDoctorId != null && r.completed).length,
        allCount = reports.length,
        filteredReports = reports.where((report) {
          final matchStatus =
              statusFilter == ReportStatus.all ||
              (statusFilter == ReportStatus.unassigned && report.assignedDoctorId == null) ||
              (statusFilter == ReportStatus.assigned &&
                  report.assignedDoctorId != null && !report.completed) ||
              (statusFilter == ReportStatus.completed &&
                  report.assignedDoctorId != null && report.completed);

          final matchSearch = '${report.name} ${report.description}'
              .toLowerCase()
              .contains(searchText.toLowerCase());

          return matchStatus && matchSearch;
        }).toList();

  final List<Report> reports;

  final int unassignedCount;
  final int assignedCount;
  final int completedCount;
  final int allCount;

  final String searchText;
  final ReportStatus statusFilter;
  final List<Report> filteredReports;

  DoctorReportsState copyWith({
    List<Report>? reports,
    ReportStatus? statusFilter,
    String? searchText,
  }) {
    return DoctorReportsState(
      reports ?? this.reports,
      statusFilter ?? this.statusFilter,
      searchText ?? this.searchText,
    );
  }
}

final class DoctorReportsInitial extends DoctorReportsState {
  DoctorReportsInitial() : super(fakeReports, ReportStatus.assigned, '');
}
