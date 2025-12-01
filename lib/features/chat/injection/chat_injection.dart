// lib/features/chat/injection/chat_injection.dart
import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:heraguard_frontend/features/chat/data/datasources/chat_remote_data_sources_impl.dart';
import 'package:heraguard_frontend/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:heraguard_frontend/features/chat/domain/repositories/chat_repository.dart';
import 'package:heraguard_frontend/features/chat/presentation/bloc/chat_bloc.dart';

Future<void> chatInjectionInit() async {
  final getIt = GetIt.instance;

  // Datasources
  getIt.registerLazySingleton<ChatRemoteDataSources>(
    () => ChatRemoteDataSourcesImpl(apiClient: getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatRemoteDataSource: getIt<ChatRemoteDataSources>(),
      apiClient: getIt<ApiClient>(),
    ),
  );

  // BLoC
  getIt.registerFactory(
    () => ChatBloc(chatRepository: getIt<ChatRepository>()),
  );
}
