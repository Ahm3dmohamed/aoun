import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:aoun/features/auth/log_in/domain/entities/login_entity.dart';
import 'package:aoun/features/auth/log_in/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  const LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(LoginEntity loginEntity) {
    return repository.login(loginEntity);
  }
}
