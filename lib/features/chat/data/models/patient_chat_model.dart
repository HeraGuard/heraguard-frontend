class PatientChatModel {
  final String id;
  final String fullName;
  final String email;
  final String conversationId;

  PatientChatModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.conversationId,
  });

  factory PatientChatModel.fromRelationshipJson(Map<String, dynamic> json) {
    return PatientChatModel(
      id: json['elder']['id'] ?? '',
      fullName: '${json['elder']['name']} ${json['elder']['lastName']}',
      email: json['elder']['email'] ?? '',
      conversationId: '${json['relatedUser']['id']}_${json['elder']['id']}',
    );
  }
}
