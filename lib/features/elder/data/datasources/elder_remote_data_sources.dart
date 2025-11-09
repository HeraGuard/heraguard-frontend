import 'package:heraguard_frontend/features/elder/data/models/elder_model.dart';

abstract class ElderRemoteDataSources {
  Future<List<ElderModel>> getEldersByUser(String userId, int userType);
  Future<void> linkElder(
    String linkingCode,
    String relatedUserId,
    int userType,
  );
}
