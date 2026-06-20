import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role; // 'donor' or 'foundation'
  final String phone;
  final String? foundationType;
  final String? donationType;
  final String? location;

  const RegisterEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.phone,
    this.foundationType,
    this.donationType,
    this.location,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        role,
        phone,
        foundationType,
        donationType,
        location,
      ];
}
