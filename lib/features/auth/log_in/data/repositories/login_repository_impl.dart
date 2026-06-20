import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/features/auth/log_in/data/datasources/login_remote_data_source.dart';
import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:aoun/features/auth/log_in/domain/entities/login_entity.dart';
import 'package:aoun/features/auth/log_in/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.deleteToken();
      await localDataSource.deleteUserData();
      return const Right(null);
    } on ServerException catch (e) {
      // Clear token locally anyway to avoid locking the user in
      await localDataSource.deleteToken();
      await localDataSource.deleteUserData();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await localDataSource.deleteToken();
      await localDataSource.deleteUserData();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> login(LoginEntity loginEntity) async {
    try {
      final response = await remoteDataSource.login(loginEntity);
      if (response.token.isNotEmpty) {
        await localDataSource.saveToken(response.token);
      }
      if (response.userData != null) {
        await localDataSource.saveUserData(response.userData!);
      }
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
