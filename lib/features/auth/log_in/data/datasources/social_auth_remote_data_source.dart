import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/auth/log_in/data/models/auth_response_model.dart';
import 'package:dio/dio.dart';

abstract class SocialAuthRemoteDataSource {
  /// Exchange the OAuth provider token/code for an app token
  Future<AuthResponseModel> loginWithProvider({
    required String provider, // 'google' | 'facebook'
    required String accessToken,
  });
}

class SocialAuthRemoteDataSourceImpl implements SocialAuthRemoteDataSource {
  final Dio dio;

  const SocialAuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> loginWithProvider({
    required String provider,
    required String accessToken,
  }) async {
    // POST to /api/auth/{provider}/callback with the token
    final url =
        'https://untakable-tien-unwadable.ngrok-free.dev/api/auth/$provider/verify-token';

    try {
      final response = await dio.post(
        url,
        data: {'token': accessToken, 'access_token': accessToken},
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
          message: response.data?['message'] ?? 'Social login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message']?.toString() ??
          'Social login failed. Please try again.';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
