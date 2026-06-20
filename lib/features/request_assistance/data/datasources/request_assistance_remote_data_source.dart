import 'dart:io';

import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/request_assistance/domain/entities/request_assistance_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class RequestAssistanceRemoteDataSource {
  Future<void> submitRequest(RequestAssistanceEntity entity);
}

class RequestAssistanceRemoteDataSourceImpl
    implements RequestAssistanceRemoteDataSource {
  final Dio dio;

  const RequestAssistanceRemoteDataSourceImpl(this.dio);

  static const String _baseUrl =
      'https://untakable-tien-unwadable.ngrok-free.dev';

  @override
  Future<void> submitRequest(RequestAssistanceEntity entity) async {
    const url = '$_baseUrl/api/assistance-requests';

    try {
      debugPrint('[RequestAssistance] Sending POST to $url');

      final formData = FormData.fromMap({
        'foundation_name': entity.foundationName,
        'location': entity.location,
        'title': entity.title,
        'details': entity.description,
        'category': entity.category,
        'urgency': entity.urgency,
        'target_amount': entity.requiredAmount.toString(),
        if (entity.files != null && entity.files!.isNotEmpty)
          'files[]': [
            for (var file in entity.files!)
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split(Platform.pathSeparator).last,
              )
          ]
      });

      debugPrint('[RequestAssistance] Payload: foundation_name=${entity.foundationName}, '
          'category=${entity.category}, urgency=${entity.urgency}, '
          'location=${entity.location}, target_amount=${entity.requiredAmount}, '
          'files_count=${entity.files?.length ?? 0}');

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      debugPrint('[RequestAssistance] Status: ${response.statusCode}');
      debugPrint('[RequestAssistance] Response: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to submit request',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        '[RequestAssistance] DioException: ${e.type} | ${e.response?.statusCode}',
      );
      debugPrint('[RequestAssistance] Response body: ${e.response?.data}');
      throw ServerException(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('[RequestAssistance] Unknown error: $e');
      throw ServerException(message: e.toString());
    }
  }

  String _parseDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        if (data['message'] != null) return data['message'].toString();
        if (data['error'] != null) return data['error'].toString();
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            return errors.values
                .map((v) => v is List ? v.join(', ') : v.toString())
                .join('\n');
          }
          return errors.toString();
        }
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in association with server';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with server';
      case DioExceptionType.badResponse:
        return 'Server returned error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'Connection error, please check internet connection';
      default:
        return 'Unexpected network error occurred';
    }
  }
}
