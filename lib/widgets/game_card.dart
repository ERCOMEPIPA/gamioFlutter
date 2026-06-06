import 'package:flutter/material.dart';
import '../models/game.dart';
import '../theme/gamio_theme.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const GameCard({
    Key? key,
    required this.game,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color glowColor;
    switch (game.colorTheme.toLowerCase()) {
      case 'violet':
        glowColor = GamioTheme.secondary;
        break;
      case 'blue':
        glowColor = GamioTheme.primary;
        break;
      case 'green':
        glowColor = GamioTheme.success;
        break;
      case 'orange':
        glowColor = GamioTheme.warning;
        break;
      default:
        glowColor = GamioTheme.primary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: GamioTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GamioTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    game.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: GamioTheme.bgTertiary,
                        child: const Icon(
                          Icons.videogame_asset,
                          size: 48,
                          color: GamioTheme.textMuted,
                        ),
                      );
                    },
                  ),
                  // Gradiente inferior para legibilidad del texto
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: glowColor.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: glowColor,
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${game.playersCount} LFG',
                            style: TextStyle(
                              color: glowColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: GamioTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.genre.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: GamioTheme.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
