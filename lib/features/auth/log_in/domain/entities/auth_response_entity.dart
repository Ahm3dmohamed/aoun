import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String token;
  final String? message;
  final Map<String, dynamic>? userData;

  const AuthResponseEntity({
    required this.token,
    this.message,
    this.userData,
  });

  @override
  List<Object?> get props => [token, message, userData];
}
