import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';

abstract class CasesRepository {
  Future<Either<Failure, List<CaseEntity>>> getCases({int page = 1});
}
