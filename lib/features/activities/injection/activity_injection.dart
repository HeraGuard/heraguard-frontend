import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/features/activities/data/datasources/activity_remote_data_sources.dart';
import 'package:heraguard_frontend/features/activities/data/datasources/activity_remote_data_sources_impl.dart';
import 'package:heraguard_frontend/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:heraguard_frontend/features/activities/domain/repositories/activity_repository.dart';
import 'package:heraguard_frontend/features/activities/domain/usecases/add_activity_usecase.dart';
import 'package:heraguard_frontend/features/activities/presentation/bloc/activity_bloc.dart';

Future<void> activityInjectionInit() async {
  final getIt = GetIt.instance;

  // Datasources
  getIt.registerLazySingleton<ActivityRemoteDataSources>(
    () => ActivityRemoteDataSourcesImpl(apiClient: getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      remoteDataSources: getIt<ActivityRemoteDataSources>(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(
    () => AddActivityUsecase(getIt<ActivityRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => ActivityBloc(addActivityUsecase: getIt<AddActivityUsecase>()),
  );
}
