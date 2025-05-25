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

  Future<List<Doctor>> getAllDoctors() async {
    final doctors = <Doctor>[
      const Doctor(
        id: '1',
        name: 'Dr. Alice Smith',
        imageUrl:
            'https://img.freepik.com/premium-vector/female-doctor-character-physician-hospital-checkup-patient-healthy-treatment-personnel_505557-11354.jpg?semt=ais_hybrid&w=740',
      ),
      const Doctor(
        id: '2',
        name: 'Dr. Bob Johnson',
        imageUrl:
            'https://www.shutterstock.com/image-vector/male-doctor-smiling-selfconfidence-flat-260nw-2281709217.jpg',
      ),
      const Doctor(
        id: '3',
        name: 'Dr. Carol Lee',
        imageUrl:
            'https://www.shutterstock.com/image-vector/male-doctor-smiling-selfconfidence-flat-260nw-2281709217.jpg',
      ),
      const Doctor(
        id: '4',
        name: 'Dr. David Kim',
        imageUrl:
            'https://www.shutterstock.com/image-vector/male-doctor-smiling-selfconfidence-flat-260nw-2281709217.jpg',
      ),
      const Doctor(
        id: '5',
        name: 'Dr. David Kim',
        imageUrl:
            'https://images.unsplash.com/vector-1743527707498-bee7b10a6d00?q=80&w=3322&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
    ];

    return doctors;
  }

  Future<List<Visit>> getAllVisits() async {
    final doctors = await getAllDoctors();
    final visits = <Visit>[
      Visit(
        id: 'visit1',
        doctor: doctors[0],
        date: DateTime.now().add(const Duration(hours: 5)),
      ),
      Visit(
        id: 'visit2',
        doctor: doctors[1],
        date: DateTime.now().add(const Duration(days: 2)),
      ),
      Visit(
        id: 'visit3',
        doctor: doctors[2],
        date: DateTime.now().add(const Duration(days: 2)),
      ),
      Visit(
        id: 'visit4',
        doctor: doctors[3],
        date: DateTime.now().add(const Duration(days: 3)),
      ),
      Visit(
        id: 'visit5',
        doctor: doctors[4],
        date: DateTime.now().add(const Duration(days: 4)),
      ),
    ];

    return visits;
  }
}

class Visit extends Equatable {
  const Visit({required this.id, required this.doctor, required this.date});

  final String id;
  final Doctor doctor;
  final DateTime date;

  @override
  List<Object?> get props => [id, doctor, date];
}

class Doctor extends Equatable {
  const Doctor({required this.id, required this.name, required this.imageUrl});
  final String id;
  final String name;
  final String imageUrl;

  @override
  List<Object?> get props => [id, name];
}
