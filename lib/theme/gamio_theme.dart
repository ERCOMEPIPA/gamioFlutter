import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamioTheme {
  // --- Cyberpunk Core Palette ---
  static const Color bgPrimary = Color(0xFF0A0E17);
  static const Color bgSecondary = Color(0xFF0F141F);
  static const Color bgTertiary = Color(0xFF131A28);

  static const Color primary = Color(0xFF00F0FF); // Cyan Neon
  static const Color primaryLight = Color(0xFF66FBFF);
  static const Color primaryDark = Color(0xFF00B8C4);

  static const Color secondary = Color(0xFF6C3AFF); // Electric Purple
  static const Color secondaryLight = Color(0xFF9470FF);
  static const Color secondaryDark = Color(0xFF4C20D6);

  static const Color accent = Color(0xFFFF3CAC); // Hot Pink
  static const Color accentLight = Color(0xFFFF6B6B);
  static const Color accentDark = Color(0xFFD62A87);

  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);

  static const Color surfaceCard = Color(0xFF111827);
  static const Color surfaceHover = Color(0xFF192336);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color borderColor = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFF334155);

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [bgPrimary, bgSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient textAccentGradient = LinearGradient(
    colors: [accent, accentLight],
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [primary, accent, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Decorative BoxShadows for Neon Glow ---
  static List<BoxShadow> neonGlow({Color color = primary, double opacity = 0.3}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: 15,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: color.withOpacity(opacity * 0.5),
        blurRadius: 30,
        spreadRadius: 4,
      ),
    ];
  }

  // --- Store Rewards Border Styles ---
  static BoxDecoration bronzeBorder = BoxDecoration(
    border: Border.all(color: const Color(0xFFCD7F32), width: 2),
    boxShadow: neonGlow(color: const Color(0xFFCD7F32), opacity: 0.3),
  );

  static BoxDecoration silverBorder = BoxDecoration(
    border: Border.all(color: const Color(0xFFC0C0C0), width: 2),
    boxShadow: neonGlow(color: const Color(0xFFC0C0C0), opacity: 0.4),
  );

  static BoxDecoration goldBorder = BoxDecoration(
    border: Border.all(color: const Color(0xFFFFD700), width: 2),
    boxShadow: neonGlow(color: const Color(0xFFFFD700), opacity: 0.5),
  );

  // --- Dynamic Neon Border (Avatar Decorator) ---
  static Shader neonTextShader = const LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFFFF3CAC)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  // --- ThemeData Factory ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        background: bgPrimary,
        surface: surfaceCard,
        error: error,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondary.withOpacity(0.7),
        hintStyle: const TextStyle(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: secondary,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSecondary,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }

  static const Map<String, String> titleTranslation = {
    '': 'Sin Título Equipado 🚫',
    'title_casual': 'Gamer Casual 🎮',
    'title_support': 'Soporte de Élite 🛡️',
    'title_lone_wolf': 'Lobo Solitario 🐺',
    'title_tryhard': 'Tryhard Certificado 🔥',
    'title_legend': 'Leyenda Viviente 🏆',
  };

  static const Map<String, String> borderTranslation = {
    '': 'Sin Marco Equipado 🚫',
    'border_bronze': 'Borde de Bronce 🥉',
    'border_silver': 'Borde de Plata 🥈',
    'border_gold': 'Borde de Oro 🥇',
    'border_neon': 'Neón Psicodélico 🌈',
  };

  static String translateTitle(String titleKey) {
    return titleTranslation[titleKey] ?? titleKey;
  }

  static String translateBorder(String borderKey) {
    return borderTranslation[borderKey] ?? borderKey;
  }
}
