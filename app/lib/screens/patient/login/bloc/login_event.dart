part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class ToggleIsDoctor extends LoginEvent {}

final class LoginButtonPressed extends LoginEvent {
  LoginButtonPressed({required this.email, required this.password});

  final String email;
  final String password;
}

final class RegisterEvent extends LoginEvent {
  RegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
}
