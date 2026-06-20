import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/request_assistance/data/datasources/request_assistance_remote_data_source.dart';
import 'package:aoun/features/request_assistance/domain/entities/request_assistance_entity.dart';
import 'package:aoun/features/request_assistance/domain/repositories/request_assistance_repository.dart';

class RequestAssistanceRepositoryImpl implements RequestAssistanceRepository {
  final RequestAssistanceRemoteDataSource remoteDataSource;

  const RequestAssistanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> submitRequest(
    RequestAssistanceEntity entity,
  ) async {
    try {
      await remoteDataSource.submitRequest(entity);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
