import 'package:aoun/features/request_assistance/domain/entities/request_assistance_entity.dart';
import 'package:aoun/features/request_assistance/domain/usecases/submit_request_assistance_use_case.dart';
import 'package:aoun/features/request_assistance/presentation/cubit/request_assistance_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestAssistanceCubit extends Cubit<RequestAssistanceState> {
  final SubmitRequestAssistanceUseCase submitUseCase;

  RequestAssistanceCubit(this.submitUseCase)
      : super(const RequestAssistanceInitial());

  Future<void> submitRequest(RequestAssistanceEntity entity) async {
    emit(const RequestAssistanceLoading());
    debugPrint('[RequestAssistanceCubit] Submitting request...');

    final result = await submitUseCase(entity);

    result.fold(
      (failure) {
        debugPrint('[RequestAssistanceCubit] Failure: ${failure.message}');
        emit(RequestAssistanceFailure(failure.message));
      },
      (_) {
        debugPrint('[RequestAssistanceCubit] Success!');
        emit(const RequestAssistanceSuccess());
      },
    );
  }
}
