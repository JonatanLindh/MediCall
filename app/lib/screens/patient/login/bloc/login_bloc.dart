import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/contants/api.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial(isDoctor: false)) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading(isDoctor: state.isDoctor));

      try {
        final response = await http.post(
          Uri.parse('$apiUrl/${ep()}/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': event.email, 'password': event.password}),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          log('Login successful: $data');
          final id = data['id'] as String;

          emit(LoginSuccess(isDoctor: state.isDoctor, id: id));
        } else {
          emit(
            LoginFailure(
              'Invalid email or password',
              isDoctor: state.isDoctor,
            ),
          );
        }
      } catch (e) {
        emit(LoginFailure('Error: $e', isDoctor: state.isDoctor));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(LoginLoading(isDoctor: state.isDoctor));
      await registerUser(event, emit);
    });

    on<ToggleIsDoctor>((event, emit) {
      emit(LoginInitial(isDoctor: !state.isDoctor));
    });
  }

  String ep() => state.isDoctor ? 'doctors' : 'patients';

  Future<void> registerUser(
    RegisterEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/${ep()}/register'),
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
        final data = jsonDecode(response.body);
        log('Registration successful: $data');
        final id = data['id'] as String;
        emit(LoginSuccess(isDoctor: state.isDoctor, id: id));
      } else {
        emit(LoginFailure('Registration failed', isDoctor: state.isDoctor));
      }
    } catch (e) {
      emit(LoginFailure('Error: $e', isDoctor: state.isDoctor));
    }
  }

  String getDoctorId() {
    if (state is LoginSuccess && state.isDoctor) {
      return (state as LoginSuccess).id;
    }
    throw Exception('Doctor ID not available');
  }
}
