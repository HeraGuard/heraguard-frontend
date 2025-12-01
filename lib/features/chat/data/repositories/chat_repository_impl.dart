import 'package:firebase_database/firebase_database.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:heraguard_frontend/features/chat/data/models/message_model.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/message_entity.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/patient_chat_entity.dart';
import 'package:heraguard_frontend/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSources chatRemoteDataSource;
  final ApiClient apiClient;

  ChatRepositoryImpl({
    required this.chatRemoteDataSource,
    required this.apiClient,
  });

  @override
  Future<void> sendMessage(MessageEntity message) async {
    final messageModel = MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: message.timestamp,
      type: message.type,
    );
    await chatRemoteDataSource.sendMessage(messageModel);
  }

  @override
  Future<List<MessageEntity>> getMessages(
    String user1Id,
    String user2Id,
  ) async {
    final messageModels = await chatRemoteDataSource.getMessages(
      user1Id,
      user2Id,
    );
    return messageModels
        .map(
          (model) => MessageEntity(
            id: model.id,
            conversationId: model.conversationId,
            senderId: model.senderId,
            receiverId: model.receiverId,
            message: model.message,
            timestamp: model.timestamp,
            type: model.type,
          ),
        )
        .toList();
  }

  @override
  Future<List<PatientChatEntity>> getPatientsForChat(
    String userId,
    int userRole,
  ) async {
    final response = await apiClient.get(
      '${Endpoints.getEldersByUser}/$userId',
      queryParameters: {'typeId': userRole},
    );
    final List relationships = response.data as List;
    return relationships.map((rel) {
      final elder = rel['elder'];
      return PatientChatEntity(
        id: elder['id'] ?? '',
        fullName: '${elder['name']} ${elder['lastName']}',
        email: elder['email'] ?? '',
        conversationId: '${userId}_${elder['id']}',
      );
    }).toList();
  }

  @override
  Stream<List<MessageEntity>> listenToMessages(String conversationId) {
    final databaseRef = FirebaseDatabase.instance.ref('chats/$conversationId');
    return databaseRef.onValue
        .map((event) {
          if (!event.snapshot.exists) {
            return <MessageEntity>[];
          }
          final data = event.snapshot.value;
          if (data == null) {
            return <MessageEntity>[];
          }
          final messagesMap = Map<String, dynamic>.from(data as Map);
          final messages = <MessageEntity>[];
          int count = 0;
          for (final entry in messagesMap.entries) {
            if (count > 100) break;
            final messageData = Map<String, dynamic>.from(entry.value as Map);
            messages.add(
              MessageEntity(
                id: entry.key,
                conversationId: conversationId,
                senderId: messageData['senderId']?.toString() ?? '',
                receiverId: messageData['receiverId']?.toString() ?? '',
                message: messageData['message']?.toString() ?? '',
                timestamp:
                    int.tryParse(messageData['timestamp']?.toString() ?? '0') ??
                    0,
                type: messageData['type']?.toString() ?? 'text',
              ),
            );
            count++;
          }
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          return messages;
        })
        .handleError((error, stack) {
          return <MessageEntity>[];
        });
  }
}
