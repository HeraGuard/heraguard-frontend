import 'package:heraguard_frontend/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSources {
  Future<void> sendMessage(MessageModel message);
  Future<List<MessageModel>> getMessages(String user1Id, String user2Id);
}
