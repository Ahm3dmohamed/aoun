import 'package:equatable/equatable.dart';

class DonationEntity extends Equatable {
  final String id;
  final String foundationId;
  final String foundationName;
  final String donorName;
  final double amount;
  final String createdAt;
  final String? _purpose;
  final String? details;

  String get purpose => _purpose ?? 'Money';

  const DonationEntity({
    required this.id,
    required this.foundationId,
    required this.foundationName,
    required this.donorName,
    required this.amount,
    required this.createdAt,
    String? purpose = 'Money',
    this.details,
  }) : _purpose = purpose;

  @override
  List<Object?> get props => [
        id,
        foundationId,
        foundationName,
        donorName,
        amount,
        createdAt,
        purpose,
        details,
      ];
}
