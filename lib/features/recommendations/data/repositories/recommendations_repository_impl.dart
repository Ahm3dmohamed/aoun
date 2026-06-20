import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/recommendations/data/datasources/recommendations_remote_data_source.dart';
import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:aoun/features/recommendations/domain/repositories/recommendations_repository.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsRemoteDataSource remoteDataSource;

  const RecommendationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RecommendationEntity>>> getRecommendations() async {
    try {
      final models = await remoteDataSource.getRecommendations();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
