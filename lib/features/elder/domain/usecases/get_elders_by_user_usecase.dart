import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';
import 'package:heraguard_frontend/features/elder/domain/repositories/elder_repository.dart';

class GetEldersByUserUsecase {
  final ElderRepository repository;

  GetEldersByUserUsecase(this.repository);

  Future<List<Elder>> call(String userId, int userType) {
    return repository.getEldersByUser(userId, userType);
  }
}
