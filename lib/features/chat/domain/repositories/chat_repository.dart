import 'package:heraguard_frontend/features/chat/domain/entities/message_entity.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/patient_chat_entity.dart';

abstract class ChatRepository {
  Future<void> sendMessage(MessageEntity message);
  Future<List<MessageEntity>> getMessages(String user1Id, String user2Id);
  Future<List<PatientChatEntity>> getPatientsForChat(
    String userId,
    int userRole,
  );
  Stream<List<MessageEntity>> listenToMessages(String conversationId);
}
