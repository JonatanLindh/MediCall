abstract class PatientIdState {}

class PatientIdInitial extends PatientIdState {}

class PatientIdLoaded extends PatientIdState {
  final String exampleField; 

  PatientIdLoaded(this.exampleField);
}
