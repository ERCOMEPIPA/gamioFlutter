import 'package:flutter/material.dart';
import '../../theme/gamio_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: const Text(
          'QUIÉNES SOMOS',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🎮 PROYECTO GAMIO',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gamio nace como una solución de ingeniería técnica diseñada bajo los estándares de un Trabajo de Fin de Grado (TFG) / Auditoría Senior de Software. Su misión principal es erradicar la toxicidad en los emparejamientos casuales y competitivos, fomentando una comunidad de respeto mutuo recompensada mediante gamificación transaccional segura.',
              style: TextStyle(color: GamioTheme.textSecondary, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 28),
            const Text(
              'EQUIPO FUNDADOR',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: GamioTheme.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 14),
            _buildFounderCard(
              'Francisco Virlán Rodríguez',
              'Software Architect & Lead Developer',
              'Estudiante de 2º DAM (VictoriaFP). Diseñador de la base de datos PostgreSQL, triggers RLS de baneo atómicos y enrutamiento híbrido.',
            ),
            const SizedBox(height: 16),
            _buildFounderCard(
              'Antigravity AI',
              'Pair Programmer & Assessor',
              'Diseñador de las islas de reactividad, sincronización WebSocket en tiempo real de Supabase y diseño responsivo móvil premium.',
            ),
            const SizedBox(height: 28),
            // Tech Stack details
            const Text(
              'TECNOLOGÍAS DE LA APP MÓVIL',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: GamioTheme.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GamioTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GamioTheme.borderColor),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Flutter 3.38.9 SDK', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• Dart 3.10.8 Language', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• Supabase Realtime Channels (WebSockets)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• Row Level Security (RLS) & Triggers Postgres', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFounderCard(String name, String role, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GamioTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GamioTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          const SizedBox(height: 2),
          Text(role, style: const TextStyle(color: GamioTheme.accentLight, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: GamioTheme.textSecondary, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
