import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/features/auth/register/domain/entities/register_entity.dart';
import 'package:aoun/features/auth/register/domain/usecases/register_use_case.dart';
import 'package:aoun/features/auth/register/presentation/cubit/register_state.dart';
import 'package:aoun/features/foundations/data/models/foundation_model.dart';
import 'package:aoun/features/foundations/domain/usecases/save_foundation_use_case.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(const RegisterInitial());

  Future<void> registerUser(RegisterEntity registerEntity) async {
    emit(const RegisterLoading());
    debugPrint('[RegisterCubit] Calling registerUseCase...');

    final result = await registerUseCase(registerEntity);

    result.fold(
      (failure) {
        debugPrint('[RegisterCubit] Failure: ${failure.message}');
        emit(RegisterFailure(failure.message));
      },
      (authResponse) async {
        debugPrint('[RegisterCubit] Success! Token: ${authResponse.token}');

        if (registerEntity.role == 'foundation_admin') {
          final foundation = FoundationModel(
            id: authResponse.userData?['id']?.toString() ?? const Uuid().v4(),
            name: registerEntity.name,
            email: registerEntity.email,
            phone: registerEntity.phone,
            foundationType: registerEntity.foundationType ?? '',
            donationType: registerEntity.donationType ?? '',
            location: registerEntity.location ?? '',
            createdAt: DateTime.now().toIso8601String().split('T')[0],
            totalDonations: 0.0,
            targetAmount: 800000.0,
            description: 'Registered via Aoun application.',
          );

          // 1. Persist to Hive
          await sl<SaveFoundationUseCase>().call(foundation);

          // 2. Pre-warm the global FoundationCubit so HomePage shows the
          //    admin dashboard immediately without a blank flash.
          await sl<FoundationCubit>().loadAdminDashboard(registerEntity.email);
          debugPrint('[RegisterCubit] Foundation saved & cubit pre-warmed for ${registerEntity.email}');
        }

        emit(RegisterSuccess(authResponse));
      },
    );
  }
}
