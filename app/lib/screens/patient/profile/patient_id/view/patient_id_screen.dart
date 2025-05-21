import 'package:flutter/material.dart';

class PatientIdScreen extends StatelessWidget {
  const PatientIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient ID')),
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

            // Row 1
            _FormRow(
              fields: [
                _DropdownField(label: 'Sex'),
                _DropdownField(label: 'Age'),
              ],
            ),
            SizedBox(height: 16),

            // Row 2
            _FormRow(
              fields: [
                _DropdownField(label: 'Blood Type'),
                _DropdownField(label: 'Primary Language'),
              ],
            ),
            SizedBox(height: 16),

            // Row 3
            _FormRow(
              fields: [
                _DropdownField(label: 'Weight'),
                _DropdownField(label: 'Height'),
              ],
            ),
            SizedBox(height: 24),

            Text('Emergency Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
            _FormRow(
              fields: [
                _DropdownField(label: 'Relationship'),
                _TextField(label: 'Name'),
              ],
            ),
            SizedBox(height: 16),
            _TextField(label: 'Number'),
            SizedBox(height: 24),

            Text('Allergies', style: TextStyle(fontWeight: FontWeight.bold)),
            _TextField(label: ''),
            SizedBox(height: 24),

            Text('Wheelchair', style: TextStyle(fontWeight: FontWeight.bold)),
            _DropdownField(label: 'No'),
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

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: const [],
      onChanged: (value) {},
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
