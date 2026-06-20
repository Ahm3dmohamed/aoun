import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SocialAuthState extends Equatable {
  const SocialAuthState();

  @override
  List<Object?> get props => [];
}

class SocialAuthInitial extends SocialAuthState {
  const SocialAuthInitial();
}

class SocialAuthLoading extends SocialAuthState {
  /// Which provider is loading — 'google' or 'facebook'
  final String provider;
  const SocialAuthLoading(this.provider);

  @override
  List<Object?> get props => [provider];
}

class SocialAuthSuccess extends SocialAuthState {
  final AuthResponseEntity authResponse;
  const SocialAuthSuccess(this.authResponse);

  @override
  List<Object?> get props => [authResponse];
}

class SocialAuthFailure extends SocialAuthState {
  final String message;
  const SocialAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// User cancelled the browser/webview flow
class SocialAuthCancelled extends SocialAuthState {
  const SocialAuthCancelled();
}
