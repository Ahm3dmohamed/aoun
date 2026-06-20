import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/domain/usecases/donate_use_case.dart';
import 'package:aoun/features/foundations/domain/usecases/get_foundations_use_case.dart';
import 'package:aoun/features/foundations/domain/usecases/save_foundation_use_case.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoundationCubit extends Cubit<FoundationState> {
  final GetFoundationsUseCase getFoundationsUseCase;
  final DonateUseCase donateUseCase;
  final SaveFoundationUseCase saveFoundationUseCase;

  FoundationCubit({
    required this.getFoundationsUseCase,
    required this.donateUseCase,
    required this.saveFoundationUseCase,
  }) : super(const FoundationState());

  Future<void> fetchFoundations() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, donationSuccess: false));
    final result = await getFoundationsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (foundations) => emit(state.copyWith(isLoading: false, foundations: foundations)),
    );
  }

  Future<void> loadAdminDashboard(String adminEmail) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, donationSuccess: false));
    
    final foundationsResult = await getFoundationsUseCase();
    
    foundationsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (foundations) async {
        // Strictly match the foundation registered by this admin via email
        final matchingFoundations = foundations.where(
          (f) => f.email.toLowerCase().trim() == adminEmail.toLowerCase().trim()
        ).toList();

        if (matchingFoundations.isEmpty) {
          emit(state.copyWith(
            isLoading: false,
            foundations: foundations,
            errorMessage: 'Foundation not found for this account.',
          ));
          return;
        }

        final adminFound = matchingFoundations.first;

        // Fetch donations for this foundation
        final donationsResult = await donateUseCase.repository.getDonations();
        donationsResult.fold(
          (failure) {
            emit(state.copyWith(
              isLoading: false,
              foundations: foundations,
              adminFoundation: adminFound,
              receivedDonations: const [],
            ));
          },
          (allDonations) {
            final received = allDonations
                .where((d) => d.foundationId == adminFound.id)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            emit(state.copyWith(
              isLoading: false,
              foundations: foundations,
              adminFoundation: adminFound,
              receivedDonations: received,
            ));
          },
        );
      },
    );
  }

  /// Called by RegisterCubit right after saving the foundation so the cubit
  /// state is already populated when HomePage mounts.
  Future<void> saveAndLoadAdminDashboard(
    dynamic foundation,
    String adminEmail,
  ) async {
    await saveFoundationUseCase(foundation);
    await loadAdminDashboard(adminEmail);
  }

  Future<void> submitDonation(DonationEntity donation) async {
    emit(state.copyWith(isLoading: true, donationSuccess: false, errorMessage: null));
    final result = await donateUseCase(donation);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) async {
        // Refresh foundations
        final fResult = await getFoundationsUseCase();
        fResult.fold(
          (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message, donationSuccess: true)),
          (foundations) => emit(state.copyWith(isLoading: false, foundations: foundations, donationSuccess: true)),
        );
      },
    );
  }
}
