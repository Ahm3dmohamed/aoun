import 'package:aoun/core/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ForgotPasswordRemoteDataSource {
  /// Sends a password-reset email to [email].
  Future<void> forgotPassword(String email);

  /// Resets the password using [token], [email], [password] and [passwordConfirmation].
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final Dio dio;

  const ForgotPasswordRemoteDataSourceImpl(this.dio);

  static const _baseUrl =
      'https://untakable-tien-unwadable.ngrok-free.dev/api/auth';

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<void> forgotPassword(String email) async {
    const url = '$_baseUrl/forgot-password';

    try {
      final response = await dio.post(
        url,
        data: {'email': email},
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerException(
          message:
              response.data?['message'] ?? 'Failed to send reset email',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    const url = '$_baseUrl/reset-password';

    try {
      final response = await dio.post(
        url,
        data: {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to reset password',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  String _parseDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        if (data.containsKey('message') && data['message'] != null) {
          return data['message'].toString();
        }
        if (data.containsKey('error') && data['error'] != null) {
          return data['error'].toString();
        }
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            final list = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                list.add(value.join(', '));
              } else {
                list.add(value.toString());
              }
            });
            if (list.isNotEmpty) return list.join('\n');
          } else if (errors is List) {
            return errors.join('\n');
          } else {
            return errors.toString();
          }
        }
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection with server';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with server';
      case DioExceptionType.badCertificate:
        return 'Bad certificate from server';
      case DioExceptionType.badResponse:
        return 'Server returned error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.unknown:
        return 'Unexpected network error occurred';
    }
  }
}
