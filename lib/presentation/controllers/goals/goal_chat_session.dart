/// Presentation-only chat session model (dummy phase; no domain layer yet).
class GoalChatMessage {
  const GoalChatMessage({required this.isUser, required this.text});

  final bool isUser;
  final String text;

  GoalChatMessage copyWith({bool? isUser, String? text}) {
    return GoalChatMessage(
      isUser: isUser ?? this.isUser,
      text: text ?? this.text,
    );
  }
}

class GoalChatSession {
  const GoalChatSession({
    required this.id,
    required this.title,
    required this.preview,
    required this.updatedAt,
    required this.messages,
  });

  final String id;
  final String title;
  final String preview;
  final DateTime updatedAt;
  final List<GoalChatMessage> messages;

  GoalChatSession copyWith({
    String? id,
    String? title,
    String? preview,
    DateTime? updatedAt,
    List<GoalChatMessage>? messages,
  }) {
    return GoalChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }
}
