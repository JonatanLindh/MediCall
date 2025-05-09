class Report {
  Report({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    this.resolved = false,
  });

  final String id;
  final String name;
  final String description;
  final String time;
  bool resolved;
}

final List<Report> fakeReports = [
  Report(
    id: '1',
    name: 'Anna Ericsson',
    description: 'Suspected heart attack',
    time: '09:34 AM',
  ),
  Report(
    id: '2',
    name: 'Sven Pettersson',
    description: 'Fever',
    time: 'April 14',
    resolved: true,
  ),
];
