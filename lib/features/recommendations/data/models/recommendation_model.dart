import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';

class RecommendationModel extends RecommendationEntity {
  const RecommendationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.urgency,
    required super.location,
    required super.targetAmount,
    required super.donatedAmount,
    required super.remainingAmount,
    super.imagePath,
    required super.recommendationScore,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      urgency: json['urgency']?.toString() ?? 'normal',
      location: json['location']?.toString() ?? '',
      targetAmount:
          double.tryParse(json['target_amount']?.toString() ?? '0') ?? 0,
      donatedAmount:
          double.tryParse(json['donated_amount']?.toString() ?? '0') ?? 0,
      remainingAmount:
          double.tryParse(json['remaining_amount']?.toString() ?? '0') ?? 0,
      imagePath: json['image_path']?.toString(),
      recommendationScore:
          double.tryParse(json['recommendation_score']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'urgency': urgency,
      'location': location,
      'target_amount': targetAmount,
      'donated_amount': donatedAmount,
      'remaining_amount': remainingAmount,
      'image_path': imagePath,
      'recommendation_score': recommendationScore,
    };
  }
}
