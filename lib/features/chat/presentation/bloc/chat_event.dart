part of 'chat_bloc.dart';

sealed class ChatEvent {}

class LoadPatientsEvent extends ChatEvent {
  final String userId;
  final int userRole;

  LoadPatientsEvent({required this.userId, required this.userRole});
}

class LoadMessagesEvent extends ChatEvent {
  final String user1Id;
  final String user2Id;

  LoadMessagesEvent({required this.user1Id, required this.user2Id});
}

class SendMessageEvent extends ChatEvent {
  final String content;
  final String senderId;
  final String receiverId;
  final String conversationId;

  SendMessageEvent({
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
  });
}

class StartListeningMessagesEvent extends ChatEvent {
  final String conversationId;

  StartListeningMessagesEvent({required this.conversationId});
}

class StopListeningMessagesEvent extends ChatEvent {}

class MessagesUpdatedEvent extends ChatEvent {
  final List<MessageEntity> messages;

  MessagesUpdatedEvent({required this.messages});
}
