import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/domain/repositories/foundation_repository.dart';

class SaveFoundationUseCase {
  final FoundationRepository repository;

  const SaveFoundationUseCase(this.repository);

  Future<Either<Failure, void>> call(FoundationEntity foundation) {
    return repository.saveFoundation(foundation);
  }
}
