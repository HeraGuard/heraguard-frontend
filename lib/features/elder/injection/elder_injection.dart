import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/features/elder/data/datasources/elder_remote_data_sources.dart';
import 'package:heraguard_frontend/features/elder/data/datasources/elder_remote_data_sources_impl.dart';
import 'package:heraguard_frontend/features/elder/data/repositories/elder_repository_impl.dart';
import 'package:heraguard_frontend/features/elder/domain/repositories/elder_repository.dart';
import 'package:heraguard_frontend/features/elder/domain/usecases/get_elders_by_user_usecase.dart';
import 'package:heraguard_frontend/features/elder/domain/usecases/link_elder_usecase.dart';
import 'package:heraguard_frontend/features/elder/presentation/bloc/elder_bloc.dart';

Future<void> elderInjectionInit() async {
  final getIt = GetIt.instance;

  // Datasources
  getIt.registerLazySingleton<ElderRemoteDataSources>(
    () => ElderRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<ElderRepository>(
    () =>
        ElderRepositoryImpl(remoteDataSources: getIt<ElderRemoteDataSources>()),
  );

  // Usecases
  getIt.registerLazySingleton(
    () => GetEldersByUserUsecase(getIt<ElderRepository>()),
  );
  getIt.registerLazySingleton(() => LinkElderUsecase(getIt<ElderRepository>()));

  // Bloc
  getIt.registerFactory(
    () => ElderBloc(
      getEldersByUser: getIt<GetEldersByUserUsecase>(),
      linkElder: getIt<LinkElderUsecase>(),
    ),
  );
}
