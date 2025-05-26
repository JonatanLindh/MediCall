import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicall/repositories/call/call_repository.dart';
import 'package:medicall/repositories/doctor/doctor_repository.dart';

part 'incoming_calls_state.dart';

class IncomingCallsCubit extends Cubit<IncomingCallsState> {
  IncomingCallsCubit(this._callRepository)
      : super(const IncomingCallsInitial());
  final CallRepository _callRepository;

  Future<void> getAllIncomingCalls() async {
    emit(const IncomingCallsLoading());
    final incomingCalls = await _callRepository.getAllRooms();

    emit(IncomingCallsLoaded(incomingCalls));
  }
}
