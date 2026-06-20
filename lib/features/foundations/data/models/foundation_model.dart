import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';

class FoundationModel extends FoundationEntity {
  const FoundationModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.foundationType,
    required super.donationType,
    required super.location,
    required super.createdAt,
    required super.totalDonations,
    required super.targetAmount,
    super.imageUrl,
    super.description,
    super.isVerified,
  });

  factory FoundationModel.fromEntity(FoundationEntity entity) {
    return FoundationModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      foundationType: entity.foundationType,
      donationType: entity.donationType,
      location: entity.location,
      createdAt: entity.createdAt,
      totalDonations: entity.totalDonations,
      targetAmount: entity.targetAmount,
      imageUrl: entity.imageUrl,
      description: entity.description,
      isVerified: entity.isVerified,
    );
  }

  factory FoundationModel.fromJson(Map<String, dynamic> json) {
    return FoundationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      foundationType: json['foundationType']?.toString() ?? json['type']?.toString() ?? '',
      donationType: json['donationType']?.toString() ?? json['preferred_donation']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      totalDonations: (json['totalDonations'] as num?)?.toDouble() ?? (json['total_donations'] as num?)?.toDouble() ?? 0.0,
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? (json['target_amount'] as num?)?.toDouble() ?? 800000.0,
      imageUrl: json['imageUrl']?.toString(),
      description: json['description']?.toString(),
      isVerified: json['is_verified'] == true || json['isVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'foundationType': foundationType,
      'donationType': donationType,
      'location': location,
      'createdAt': createdAt,
      'totalDonations': totalDonations,
      'targetAmount': targetAmount,
      'imageUrl': imageUrl,
      'description': description,
      'isVerified': isVerified,
    };
  }
}
