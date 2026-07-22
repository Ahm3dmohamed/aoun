import 'package:aoun/core/network/auth_interceptor.dart';
import 'package:aoun/features/chatbot/dependency_injection/chatbot_injection.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/core/utils/secure_storage_service.dart';
import 'package:aoun/features/auth/log_in/data/datasources/login_remote_data_source.dart';
import 'package:aoun/features/auth/log_in/data/repositories/login_repository_impl.dart';
import 'package:aoun/features/auth/log_in/domain/repositories/login_repository.dart';
import 'package:aoun/features/auth/log_in/domain/usecases/login_use_case.dart';
import 'package:aoun/features/auth/log_in/domain/usecases/logout_use_case.dart';
import 'package:aoun/features/auth/log_in/data/datasources/social_auth_remote_data_source.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/login_cubit.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/logout_cubit.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/social_auth_cubit.dart';
import 'package:aoun/features/auth/register/data/datasources/register_remote_data_source.dart';
import 'package:aoun/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:aoun/features/auth/register/domain/repositories/register_repository.dart';
import 'package:aoun/features/auth/register/domain/usecases/register_use_case.dart';
import 'package:aoun/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:aoun/features/auth/forgot_password/data/datasources/forgot_password_remote_data_source.dart';
import 'package:aoun/features/auth/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:aoun/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:aoun/features/auth/forgot_password/domain/usecases/forgot_password_use_case.dart';
import 'package:aoun/features/auth/forgot_password/domain/usecases/reset_password_use_case.dart';
import 'package:aoun/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:aoun/features/home/data/datasources/home_remote_data_source.dart';
import 'package:aoun/features/home/data/repositories/home_repository_impl.dart';
import 'package:aoun/features/home/domain/repositories/home_repository.dart';
import 'package:aoun/features/home/domain/usecases/get_cases_use_case.dart';
import 'package:aoun/features/home/presentation/cubit/home_cubit.dart';
import 'package:aoun/features/home/data/services/home_role_resolver.dart';
import 'package:aoun/features/cases/data/datasources/cases_remote_data_source.dart';
import 'package:aoun/features/cases/data/repositories/cases_repository_impl.dart';
import 'package:aoun/features/cases/domain/repositories/cases_repository.dart';
import 'package:aoun/features/cases/domain/usecases/get_cases_use_case.dart'
    as cases;
