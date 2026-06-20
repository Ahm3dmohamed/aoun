import 'package:aoun/features/auth/log_in/domain/entities/login_entity.dart';
import 'package:aoun/features/auth/log_in/domain/usecases/login_use_case.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(const LoginInitial());

  Future<void> loginUser(LoginEntity loginEntity) async {
    emit(const LoginLoading());

    final result = await loginUseCase(loginEntity);

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (response) => emit(LoginSuccess(response)),
    );
  }
}
