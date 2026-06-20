import 'package:aoun/features/auth/log_in/domain/entities/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.token,
    super.message,
    super.userData,
  });

  /// Factory constructor to parse different potential token JSON response layouts.
  /// Adjust key lookups below depending on your actual API signature.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    String foundToken = '';
    
    // 1. Direct token check
    if (json['token'] != null) {
      foundToken = json['token'].toString();
    } else if (json['access_token'] != null) {
      foundToken = json['access_token'].toString();
    } 
    // 2. Nested data object check
    else if (json['data'] != null && json['data'] is Map) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['token'] != null) {
        foundToken = data['token'].toString();
      } else if (data['access_token'] != null) {
        foundToken = data['access_token'].toString();
      }
    }

    // Extract user data — supports both 'user' and 'foundation' keys
    Map<String, dynamic>? extractedUserData;
    if (json['user'] is Map<String, dynamic>) {
      extractedUserData = json['user'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['user'] is Map<String, dynamic>) {
        extractedUserData = data['user'] as Map<String, dynamic>;
      } else if (data['foundation'] is Map<String, dynamic>) {
        extractedUserData = data['foundation'] as Map<String, dynamic>;
      } else if (data['donor'] is Map<String, dynamic>) {
        extractedUserData = data['donor'] as Map<String, dynamic>;
      }
    }

    return AuthResponseModel(
      token: foundToken,
      message: json['message']?.toString(),
      userData: extractedUserData,
    );
  }
}
