import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/request_assistance/domain/entities/request_assistance_entity.dart';

abstract class RequestAssistanceRepository {
  Future<Either<Failure, void>> submitRequest(
    RequestAssistanceEntity entity,
  );
}
