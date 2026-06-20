import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/cases/data/datasources/cases_remote_data_source.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/cases/domain/repositories/cases_repository.dart';

class CasesRepositoryImpl implements CasesRepository {
  final CasesRemoteDataSource remoteDataSource;

  const CasesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CaseEntity>>> getCases({int page = 1}) async {
    try {
      final cases = await remoteDataSource.getCases(page: page);
      return Right(cases);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
