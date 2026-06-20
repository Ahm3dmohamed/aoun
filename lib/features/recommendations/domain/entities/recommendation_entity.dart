class RecommendationEntity {
  final int id;
  final String title;
  final String description;
  final String category;
  final String urgency;
  final String location;
  final double targetAmount;
  final double donatedAmount;
  final double remainingAmount;
  final String? imagePath;
  final double recommendationScore;

  const RecommendationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    required this.location,
    required this.targetAmount,
    required this.donatedAmount,
    required this.remainingAmount,
    this.imagePath,
    required this.recommendationScore,
  });

  double get progressPercent =>
      targetAmount > 0 ? (donatedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
}
