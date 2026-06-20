import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/auth/log_in/domain/repositories/login_repository.dart';

class LogoutUseCase {
  final LoginRepository repository;

  const LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
