import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/contants/api.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final response = await http.post(
          Uri.parse('$apiUrl/patients/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': event.email, 'password': event.password}),
        );
        if (response.statusCode == 200) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure('Invalid email or password'));
        }
      } catch (e) {
        emit(LoginFailure('Error: $e'));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(LoginLoading());
      await registerUser(event, emit);
    });
  }

  Future<void> registerUser(
    RegisterEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/patients/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': event.firstName,
          'lastName': event.lastName,
          'email': event.email,
          'password': event.password,
        }),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 201) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Registration failed'));
      }
    } catch (e) {
      emit(LoginFailure('Error: $e'));
    }
  }
}
