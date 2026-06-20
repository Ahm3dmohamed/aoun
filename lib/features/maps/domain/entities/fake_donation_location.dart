class FakeDonationLocation {
  final int id;
  final String title;
  final String description;
  final double targetAmount;
  final double donatedAmount;
  final double remainingAmount;
  final String status;
  final String? imagePath;
  final String category;
  final String urgency;
  final String location;
  final DateTime createdAt;

  const FakeDonationLocation({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.donatedAmount,
    required this.remainingAmount,
    required this.status,
    this.imagePath,
    required this.category,
    required this.urgency,
    required this.location,
    required this.createdAt,
  });
}
