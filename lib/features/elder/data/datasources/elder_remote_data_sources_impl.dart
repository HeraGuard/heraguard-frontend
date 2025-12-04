import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/elder/data/datasources/elder_remote_data_sources.dart';
import 'package:heraguard_frontend/features/elder/data/models/elder_model.dart';

class ElderRemoteDataSourceImpl implements ElderRemoteDataSources {
  final ApiClient apiClient;

  ElderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ElderModel>> getEldersByUser(String userId, int userType) async {
    final response = await apiClient.get(
      '${Endpoints.getEldersByUser}/$userId',
      queryParameters: {'typeId': userType},
    );
    final List relationships = response.data as List;
    return relationships.map((rel) {
      final elderId = rel['elder']?['id']?.toString();
      final relatedUserId = rel['relatedUser']?['id']?.toString();
      print('Processing: Elder=$elderId, Related=$relatedUserId, User=$userId');
      final isUserElder = elderId == userId;
      final otherPerson = isUserElder ? rel['relatedUser'] : rel['elder'];
      print('IsUserElder: $isUserElder, OtherPerson: ${otherPerson['name']}');
      return ElderModel.fromJson(otherPerson);
    }).toList();
  }

  @override
  Future<void> linkElder(
    String linkingCode,
    String relatedUserId,
    int userType,
  ) async {
    await apiClient.post(Endpoints.relationshipElder, {
      'linkingCode': linkingCode,
      'relatedUserId': relatedUserId,
      'relationshipTypeId': userType,
    });
  }
}
