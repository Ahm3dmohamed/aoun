import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:aoun/features/auth/register/data/datasources/register_remote_data_source.dart';
import 'package:aoun/features/auth/register/data/models/register_model.dart';
import 'package:aoun/features/auth/register/domain/entities/register_entity.dart';
import 'package:aoun/features/auth/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const RegisterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponseEntity>> register(RegisterEntity registerEntity) async {
    try {
      final model = RegisterModel.fromEntity(registerEntity);
      final response = await remoteDataSource.register(model);
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
