import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class FoundationHomeLoaded extends HomeState {
  final FoundationEntity foundation;
  final List<DonationEntity> receivedDonations;
  final List<CaseEntity> cases;

  const FoundationHomeLoaded({
    required this.foundation,
    required this.receivedDonations,
    required this.cases,
  });
}

class DonorHomeLoaded extends HomeState {
  final List<CaseEntity> cases;

  const DonorHomeLoaded({required this.cases});
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
