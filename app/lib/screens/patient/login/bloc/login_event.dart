part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginButtonPressed extends LoginEvent {
  LoginButtonPressed({required this.email, required this.password});

  final String email;
  final String password;
}
