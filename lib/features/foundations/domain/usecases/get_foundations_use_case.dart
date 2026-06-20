import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/domain/repositories/foundation_repository.dart';

class GetFoundationsUseCase {
  final FoundationRepository repository;

  const GetFoundationsUseCase(this.repository);

  Future<Either<Failure, List<FoundationEntity>>> call() {
    return repository.getFoundations();
  }
}
