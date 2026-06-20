import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/cases/data/models/case_model.dart';
import 'package:aoun/features/home/domain/entities/case_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CaseModel>>> getCases({int page = 1});
}
