import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object?> get props => [];
}

class RecommendationsInitial extends RecommendationsState {
  const RecommendationsInitial();
}

class RecommendationsLoading extends RecommendationsState {
  const RecommendationsLoading();
}

class RecommendationsLoaded extends RecommendationsState {
  final List<RecommendationEntity> recommendations;

  const RecommendationsLoaded(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationsError extends RecommendationsState {
  final String message;

  const RecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}
