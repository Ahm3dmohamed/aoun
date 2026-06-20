import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/cases/data/models/case_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class CasesRemoteDataSource {
  Future<List<CaseModel>> getCases({int page = 1});
}

class CasesRemoteDataSourceImpl implements CasesRemoteDataSource {
  final Dio dio;

  const CasesRemoteDataSourceImpl(this.dio);

  static const _baseUrl =
      'https://untakable-tien-unwadable.ngrok-free.dev/api/cases';

  @override
  Future<List<CaseModel>> getCases({int page = 1}) async {
    try {
      final response = await dio.get(
        _baseUrl,
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final List<dynamic> items = data['data'] as List<dynamic>? ?? [];
        debugPrint('[Cases] Fetched ${items.length} cases');
        return items
            .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        message: 'Failed to load cases',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('[Cases] DioException: ${e.message}');
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('[Cases] Exception: $e');
      throw ServerException(message: e.toString());
    }
  }
}
