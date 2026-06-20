import 'dart:io';

class RequestAssistanceEntity {
  final String foundationName;
  final String location;
  final String title;
  final String category;
  final String urgency;
  final String description;
  final double requiredAmount;
  final List<File>? files;

  const RequestAssistanceEntity({
    required this.foundationName,
    required this.category,
    required this.urgency,
    required this.location,
    required this.title,
    required this.description,
    required this.requiredAmount,
    this.files,
  });
}
