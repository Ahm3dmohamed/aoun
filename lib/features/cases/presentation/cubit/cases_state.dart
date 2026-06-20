import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CasesState extends Equatable {
  const CasesState();

  @override
  List<Object?> get props => [];
}

class CasesInitial extends CasesState {
  const CasesInitial();
}

class CasesLoading extends CasesState {
  const CasesLoading();
}

class CasesLoaded extends CasesState {
  final List<CaseEntity> cases;

  const CasesLoaded(this.cases);

  @override
  List<Object?> get props => [cases];
}

class CasesError extends CasesState {
  final String message;

  const CasesError(this.message);

  @override
  List<Object?> get props => [message];
}
