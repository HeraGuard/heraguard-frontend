class MessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String message;
  final int timestamp;
  final String type;

  MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.type = 'text',
  });

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
