import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/cases/data/models/case_model.dart';
import 'package:aoun/features/home/data/datasources/home_remote_data_source.dart';
import 'package:aoun/features/home/domain/entities/case_entity.dart';
import 'package:aoun/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CaseModel>>> getCases({int page = 1}) async {
    try {
      final cases = await remoteDataSource.getCases();
      return Right(cases);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
