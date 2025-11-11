import 'package:heraguard_frontend/features/elder/data/datasources/elder_remote_data_sources.dart';
import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';
import 'package:heraguard_frontend/features/elder/domain/repositories/elder_repository.dart';

class ElderRepositoryImpl implements ElderRepository {
  final ElderRemoteDataSources remoteDataSources;

  ElderRepositoryImpl({required this.remoteDataSources});

  @override
  Future<List<Elder>> getEldersByUser(String userId, int userType) {
    return remoteDataSources.getEldersByUser(userId, userType);
  }

  @override
  Future<void> linkElder(
    String linkingCode,
    String relatedUserId,
    int userType,
  ) {
    return remoteDataSources.linkElder(linkingCode, relatedUserId, userType);
  }
}
