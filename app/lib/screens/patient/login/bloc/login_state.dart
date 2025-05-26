part of 'login_bloc.dart';

@immutable
sealed class LoginState {
  const LoginState({required this.isDoctor});

  final bool isDoctor;
}

final class LoginInitial extends LoginState {
  const LoginInitial({required super.isDoctor});
}

final class LoginLoading extends LoginState {
  const LoginLoading({required super.isDoctor});
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required super.isDoctor, required this.id});
  final String id;
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.message, {required super.isDoctor});
  final String message;
}
