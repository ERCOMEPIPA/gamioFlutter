import 'profile.dart';

class Post {
  final String id;
  final String authorId;
  final String content;
  final String? game;
  final String? mode;
  final int? spots;
  final List<String> tags;
  final DateTime createdAt;
  final Profile? author;

  Post({
    required this.id,
    required this.authorId,
    required this.content,
    this.game,
    this.mode,
    this.spots,
    required this.tags,
    required this.createdAt,
    this.author,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      authorId: json['author_id'] ?? '',
      content: json['content'] ?? '',
      game: json['game'],
      mode: json['mode'],
      spots: json['spots'] != null ? int.tryParse(json['spots'].toString()) : null,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toUtc().toIso8601String()),
      author: json['profiles'] != null ? Profile.fromJson(json['profiles']) : null,
    );
  }
}
