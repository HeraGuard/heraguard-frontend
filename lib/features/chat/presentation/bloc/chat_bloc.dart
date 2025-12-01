import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/message_entity.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/patient_chat_entity.dart';
import 'package:heraguard_frontend/features/chat/domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadPatientsEvent>(_onLoadPatients);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<StartListeningMessagesEvent>(_onStartListeningMessages);
    on<StopListeningMessagesEvent>(_onStopListeningMessages);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
  }

  // Future<void> _onLoadPatients(
  //   LoadPatientsEvent event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   emit(ChatLoading());
  //   try {
  //     final patients = await chatRepository.getPatientsForChat(
  //       event.userId,
  //       event.userRole,
  //     );
  //     emit(PatientsLoaded(patients: patients));
  //   } catch (e) {
  //     emit(ChatError(message: 'Error loading patients: ${e.toString()}'));
  //   }
  // }

  Future<void> _onLoadPatients(
    LoadPatientsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      print('=== LOAD PATIENTS REQUEST ===');
      print('UserId: ${event.userId}');
      print('UserRole: ${event.userRole}');

      final patients = await chatRepository.getPatientsForChat(
        event.userId,
        event.userRole,
      );

      print('=== PATIENTS RESPONSE ===');
      print('Patients count: ${patients.length}');
      print('Patients: $patients');

      emit(PatientsLoaded(patients: patients));
    } catch (e) {
      print('=== LOAD PATIENTS ERROR ===');
      print('Error: $e');
      emit(ChatError(message: 'Error loading patients: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.getMessages(
        event.user1Id,
        event.user2Id,
      );
      emit(MessagesLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(message: 'Error loading messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(MessageSending());

      final message = MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: event.conversationId,
        senderId: event.senderId,
        receiverId: event.receiverId,
        message: event.content,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        type: 'text',
      );

      await chatRepository.sendMessage(message);

      // Después de enviar, recargar mensajes para incluir el nuevo
      final updatedMessages = await chatRepository.getMessages(
        event.senderId,
        event.receiverId,
      );
      emit(MessageSent(messages: updatedMessages));
    } catch (e) {
      emit(ChatError(message: 'Error sending message: ${e.toString()}'));
    }
  }

  void _onStartListeningMessages(
    StartListeningMessagesEvent event,
    Emitter<ChatState> emit,
  ) {
    _messagesSubscription?.cancel();

    _messagesSubscription = chatRepository
        .listenToMessages(event.conversationId)
        .listen((messages) {
          add(MessagesUpdatedEvent(messages: messages));
        });
  }

  void _onStopListeningMessages(
    StopListeningMessagesEvent event,
    Emitter<ChatState> emit,
  ) {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  void _onMessagesUpdated(MessagesUpdatedEvent event, Emitter<ChatState> emit) {
    emit(MessagesUpdated(messages: event.messages));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
