class DonationLocation {
  final String id;
  final String title;
  final String description;
  final String category;
  final String urgency; // 'high', 'medium', 'low'
  final double latitude;
  final double longitude;
  final double targetAmount;
  final double donatedAmount;
  final double remainingAmount;
  final double? distance; // in km
  final double? score; // recommendation score

  const DonationLocation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    required this.latitude,
    required this.longitude,
    required this.targetAmount,
    required this.donatedAmount,
    required this.remainingAmount,
    this.distance,
    this.score,
  });

  DonationLocation copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? urgency,
    double? latitude,
    double? longitude,
    double? targetAmount,
    double? donatedAmount,
    double? remainingAmount,
    double? distance,
    double? score,
  }) {
    return DonationLocation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      urgency: urgency ?? this.urgency,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      targetAmount: targetAmount ?? this.targetAmount,
      donatedAmount: donatedAmount ?? this.donatedAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      distance: distance ?? this.distance,
      score: score ?? this.score,
    );
  }
}
