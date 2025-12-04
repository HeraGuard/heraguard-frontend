part of 'chat_bloc.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class PatientsLoaded extends ChatState {
  final List<PatientChatEntity> patients;

  const PatientsLoaded({required this.patients});
}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;

  const MessagesLoaded({required this.messages});
}

class MessagesUpdated extends ChatState {
  final List<MessageEntity> messages;

  const MessagesUpdated({required this.messages});
}

class MessageSending extends ChatState {}

class MessageSendCompleted extends ChatState {}

class MessageSent extends ChatState {
  final List<MessageEntity> messages;

  const MessageSent({required this.messages});
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});
}