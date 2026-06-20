import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/cases/domain/usecases/get_cases_use_case.dart' as cases;
import 'package:aoun/features/foundations/data/models/foundation_model.dart';
import 'package:aoun/features/foundations/domain/repositories/foundation_repository.dart';
import 'package:aoun/features/foundations/domain/usecases/get_foundations_use_case.dart';
import 'package:aoun/features/foundations/domain/usecases/save_foundation_use_case.dart';
import 'package:aoun/features/home/data/services/home_role_resolver.dart';
import 'package:aoun/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRoleResolver roleResolver;
  final cases.GetCasesUseCase getCasesUseCase;
  final GetFoundationsUseCase getFoundationsUseCase;
  final SaveFoundationUseCase saveFoundationUseCase;
  final FoundationRepository foundationRepository;

  HomeCubit({
    required this.roleResolver,
    required this.getCasesUseCase,
    required this.getFoundationsUseCase,
    required this.saveFoundationUseCase,
    required this.foundationRepository,
  }) : super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());
    try {
      final role = await roleResolver.resolveRole();
      if (role == UserRole.foundationAdmin) {
        await loadFoundationDashboard();
      } else {
        await loadCases();
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Alias for backward compatibility
  Future<void> fetchCases() => loadHomeData();

  Future<void> loadCases() async {
    emit(const HomeLoading());
    final result = await getCasesUseCase();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (casesList) => emit(DonorHomeLoaded(cases: casesList)),
    );
  }

  Future<void> loadFoundationDashboard() async {
    emit(const HomeLoading());
    final email = await roleResolver.getUserEmail();
    if (email == null || email.isEmpty) {
      emit(const HomeError('User email not found. Please log in again.'));
      return;
    }

    // 1. Sync foundation data from login/registration session Map to Hive
    final userData = await roleResolver.authLocalDataSource.getUserData();
    if (userData != null) {
      final foundation = FoundationModel(
        id: userData['foundation_id']?.toString() ?? userData['id']?.toString() ?? const Uuid().v4(),
        name: userData['name']?.toString() ?? '',
        email: userData['email']?.toString() ?? '',
        phone: userData['phone']?.toString() ?? '',
        foundationType: userData['type']?.toString() ?? userData['foundationType']?.toString() ?? '',
        donationType: userData['preferred_donation']?.toString() ?? userData['donationType']?.toString() ?? '',
        location: userData['location']?.toString() ?? '',
        createdAt: userData['created_at']?.toString() ?? DateTime.now().toIso8601String().split('T')[0],
        totalDonations: (userData['total_donations'] ?? userData['totalDonations'] as num?)?.toDouble() ?? 0.0,
        targetAmount: (userData['target_amount'] ?? userData['targetAmount'] as num?)?.toDouble() ?? 800000.0,
        description: userData['description']?.toString() ?? 'Registered via Aoun application.',
        isVerified: userData['is_verified'] == true || userData['isVerified'] == true,
      );
      await saveFoundationUseCase(foundation);
    }

    // 2. Load foundation from local Hive box
    final foundationsResult = await getFoundationsUseCase();
    await foundationsResult.fold(
      (failure) async {
        emit(HomeError(failure.message));
      },
      (foundations) async {
        final matchingFoundations = foundations.where(
          (f) => f.email.toLowerCase().trim() == email.toLowerCase().trim()
        ).toList();

        if (matchingFoundations.isEmpty) {
          emit(const HomeError('Foundation data not found in local storage.'));
          return;
        }

        final adminFound = matchingFoundations.first;

        // 3. Fetch cases
        final casesResult = await getCasesUseCase();
        final List<CaseEntity> loadedCases = casesResult.fold(
          (failure) => <CaseEntity>[],
          (casesList) => casesList,
        );

        // 4. Fetch donations for this foundation
        final donationsResult = await foundationRepository.getDonations();
        donationsResult.fold(
          (failure) {
            emit(FoundationHomeLoaded(
              foundation: adminFound,
              receivedDonations: const [],
              cases: loadedCases,
            ));
          },
          (allDonations) {
            final received = allDonations
                .where((d) => d.foundationId == adminFound.id)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            emit(FoundationHomeLoaded(
              foundation: adminFound,
              receivedDonations: received,
              cases: loadedCases,
            ));
          },
        );
      },
    );
  }
}