import 'package:aoun/features/cases/presentation/cubit/cases_cubit.dart';
import 'package:aoun/features/maps/data/datasources/maps_remote_data_source.dart';
import 'package:aoun/features/maps/data/repositories/maps_repository_impl.dart';
import 'package:aoun/features/maps/domain/repositories/maps_repository.dart';
import 'package:aoun/features/maps/domain/usecases/maps_usecases.dart';
import 'package:aoun/features/maps/presentation/cubit/maps_cubit.dart';
import 'package:aoun/features/request_assistance/data/datasources/request_assistance_remote_data_source.dart';
import 'package:aoun/features/request_assistance/data/repositories/request_assistance_repository_impl.dart';
import 'package:aoun/features/request_assistance/domain/repositories/request_assistance_repository.dart';
import 'package:aoun/features/request_assistance/domain/usecases/submit_request_assistance_use_case.dart';
import 'package:aoun/features/request_assistance/presentation/cubit/request_assistance_cubit.dart';
import 'package:aoun/features/foundations/data/datasources/foundation_local_data_source.dart';
import 'package:aoun/features/foundations/data/repositories/foundation_repository_impl.dart';
import 'package:aoun/features/foundations/domain/repositories/foundation_repository.dart';
import 'package:aoun/features/foundations/domain/usecases/donate_use_case.dart';
import 'package:aoun/features/foundations/domain/usecases/get_foundations_use_case.dart';
import 'package:aoun/features/foundations/domain/usecases/save_foundation_use_case.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_cubit.dart';
import 'package:aoun/features/recommendations/data/datasources/recommendations_remote_data_source.dart';
import 'package:aoun/features/recommendations/data/repositories/recommendations_repository_impl.dart';
import 'package:aoun/features/recommendations/domain/repositories/recommendations_repository.dart';
import 'package:aoun/features/recommendations/domain/usecases/get_recommendations_use_case.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // Core / Storage
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  if (!sl.isRegistered<AuthLocalDataSource>()) {
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl<FlutterSecureStorage>()),
    );
  }

  // Network / Dio
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio();
      dio.interceptors.add(AuthInterceptor(sl<AuthLocalDataSource>()));
      return dio;
    });
  }

  // Features - Register

  // Data sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      remoteDataSource: sl<RegisterRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<RegisterRepository>()),
  );

  // Cubits
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl<RegisterUseCase>()));

  // Features - Forgot Password & Reset Password

  // Data sources
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(
      remoteDataSource: sl<ForgotPasswordRemoteDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<ForgotPasswordRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<ForgotPasswordRepository>()),
  );

  // Cubits
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
    ),
  );

  // Features - Login & Logout

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDataSource: sl<LoginRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<LoginRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<LoginRepository>()),
  );

  // Cubits
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginUseCase>()));
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl<LogoutUseCase>()));

  // Social Auth
  sl.registerLazySingleton<SocialAuthRemoteDataSource>(
    () => SocialAuthRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerFactory<SocialAuthCubit>(
    () => SocialAuthCubit(
      remoteDataSource: sl<SocialAuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Features - Home
  sl.registerLazySingleton<HomeRoleResolver>(
    () => HomeRoleResolver(sl<AuthLocalDataSource>()),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCasesUseCase>(
    () => GetCasesUseCase(sl<HomeRepository>()),
  );
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      roleResolver: sl<HomeRoleResolver>(),
      getCasesUseCase: sl<cases.GetCasesUseCase>(),
      getFoundationsUseCase: sl<GetFoundationsUseCase>(),
      saveFoundationUseCase: sl<SaveFoundationUseCase>(),
      foundationRepository: sl<FoundationRepository>(),
    ),
  );

  // Features - Cases
  sl.registerLazySingleton<CasesRemoteDataSource>(
    () => CasesRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<CasesRepository>(
    () => CasesRepositoryImpl(remoteDataSource: sl<CasesRemoteDataSource>()),
  );
  sl.registerLazySingleton<cases.GetCasesUseCase>(
    () => cases.GetCasesUseCase(sl<CasesRepository>()),
  );
  sl.registerFactory<CasesCubit>(() => CasesCubit(sl<cases.GetCasesUseCase>()));

  // Features - Maps
  sl.registerLazySingleton<MapsRemoteDataSource>(
    () => MapsRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<MapsRepository>(
    () => MapsRepositoryImpl(sl<MapsRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCurrentLocationUseCase>(
    () => GetCurrentLocationUseCase(sl<MapsRepository>()),
  );
  sl.registerLazySingleton<GetNearbyPlacesUseCase>(
    () => GetNearbyPlacesUseCase(sl<MapsRepository>()),
  );
  sl.registerLazySingleton<SearchPlacesUseCase>(
    () => SearchPlacesUseCase(sl<MapsRepository>()),
  );
  sl.registerLazySingleton<GetRouteUseCase>(
    () => GetRouteUseCase(sl<MapsRepository>()),
  );
  sl.registerLazySingleton<GetRecommendedDonationsUseCase>(
    () => GetRecommendedDonationsUseCase(sl<MapsRepository>()),
  );
  sl.registerFactory<MapsCubit>(
    () => MapsCubit(
      getCurrentLocationUseCase: sl<GetCurrentLocationUseCase>(),
      getNearbyPlacesUseCase: sl<GetNearbyPlacesUseCase>(),
      searchPlacesUseCase: sl<SearchPlacesUseCase>(),
      getRouteUseCase: sl<GetRouteUseCase>(),
      getRecommendedDonationsUseCase: sl<GetRecommendedDonationsUseCase>(),
    ),
  );

  // Features - Request Assistance
  sl.registerLazySingleton<RequestAssistanceRemoteDataSource>(
    () => RequestAssistanceRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<RequestAssistanceRepository>(
    () => RequestAssistanceRepositoryImpl(
      sl<RequestAssistanceRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<SubmitRequestAssistanceUseCase>(
    () => SubmitRequestAssistanceUseCase(sl<RequestAssistanceRepository>()),
  );
  sl.registerFactory<RequestAssistanceCubit>(
    () => RequestAssistanceCubit(sl<SubmitRequestAssistanceUseCase>()),
  );

  // Features - Foundations
  sl.registerLazySingleton<FoundationLocalDataSource>(
    () => FoundationLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<FoundationRepository>(
    () => FoundationRepositoryImpl(
      localDataSource: sl<FoundationLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<SaveFoundationUseCase>(
    () => SaveFoundationUseCase(sl<FoundationRepository>()),
  );
  sl.registerLazySingleton<GetFoundationsUseCase>(
    () => GetFoundationsUseCase(sl<FoundationRepository>()),
  );
  sl.registerLazySingleton<DonateUseCase>(
    () => DonateUseCase(sl<FoundationRepository>()),
  );
  sl.registerLazySingleton<FoundationCubit>(
    () => FoundationCubit(
      getFoundationsUseCase: sl<GetFoundationsUseCase>(),
      donateUseCase: sl<DonateUseCase>(),
      saveFoundationUseCase: sl<SaveFoundationUseCase>(),
    ),
  );

  // Features - Recommendations (AI)
  if (!sl.isRegistered<RecommendationsRemoteDataSource>()) {
    sl.registerLazySingleton<RecommendationsRemoteDataSource>(
      () => RecommendationsRemoteDataSourceImpl(
        sl<Dio>(),
        sl<AuthLocalDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<RecommendationsRepository>()) {
    sl.registerLazySingleton<RecommendationsRepository>(
      () => RecommendationsRepositoryImpl(
        remoteDataSource: sl<RecommendationsRemoteDataSource>(),
      ),
    );
  }
  if (!sl.isRegistered<GetRecommendationsUseCase>()) {
    sl.registerLazySingleton<GetRecommendationsUseCase>(
      () => GetRecommendationsUseCase(sl<RecommendationsRepository>()),
    );
  }
  sl.registerFactory<RecommendationsCubit>(
    () => RecommendationsCubit(sl<GetRecommendationsUseCase>()),
  );

  // Features - Chatbot AI Assistant
  initChatbotInjection(sl);
}
