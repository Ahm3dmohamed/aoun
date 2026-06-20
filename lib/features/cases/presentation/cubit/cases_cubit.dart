import 'package:aoun/features/cases/domain/usecases/get_cases_use_case.dart';
import 'package:aoun/features/cases/presentation/cubit/cases_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CasesCubit extends Cubit<CasesState> {
  final GetCasesUseCase getCasesUseCase;

  CasesCubit(this.getCasesUseCase) : super(const CasesInitial());

  Future<void> loadCases() async {
    emit(const CasesLoading());
    final result = await getCasesUseCase();
    result.fold(
      (failure) => emit(CasesError(failure.message)),
      (cases) => emit(CasesLoaded(cases)),
    );
  }
}
