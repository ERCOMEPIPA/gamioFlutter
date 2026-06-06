import 'package:flutter/material.dart';
import '../theme/gamio_theme.dart';

enum AlertType { info, confirm, error, success }

class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final String iconText;

  const CustomAlert({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.iconText = '🚩',
  }) : super(key: key);

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required AlertType type,
    String primaryButtonText = 'Aceptar',
    String? secondaryButtonText,
    String iconText = '👾',
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: type != AlertType.error,
      builder: (context) => CustomAlert(
        title: title,
        message: message,
        type: type,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        iconText: iconText,
        onPrimaryPressed: () => Navigator.of(context).pop(true),
        onSecondaryPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor;
    switch (type) {
      case AlertType.confirm:
        themeColor = GamioTheme.warning;
        break;
      case AlertType.error:
        themeColor = GamioTheme.error;
        break;
      case AlertType.success:
        themeColor = GamioTheme.success;
        break;
      case AlertType.info:
      default:
        themeColor = GamioTheme.primary;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: GamioTheme.bgSecondary.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: themeColor.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 40,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: themeColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Neon Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeColor.withOpacity(0.15),
                border: Border.all(color: themeColor, width: 2),
                boxShadow: GamioTheme.neonGlow(color: themeColor, opacity: 0.3),
              ),
              alignment: Alignment.center,
              child: Text(
                iconText,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GamioTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (secondaryButtonText != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: GamioTheme.borderLight),
                      ),
                      onPressed: onSecondaryPressed,
                      child: Text(
                        secondaryButtonText!,
                        style: const TextStyle(
                          color: GamioTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == AlertType.error ? GamioTheme.error : themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: themeColor.withOpacity(0.5),
                      elevation: 5,
                    ),
                    onPressed: onPrimaryPressed,
                    child: Text(
                      primaryButtonText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
