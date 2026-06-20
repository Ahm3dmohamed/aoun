import 'package:aoun/features/auth/register/domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required super.name,
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.role,
    required super.phone,
    super.foundationType,
    super.donationType,
    super.location,
  });

  /// Factory constructor to create a [RegisterModel] from an entity.
  factory RegisterModel.fromEntity(RegisterEntity entity) {
    return RegisterModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      role: entity.role,
      phone: entity.phone,
      foundationType: entity.foundationType,
      donationType: entity.donationType,
      location: entity.location,
    );
  }

  /// Deserialization from JSON.
  /// NOTE: Adjust key names below if the API response structure changes.
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: '', // Password is not returned in responses normally
      confirmPassword: '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      foundationType: json['foundation_type'] ?? json['foundationType'],
      donationType: json['donation_type'] ?? json['donationType'],
      location: json['location'],
    );
  }

  /// Serialization to JSON for the POST request body.
  /// NOTE: Adjust JSON key mappings here to match your API backend expectations.
  Map<String, dynamic> toJson() {
    // The remote API backend validates and only accepts 'medical' and 'educational' for the 'type' field.
    // We map 'charity' and 'religious' to 'educational' for the remote API request to bypass validation,
    // while keeping the user's original selection locally in the app.
    String? apiType = foundationType;
    if (apiType != null) {
      if (apiType == 'charity' || apiType == 'religious') {
        apiType = 'educational';
      }
    }

    return {
      'name': name,
      'email': email,
      'password': password,
      // API typically expects 'password_confirmation' or 'confirm_password'
      'password_confirmation': confirmPassword,
      'role': role,
      'phone': phone,
      if (apiType != null) 'type': apiType,
      if (donationType != null) 'preferred_donation': donationType,
      if (location != null) 'location': location,
    };
  }
}
