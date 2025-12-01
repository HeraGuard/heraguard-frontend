// lib/features/chat/data/datasources/chat_remote_data_source_impl.dart
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'chat_remote_data_sources.dart';
import '../models/message_model.dart';

class ChatRemoteDataSourcesImpl implements ChatRemoteDataSources {
  final ApiClient apiClient;

  ChatRemoteDataSourcesImpl({required this.apiClient});

  @override
  Future<void> sendMessage(MessageModel message) async {
    await apiClient.post(Endpoints.sendMessage, {
      'content': message.message,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
    });
  }

  @override
  Future<List<MessageModel>> getMessages(String user1Id, String user2Id) async {
    final response = await apiClient.get(
      '${Endpoints.getConversation}/$user1Id/$user2Id',
    );

    return (response.data as List)
        .map((json) => MessageModel.fromJson(json))
        .toList();
  }
}
