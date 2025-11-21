import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/storage/secure_storage.dart';
import 'package:heraguard_frontend/core/storage/secure_storage_impl.dart';
import 'package:heraguard_frontend/features/activities/injection/activity_injection.dart';
import 'package:heraguard_frontend/features/elder/injection/elder_injection.dart';

final getIt = GetIt.instance;
final sl = GetIt.instance;

class InjectionContainer {
  static Future<void> initialize() async {
    getIt.registerLazySingleton<ApiClient>(() => ApiClient());
    getIt.registerLazySingleton<SecureStorage>(() => SecureStorageImpl());
    await _initializeElderDependencies();
  }

  static Future<void> _initializeElderDependencies() async {
    await elderInjectionInit();
    await activityInjectionInit();
  }
}
