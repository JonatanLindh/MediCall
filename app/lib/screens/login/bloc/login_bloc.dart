import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/login'),
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
  }
}
