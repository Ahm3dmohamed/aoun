import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';

abstract class RecommendationsRepository {
  Future<Either<Failure, List<RecommendationEntity>>> getRecommendations();
}
