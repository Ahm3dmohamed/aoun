import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final AuthResponseEntity authResponse;

  const RegisterSuccess(this.authResponse);

  @override
  List<Object?> get props => [authResponse];
}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  const RegisterFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
