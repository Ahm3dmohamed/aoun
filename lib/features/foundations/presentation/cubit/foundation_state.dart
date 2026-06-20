import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:equatable/equatable.dart';

class FoundationState extends Equatable {
  final List<FoundationEntity> foundations;
  final FoundationEntity? adminFoundation;
  final List<DonationEntity> receivedDonations;
  final bool isLoading;
  final String? errorMessage;
  final bool donationSuccess;

  const FoundationState({
    this.foundations = const [],
    this.adminFoundation,
    this.receivedDonations = const [],
    this.isLoading = false,
    this.errorMessage,
    this.donationSuccess = false,
  });

  FoundationState copyWith({
    List<FoundationEntity>? foundations,
    FoundationEntity? adminFoundation,
    List<DonationEntity>? receivedDonations,
    bool? isLoading,
    String? errorMessage,
    bool? donationSuccess,
  }) {
    return FoundationState(
      foundations: foundations ?? this.foundations,
      adminFoundation: adminFoundation ?? this.adminFoundation,
      receivedDonations: receivedDonations ?? this.receivedDonations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      donationSuccess: donationSuccess ?? this.donationSuccess,
    );
  }

  @override
  List<Object?> get props => [
        foundations,
        adminFoundation,
        receivedDonations,
        isLoading,
        errorMessage,
        donationSuccess,
      ];
}
