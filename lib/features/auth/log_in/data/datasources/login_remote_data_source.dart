import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/auth/log_in/data/models/auth_response_model.dart';
import 'package:aoun/features/auth/log_in/domain/entities/login_entity.dart';
import 'package:dio/dio.dart';

abstract class LoginRemoteDataSource {
  Future<AuthResponseModel> login(LoginEntity loginEntity);
  Future<void> logout();
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  const LoginRemoteDataSourceImpl(this.dio);

  @override
  Future<void> logout() async {
    const url = 'https://untakable-tien-unwadable.ngrok-free.dev/api/auth/logout';

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to logout',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final String errorMessage = _parseDioErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponseModel> login(LoginEntity loginEntity) async {
    const url = 'https://untakable-tien-unwadable.ngrok-free.dev/api/auth/login';

    try {
      final response = await dio.post(
        url,
        data: {
          'email': loginEntity.email,
          'password': loginEntity.password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null) {
          throw const ServerException(message: 'Empty response from server');
        }
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to login',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final String errorMessage = _parseDioErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  String _parseDioErrorMessage(DioException e) {
    if (e.response != null && e.response?.data != null) {
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
        if (e.response?.statusCode == 401) {
          return 'Invalid email or password';
        }
        return 'Server returned error status code: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request to server was cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error, please check internet connection';
      case DioExceptionType.unknown:
        return 'Unexpected network error occurred';
    }
  }
}
