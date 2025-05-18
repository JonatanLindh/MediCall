abstract class PatientIdState {}

class PatientIdInitial extends PatientIdState {}

class PatientIdLoaded extends PatientIdState { 

  PatientIdLoaded(this.exampleField);
  final String exampleField;
}
