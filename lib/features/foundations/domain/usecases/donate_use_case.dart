import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/repositories/foundation_repository.dart';

class DonateUseCase {
  final FoundationRepository repository;

  const DonateUseCase(this.repository);

  Future<Either<Failure, void>> call(DonationEntity donation) {
    return repository.donate(donation);
  }
}
