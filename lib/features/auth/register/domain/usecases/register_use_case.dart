import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:aoun/features/auth/register/domain/entities/register_entity.dart';
import 'package:aoun/features/auth/register/domain/repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  const RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(RegisterEntity registerEntity) {
    return repository.register(registerEntity);
  }
}
