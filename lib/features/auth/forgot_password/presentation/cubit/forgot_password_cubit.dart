import 'package:aoun/features/auth/forgot_password/domain/usecases/forgot_password_use_case.dart';
import 'package:aoun/features/auth/forgot_password/domain/usecases/reset_password_use_case.dart';
import 'package:aoun/features/auth/forgot_password/presentation/cubit/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit({
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
  }) : super(const ForgotPasswordInitial());

  /// Step 1 – send the reset link to [email].
  Future<void> sendResetLink(String email) async {
    emit(const ForgotPasswordLoading());

    final result = await forgotPasswordUseCase(email);

    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.message)),
      (_) => emit(ForgotPasswordEmailSent(email)),
    );
  }

  /// Step 2 – submit the new password with the token received by e-mail.
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ResetPasswordLoading());

    final result = await resetPasswordUseCase(
      token: token,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
      (failure) => emit(ResetPasswordFailure(failure.message)),
      (_) => emit(const ResetPasswordSuccess()),
    );
  }

  /// Resets the cubit back to the initial state.
  void reset() => emit(const ForgotPasswordInitial());
}
