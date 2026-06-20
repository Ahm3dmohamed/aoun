import 'package:equatable/equatable.dart';

class FoundationEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String foundationType;
  final String donationType;
  final String location;
  final String createdAt;
  final double totalDonations;
  final double targetAmount;
  final String? imageUrl;
  final String? description;
  final bool isVerified;

  const FoundationEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.foundationType,
    required this.donationType,
    required this.location,
    required this.createdAt,
    required this.totalDonations,
    required this.targetAmount,
    this.imageUrl,
    this.description,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        foundationType,
        donationType,
        location,
        createdAt,
        totalDonations,
        targetAmount,
        imageUrl,
        description,
        isVerified,
      ];
}
