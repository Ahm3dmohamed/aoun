import 'package:equatable/equatable.dart';

abstract class RequestAssistanceState extends Equatable {
  const RequestAssistanceState();

  @override
  List<Object?> get props => [];
}

class RequestAssistanceInitial extends RequestAssistanceState {
  const RequestAssistanceInitial();
}

class RequestAssistanceLoading extends RequestAssistanceState {
  const RequestAssistanceLoading();
}

class RequestAssistanceSuccess extends RequestAssistanceState {
  const RequestAssistanceSuccess();
}

class RequestAssistanceFailure extends RequestAssistanceState {
  final String errorMessage;

  const RequestAssistanceFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
