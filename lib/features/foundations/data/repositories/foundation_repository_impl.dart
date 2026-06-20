import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/foundations/data/datasources/foundation_local_data_source.dart';
import 'package:aoun/features/foundations/data/models/donation_model.dart';
import 'package:aoun/features/foundations/data/models/foundation_model.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/domain/repositories/foundation_repository.dart';

class FoundationRepositoryImpl implements FoundationRepository {
  final FoundationLocalDataSource localDataSource;

  const FoundationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveFoundation(FoundationEntity foundation) async {
    try {
      final model = FoundationModel.fromEntity(foundation);
      await localDataSource.saveFoundation(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoundationEntity>>> getFoundations() async {
    try {
      final models = await localDataSource.getFoundations();
      return Right(models);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> donate(DonationEntity donation) async {
    try {
      final model = DonationModel.fromEntity(donation);
      await localDataSource.saveDonation(model);
      
      // Only increment the monetary total if it's a Money donation
      if (donation.purpose == 'Money') {
        await localDataSource.updateFoundationDonations(donation.foundationId, donation.amount);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DonationEntity>>> getDonations() async {
    try {
      final models = await localDataSource.getDonations();
      return Right(models);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
