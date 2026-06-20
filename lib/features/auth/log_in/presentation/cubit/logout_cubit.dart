import 'package:aoun/features/auth/log_in/domain/usecases/logout_use_case.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(const LogoutInitial());

  Future<void> logout() async {
    emit(const LogoutLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(LogoutFailure(failure.message)),
      (_) => emit(const LogoutSuccess()),
    );
  }
}
