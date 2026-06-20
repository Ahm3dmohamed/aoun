import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';

abstract class FoundationRepository {
  Future<Either<Failure, void>> saveFoundation(FoundationEntity foundation);
  Future<Either<Failure, List<FoundationEntity>>> getFoundations();
  Future<Either<Failure, void>> donate(DonationEntity donation);
  Future<Either<Failure, List<DonationEntity>>> getDonations();
}
