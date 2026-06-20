import 'package:aoun/features/cases/domain/entities/case_entity.dart';

class CaseModel extends CaseEntity {
  const CaseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.targetAmount,
    required super.donatedAmount,
    required super.remainingAmount,
    required super.status,
    super.imagePath,
    required super.category,
    required super.urgency,
    required super.location,
    required super.createdAt,
    super.foundationName,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      targetAmount: double.tryParse(json['target_amount']?.toString() ?? '0') ?? 0,
      donatedAmount: double.tryParse(json['donated_amount']?.toString() ?? '0') ?? 0,
      remainingAmount: double.tryParse(json['remaining_amount']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'Active',
      imagePath: json['image_path']?.toString(),
      category: json['category']?.toString() ?? '',
      urgency: json['urgency']?.toString() ?? 'Normal',
      location: json['location']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      foundationName: json['foundation_name']?.toString() ?? json['foundation']?.toString(),
    );
  }
}
