import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/features/elder/injection/elder_injection.dart';

final getIt = GetIt.instance;

class InjectionContainer {
  static Future<void> initialize() async {
    getIt.registerLazySingleton<ApiClient>(() => ApiClient());
    await _initializeElderDependencies();
  }

  static Future<void> _initializeElderDependencies() async {
    await elderInjectionInit();
  }
}
