import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';

class BannedScreen extends StatelessWidget {
  const BannedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GamioTheme.error.withOpacity(0.15),
                border: Border.all(color: GamioTheme.error, width: 3),
                boxShadow: GamioTheme.neonGlow(color: GamioTheme.error, opacity: 0.5),
              ),
              alignment: Alignment.center,
              child: const Text('⚠️', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 32),
            const Text(
              'CUENTA SUSPENDIDA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: GamioTheme.error,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tu cuenta ha sido suspendida de Gamio de forma irreversible por infracción de nuestras políticas de conducta y convivencia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GamioTheme.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Si crees que esto es un error grave de auditoría, ponte en contacto con nuestro equipo directivo en el email oficial de soporte.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GamioTheme.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GamioTheme.error,
                foregroundColor: Colors.white,
                shadowColor: GamioTheme.error.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () async {
                await SupabaseService().logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('CERRAR SESIÓN'),
            ),
          ],
        ),
      ),
    );
  }
}
