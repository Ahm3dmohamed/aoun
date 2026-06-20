import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';

class DonationModel extends DonationEntity {
  const DonationModel({
    required super.id,
    required super.foundationId,
    required super.foundationName,
    required super.donorName,
    required super.amount,
    required super.createdAt,
    super.purpose = 'Money',
    super.details,
  });

  factory DonationModel.fromEntity(DonationEntity entity) {
    return DonationModel(
      id: entity.id,
      foundationId: entity.foundationId,
      foundationName: entity.foundationName,
      donorName: entity.donorName,
      amount: entity.amount,
      createdAt: entity.createdAt,
      purpose: entity.purpose,
      details: entity.details,
    );
  }

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id']?.toString() ?? '',
      foundationId: json['foundationId']?.toString() ?? '',
      foundationName: json['foundationName']?.toString() ?? '',
      donorName: json['donorName']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt']?.toString() ?? '',
      purpose: json['purpose']?.toString() ?? 'Money',
      details: json['details']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foundationId': foundationId,
      'foundationName': foundationName,
      'donorName': donorName,
      'amount': amount,
      'createdAt': createdAt,
      'purpose': purpose,
      'details': details,
    };
  }
}
