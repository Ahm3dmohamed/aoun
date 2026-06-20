import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/cases/domain/repositories/cases_repository.dart';

class GetCasesUseCase {
  final CasesRepository repository;

  const GetCasesUseCase(this.repository);

  Future<Either<Failure, List<CaseEntity>>> call({int page = 1}) =>
      repository.getCases(page: page);
}
