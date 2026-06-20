import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/features/auth/log_in/data/datasources/social_auth_remote_data_source.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/social_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SocialAuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  SocialAuthCubit({
    required this.remoteDataSource,
    required this.localDataSource,
  }) : super(const SocialAuthInitial());

  static const String _baseUrl =
      'https://untakable-tien-unwadable.ngrok-free.dev';

  /// Opens the backend OAuth redirect URL in the browser.
  /// The backend redirects the user to the provider, then calls back
  /// /api/auth/{provider}/callback — for a mobile app the callback
  /// delivers the token via deep-link or as a response body.
  Future<void> loginWithGoogle() => _openOAuth('google');
  Future<void> loginWithFacebook() => _openOAuth('facebook');

  Future<void> _openOAuth(String provider) async {
    emit(SocialAuthLoading(provider));

    // This opens the backend OAuth redirect page in the browser (GET).
    // The backend redirects the user to Google/Facebook, then on success
    // it POSTs/redirects back with a token via deep-link to the app.
    // The deep-link then triggers handleCallback() which does the POST
    // to /api/auth/{provider}/verify-token with the access token.
    final oauthUrl = Uri.parse('$_baseUrl/api/auth/$provider');

    try {
      final launched = await launchUrl(
        oauthUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        emit(
          const SocialAuthFailure(
            'Could not open the browser. Please check your device settings.',
          ),
        );
        return;
      }

      // After the user completes OAuth in the browser, the app will receive
      // a deep-link with the token. handleCallback() will be triggered then.
      // Reset to initial so the UI is not stuck in loading.
      emit(const SocialAuthInitial());
    } catch (e) {
      emit(
        SocialAuthFailure('Failed to open $provider login: ${e.toString()}'),
      );
    }
  }

  /// Called when the deep-link callback arrives with an access token.
  /// Wire this to your deep-link handler (e.g., app_links).
  Future<void> handleCallback({
    required String provider,
    required String accessToken,
  }) async {
    emit(SocialAuthLoading(provider));
    try {
      final response = await remoteDataSource.loginWithProvider(
        provider: provider,
        accessToken: accessToken,
      );

      // Persist token locally
      await localDataSource.saveToken(response.token);
      if (response.userData != null) {
        await localDataSource.saveUserData(response.userData!);
      }

      emit(SocialAuthSuccess(response));
    } catch (e) {
      emit(SocialAuthFailure(e.toString()));
    }
  }

  void reset() => emit(const SocialAuthInitial());
}
