import 'package:flutter/material.dart';

class DoctorReportsScreen extends StatefulWidget {
  const DoctorReportsScreen({super.key});

  @override
  State<DoctorReportsScreen> createState() => _DoctorReportsPageState();
}

class _DoctorReportsPageState extends State<DoctorReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'unresolved'; // 'unresolved' or 'resolved'

  final List<Report> _reports = [
    Report(name: 'Anna Ericsson', description: 'Suspected heart attack', time: '09:34 AM', resolved: false),
    Report(name: 'Sven Pettersson', description: 'Fever', time: 'April 14', resolved: true),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredReports = _reports.where((r) {
      final matchFilter = _filter == 'unresolved'
          ? !r.resolved
          : _filter == 'resolved'
              ? r.resolved
              : true; // 'all' case
      final matchSearch = '${r.name} ${r.description}'.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();

    final unresolvedCount = _reports.where((r) => !r.resolved).length;
    final resolvedCount = _reports.where((r) => r.resolved).length;
    final allCount = _reports.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Unresolved ($unresolvedCount)'),
                      onTap: () {
                        setState(() => _filter = 'unresolved');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Resolved ($resolvedCount)'),
                      onTap: () {
                        setState(() => _filter = 'resolved');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('All ($allCount)'),
                      onTap: () {
                        setState(() => _filter = 'all');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reports...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => setState(() => _filter = 'unresolved'),
                child: Text('Unresolved ($unresolvedCount)'),
              ),
              TextButton(
                onPressed: () => setState(() => _filter = 'resolved'),
                child: Text('Resolved ($resolvedCount)'),
              ),
              TextButton(
                onPressed: () => setState(() => _filter = 'all'),
                child: Text('All ($allCount)'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return ListTile(
                  title: Text(report.name),
                  subtitle: Text(report.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(report.time),
                      Checkbox(
                        value: report.resolved,
                        onChanged: (val) {
                          setState(() {
                            report.resolved = val!;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Report {
  final String name;
  final String description;
  final String time;
  bool resolved;

  Report({
    required this.name,
    required this.description,
    required this.time,
    this.resolved = false,
  });
}

