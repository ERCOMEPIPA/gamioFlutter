import 'profile.dart';

class Message {
  final String id;
  final String profileId;
  final String content;
  final String room; // For global chats
  final String? conversationId; // For private chats
  final DateTime createdAt;
  final Profile? author;
  final bool isOptimistic; // local indicator

  Message({
    required this.id,
    required this.profileId,
    required this.content,
    required this.room,
    this.conversationId,
    required this.createdAt,
    this.author,
    this.isOptimistic = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString() ?? '',
      profileId: json['profile_id'] ?? '',
      content: json['content'] ?? '',
      room: json['room'] ?? 'global',
      conversationId: json['conversation_id']?.toString(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toUtc().toIso8601String()),
      author: json['profiles'] != null ? Profile.fromJson(json['profiles']) : null,
    );
  }
}
