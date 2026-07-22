import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordUseCase {
  final ForgotPasswordRepository repository;

  const ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) {
    return repository.forgotPassword(email);
  }
}
