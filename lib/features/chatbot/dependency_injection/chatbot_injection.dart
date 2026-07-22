import 'package:aoun/features/chatbot/data/datasources/chatbot_local_datasource.dart';
import 'package:aoun/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:aoun/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:aoun/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:aoun/features/chatbot/domain/usecases/get_chat_history_usecase.dart';
import 'package:aoun/features/chatbot/domain/usecases/send_message_usecase.dart';
import 'package:aoun/features/chatbot/domain/usecases/clear_chat_history_usecase.dart';
import 'package:aoun/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// Registers all chatbot feature dependencies with GetIt.
/// Called from [initInjection] in injection_container.dart.
void initChatbotInjection(GetIt sl) {
  // Data sources
  if (!sl.isRegistered<ChatbotRemoteDatasource>()) {
    sl.registerLazySingleton<ChatbotRemoteDatasource>(
      () => ChatbotRemoteDatasource(sl<Dio>()),
    );
  }

  if (!sl.isRegistered<ChatbotLocalDatasource>()) {
    sl.registerLazySingleton<ChatbotLocalDatasource>(
      () => ChatbotLocalDatasource(),
    );
  }

  // Repository
  if (!sl.isRegistered<ChatbotRepository>()) {
    sl.registerLazySingleton<ChatbotRepository>(
      () => ChatbotRepositoryImpl(
        sl<ChatbotRemoteDatasource>(),
        sl<ChatbotLocalDatasource>(),
      ),
    );
  }

  // Use cases
  if (!sl.isRegistered<GetChatHistoryUseCase>()) {
    sl.registerLazySingleton<GetChatHistoryUseCase>(
      () => GetChatHistoryUseCase(sl<ChatbotRepository>()),
    );
  }

  if (!sl.isRegistered<SendMessageUseCase>()) {
    sl.registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(sl<ChatbotRepository>()),
    );
  }

  if (!sl.isRegistered<ClearChatHistoryUseCase>()) {
    sl.registerLazySingleton<ClearChatHistoryUseCase>(
      () => ClearChatHistoryUseCase(sl<ChatbotRepository>()),
    );
  }

  // Cubit — factory so each screen gets a fresh instance
  sl.registerFactory<ChatbotCubit>(
    () => ChatbotCubit(
      getHistoryUseCase: sl<GetChatHistoryUseCase>(),
      sendMessageUseCase: sl<SendMessageUseCase>(),
    ),
  );
}
