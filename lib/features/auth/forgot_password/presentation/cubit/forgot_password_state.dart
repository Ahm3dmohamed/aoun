import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

// ── Forgot Password states ──────────────────────────────────────────────────

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

/// Emitted when the reset e-mail has been successfully sent.
/// [email] is carried forward so the Reset-Password screen can use it.
class ForgotPasswordEmailSent extends ForgotPasswordState {
  final String email;
  const ForgotPasswordEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  const ForgotPasswordFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// ── Reset Password states ────────────────────────────────────────────────────

class ResetPasswordLoading extends ForgotPasswordState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends ForgotPasswordState {
  const ResetPasswordSuccess();
}

class ResetPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  const ResetPasswordFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
