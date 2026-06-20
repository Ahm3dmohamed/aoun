import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/request_assistance/domain/entities/request_assistance_entity.dart';
import 'package:aoun/features/request_assistance/domain/repositories/request_assistance_repository.dart';

class SubmitRequestAssistanceUseCase {
  final RequestAssistanceRepository repository;

  const SubmitRequestAssistanceUseCase(this.repository);

  Future<Either<Failure, void>> call(RequestAssistanceEntity entity) =>
      repository.submitRequest(entity);
}
