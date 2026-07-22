import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}
