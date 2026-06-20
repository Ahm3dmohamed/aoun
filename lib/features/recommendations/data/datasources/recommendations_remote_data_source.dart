import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/features/recommendations/data/models/recommendation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class RecommendationsRemoteDataSource {
  Future<List<RecommendationModel>> getRecommendations();
}

class RecommendationsRemoteDataSourceImpl
    implements RecommendationsRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;

  static const String _baseUrl =
      'https://untakable-tien-unwadable.ngrok-free.dev';

  const RecommendationsRemoteDataSourceImpl(this.dio, this.authLocalDataSource);

  @override
  Future<List<RecommendationModel>> getRecommendations() async {
    const url = '$_baseUrl/api/ai/recommendations/generate';
    debugPrint('[Recommendations] POST $url');

    // Read the stored user data to send user_id in the body
    final userData = await authLocalDataSource.getUserData();
    final userId = userData?['id'];
    debugPrint('[Recommendations] user_id=$userId');

    try {
      final response = await dio.post(
        url,
        data: userId != null ? {'user_id': userId} : null,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      debugPrint('[Recommendations] Status: ${response.statusCode}');
      debugPrint('[Recommendations] Raw response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        List<dynamic> rawList;
        if (data is List) {
          rawList = data;
        } else if (data is Map && data['data'] is List) {
          rawList = data['data'] as List<dynamic>;
        } else if (data is Map && data['recommendations'] is List) {
          rawList = data['recommendations'] as List<dynamic>;
        } else if (data is Map && data['cases'] is List) {
          rawList = data['cases'] as List<dynamic>;
        } else if (data is Map && data['result'] is List) {
          rawList = data['result'] as List<dynamic>;
        } else {
          debugPrint('[Recommendations] Unhandled response shape: $data');
          return [];
        }

        debugPrint('[Recommendations] Fetched ${rawList.length} items');
        return rawList
            .map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        message: 'Failed to load recommendations',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint(
        '[Recommendations] DioException: ${e.type} | ${e.response?.statusCode}',
      );
      debugPrint('[Recommendations] Response: ${e.response?.data}');

      final statusCode = e.response?.statusCode;
      String message;

      switch (statusCode) {
        case 401:
          message = 'Unauthorized. Please log in again.';
          break;
        case 404:
          message = 'Recommendations endpoint not found.';
          break;
        case 422:
          final errors = e.response?.data?['errors'];
          message = errors?.toString() ?? 'Validation error.';
          break;
        case 500:
          message = 'Server error. Please try again later.';
          break;
        default:
          message = e.message ?? 'Network error occurred.';
      }

      throw ServerException(message: message, statusCode: statusCode);
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('[Recommendations] Unexpected error: $e');
      throw ServerException(message: e.toString());
    }
  }
}
