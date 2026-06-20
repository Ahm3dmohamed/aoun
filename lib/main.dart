import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/storage/hive_service.dart';
import 'package:aoun/core/themes/app_themes.dart';
import 'package:aoun/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:aoun/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:aoun/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:aoun/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:aoun/features/profile/cubit/localization_cubit.dart';
import 'package:aoun/features/profile/cubit/localization_state.dart';
import 'package:aoun/features/home/presentation/cubit/home_cubit.dart';
import 'package:aoun/features/foundations/data/models/foundation_model.dart';
import 'package:aoun/features/foundations/data/models/donation_model.dart';
import 'package:aoun/features/foundations/data/models/foundation_adapter.dart';
import 'package:aoun/features/foundations/data/models/donation_adapter.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_cubit.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_cubit.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  await Hive.initFlutter();
  
  // Register manual adapters
  Hive.registerAdapter(FoundationModelAdapter());
  Hive.registerAdapter(DonationModelAdapter());

  await Future.wait([
    Hive.openBox('chatBox'),
    Hive.openBox('settingsBox'),
    Hive.openBox<FoundationModel>('foundationsBox'),
    Hive.openBox<DonationModel>('donationsBox'),
    Hive.openBox('usersBox'),
  ]);
  runApp(const AounApp());
}

class AounApp extends StatelessWidget {
  const AounApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatCubit(
            ChatRepositoryImpl(
              ChatRemoteDataSource(Dio(), FlutterSecureStorage()),
              ChatLocalDataSource(HiveService()),
            ),
          ),
        ),
        BlocProvider(create: (context) => LocalizationCubit()),
        BlocProvider(create: (context) => sl<HomeCubit>()),
        BlocProvider(create: (context) => sl<FoundationCubit>()),
        BlocProvider(create: (context) => sl<RecommendationsCubit>()),
      ],
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          return ScreenUtilInit(
            minTextAdapt: true,
            splitScreenMode: true,
            designSize: const Size(375, 812),
            builder: (context, child) => MaterialApp(
              title: 'Aoun',
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: state.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              onGenerateRoute: AppRoutes.onGenerateRoute,
              initialRoute: AppRoutes.onboarding,
            ),
          );
        },
      ),
    );
  }
}
