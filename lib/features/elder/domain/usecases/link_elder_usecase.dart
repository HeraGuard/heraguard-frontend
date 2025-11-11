import 'package:heraguard_frontend/features/elder/domain/repositories/elder_repository.dart';

class LinkElderUsecase {
  final ElderRepository _repository;

  LinkElderUsecase(this._repository);

  Future<void> call(String linkingCode, String relatedUserId, int userType) =>
      _repository.linkElder(linkingCode, relatedUserId, userType);
}
