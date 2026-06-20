import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:aoun/features/recommendations/domain/usecases/get_recommendations_use_case.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final GetRecommendationsUseCase getRecommendationsUseCase;

  /// In-memory cache to avoid redundant API calls
  List<RecommendationEntity>? _cachedRecommendations;

  RecommendationsCubit(this.getRecommendationsUseCase)
    : super(const RecommendationsInitial());

  /// Load recommendations, uses cache if already loaded
  Future<void> loadRecommendations({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedRecommendations != null) {
      debugPrint('[RecommendationsCubit] Using cached recommendations');
      emit(RecommendationsLoaded(_cachedRecommendations!));
      return;
    }

    emit(const RecommendationsLoading());
    debugPrint('[RecommendationsCubit] Fetching recommendations from API...');

    final result = await getRecommendationsUseCase();

    result.fold(
      (failure) {
        debugPrint('[RecommendationsCubit] Failure: ${failure.message}');
        emit(RecommendationsError(failure.message));
      },
      (recommendations) {
        final filteredRecommendations = recommendations
            .where((r) => r.imagePath != null && r.imagePath!.isNotEmpty)
            .toList();
        debugPrint(
          '[RecommendationsCubit] Loaded ${recommendations.length} recommendations',
        );
        _cachedRecommendations = recommendations;
        emit(RecommendationsLoaded(recommendations));
      },
    );
  }

  /// Force refresh, bypassing the cache
  Future<void> refresh() => loadRecommendations(forceRefresh: true);

  /// Clear cache (e.g. on logout)
  void clearCache() {
    _cachedRecommendations = null;
  }
}
