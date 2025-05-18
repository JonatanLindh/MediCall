import 'package:flutter/material.dart';

class HealthDetailScreen extends StatelessWidget {
  const HealthDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Center(
              child: Text(
                'Anna Ericsson',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),

            Text('Medication Info', style: TextStyle(fontWeight: FontWeight.bold)),
            _FormRow(fields: [
              _TextField(label: 'Medication Name'),
              _TextField(label: 'Dosage Frequency'),
            ],),
            _FormRow(fields: [
              _TextField(label: 'Medication Name'),
              _TextField(label: 'Dosage Frequency'),
            ],),
            SizedBox(height: 24),

            Text('Chronic Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
            _TextField(label: 'Condition Name'),
            _DropdownField(label: 'Diagnosed Since'),
            _TextField(label: 'Medical Note :', maxLines: 3),
          ],
        ),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.fields});
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: fields
          .map((f) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 8), child: f)))
          .toList(),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.label, this.maxLines = 1});
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: const [],
        onChanged: (value) {},
      ),
    );
  }
}
