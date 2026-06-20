import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:aoun/features/recommendations/domain/repositories/recommendations_repository.dart';

class GetRecommendationsUseCase {
  final RecommendationsRepository repository;

  const GetRecommendationsUseCase(this.repository);

  Future<Either<Failure, List<RecommendationEntity>>> call() {
    return repository.getRecommendations();
  }
}
