import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:aoun/features/auth/log_in/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, AuthResponseEntity>> login(LoginEntity loginEntity);
  Future<Either<Failure, void>> logout();
}
