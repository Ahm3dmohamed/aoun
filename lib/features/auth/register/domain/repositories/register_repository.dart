import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:aoun/features/auth/register/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<Either<Failure, AuthResponseEntity>> register(RegisterEntity registerEntity);
}
