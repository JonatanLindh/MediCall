part of 'doctor_reports_cubit.dart';

enum ReportStatus { unresolved, resolved, all }

class DoctorReportsState {
  DoctorReportsState(this.reports, this.statusFilter, this.searchText)
      : unresolvedCount = reports.where((r) => !r.resolved).length,
        resolvedCount = reports.where((r) => r.resolved).length,
        allCount = reports.length,
        filteredReports = reports.where((report) {
          final matchStatus = statusFilter == ReportStatus.all ||
              (statusFilter == ReportStatus.resolved && report.resolved) ||
              (statusFilter == ReportStatus.unresolved && !report.resolved);

          final matchSearch = '${report.name} ${report.description}'
              .toLowerCase()
              .contains(searchText.toLowerCase());

          return matchStatus && matchSearch;
        }).toList();

  final List<Report> reports;

  final int unresolvedCount;
  final int resolvedCount;
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
  DoctorReportsInitial() : super(fakeReports, ReportStatus.unresolved, '');
}
