import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ResetPasswordUseCase {
  final ForgotPasswordRepository repository;

  const ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return repository.resetPassword(
      token: token,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
