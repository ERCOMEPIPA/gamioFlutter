import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/gamio_theme.dart';
import 'neon_border.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final VoidCallback onDelete;
  final VoidCallback onMessage;

  const PostCard({
    Key? key,
    required this.post,
    required this.currentUserId,
    required this.onDelete,
    required this.onMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authorName = post.author?.name ?? 'Usuario';
    final hasLfgInfo = post.mode != null || post.spots != null || post.tags.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NeonBorder(
                  borderType: post.author?.selectedBorder ?? '',
                  radius: 20,
                  child: post.author?.avatarUrl.isNotEmpty == true
                      ? Image.network(
                          post.author!.avatarUrl,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (c, e, s) => _defaultAvatar(authorName),
                        )
                      : _defaultAvatar(authorName),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: GamioTheme.textPrimary,
                            ),
                          ),
                          if (post.author?.selectedTitle.isNotEmpty == true) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: GamioTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: GamioTheme.accent.withOpacity(0.3)),
                              ),
                              child: Text(
                                post.author!.selectedTitle,
                                style: const TextStyle(
                                  color: GamioTheme.accentLight,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(post.createdAt),
                        style: const TextStyle(
                          color: GamioTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (post.game != null && post.game!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [GamioTheme.primary, GamioTheme.accent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      post.game!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            if (hasLfgInfo) ...[
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (post.mode != null && post.mode!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: GamioTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: GamioTheme.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        post.mode!,
                        style: const TextStyle(
                          color: GamioTheme.primaryLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (post.spots != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: GamioTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: GamioTheme.success.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Faltan ${post.spots}',
                        style: const TextStyle(
                          color: GamioTheme.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ...post.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: GamioTheme.bgTertiary,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: GamioTheme.borderColor),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: GamioTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Text(
              post.content,
              style: const TextStyle(
                color: GamioTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: GamioTheme.borderColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (post.authorId == currentUserId)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: GamioTheme.error),
                    tooltip: 'Eliminar Anuncio',
                    onPressed: onDelete,
                  )
                else
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    icon: const Icon(Icons.forum_outlined, size: 16),
                    label: const Text('Enviar Mensaje', style: TextStyle(fontSize: 12)),
                    onPressed: onMessage,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar(String name) {
    return Container(
      color: GamioTheme.secondary,
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} horas';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
