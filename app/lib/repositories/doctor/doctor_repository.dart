import 'package:equatable/equatable.dart';

// ignore_for_file: use_setters_to_change_properties

class DoctorRepository {
  Doctor? doctor;

  void setSelectedDoctor(Doctor doctor) {
    this.doctor = doctor;
  }

  Doctor? getSelectedDoctor() {
    return doctor;
  }

  List<Doctor> getAllDoctors() {
    final doctors = <Doctor>[
      const Doctor(id: '1', name: 'Dr. Alice Smith'),
      const Doctor(id: '2', name: 'Dr. Bob Johnson'),
      const Doctor(id: '3', name: 'Dr. Carol Lee'),
      const Doctor(id: '4', name: 'Dr. David Kim'),
    ];
    return doctors;
  }
}

class Doctor extends Equatable {
  const Doctor({required this.id, required this.name});
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
