import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/auth/log_in/data/models/auth_response_model.dart';
import 'package:aoun/features/auth/register/data/models/register_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class RegisterRemoteDataSource {
  Future<AuthResponseModel> register(RegisterModel registerModel);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final Dio dio;

  const RegisterRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> register(RegisterModel registerModel) async {
    const url = 'https://untakable-tien-unwadable.ngrok-free.dev/api/auth/register';

    try {
      final requestData = registerModel.toJson();
      debugPrint('[Register] Sending to $url');
      debugPrint('[Register] Request body: $requestData');

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('[Register] Status code: ${response.statusCode}');
      debugPrint('[Register] Response data: ${response.data}');

      // Check if success status code (200, 201 etc.)
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null) {
          throw const ServerException(message: 'Empty response from server');
        }
        final model = AuthResponseModel.fromJson(response.data);
        debugPrint('[Register] Parsed token: ${model.token}');
        debugPrint('[Register] Parsed userData: ${model.userData}');
        return model;
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to register',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('[Register] DioException: ${e.type} | ${e.response?.statusCode}');
      debugPrint('[Register] DioException response: ${e.response?.data}');
      // Parse DioException response content if available
      final String errorMessage = _parseDioErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      debugPrint('[Register] Unknown exception: $e');
      throw ServerException(message: e.toString());
    }
  }

  String _parseDioErrorMessage(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        // Look for common error keys in API responses: 'message', 'error', 'errors'
        if (data.containsKey('message') && data['message'] != null) {
          return data['message'].toString();
        }
        if (data.containsKey('error') && data['error'] != null) {
          return data['error'].toString();
        }
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            // Join validation error messages together
            final list = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                list.add(value.join(', '));
              } else {
                list.add(value.toString());
              }
            });
            if (list.isNotEmpty) {
              return list.join('\n');
            }
          } else if (errors is List) {
            return errors.join('\n');
          } else {
            return errors.toString();
          }
        }
      }
    }

    // Default error messaging based on DioExceptionType
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in association with server';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with server';
      case DioExceptionType.badCertificate:
        return 'Bad certificate from server';
      case DioExceptionType.badResponse:
        return 'Server returned error status code: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request to server was cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error, please check internet connection';
      case DioExceptionType.unknown:
      default:
        return 'Unexpected network error occurred';
    }
  }
}
