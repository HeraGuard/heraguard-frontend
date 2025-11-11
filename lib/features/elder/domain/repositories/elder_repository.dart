import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';

abstract class ElderRepository {
  Future<List<Elder>> getEldersByUser(String userId, int userType);
  Future<void> linkElder(
    String linkingCode,
    String relatedUserId,
    int userType,
  );
}
