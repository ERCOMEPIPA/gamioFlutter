import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomAlert.show(
        context: context,
        title: 'Campos Vacíos',
        message: 'Por favor, introduce tu email y contraseña.',
        type: AlertType.error,
        iconText: '🔒',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().login(email, password);
      
      // Consultar perfil para comprobar baneos u onboarding
      final profile = await SupabaseService().getCurrentUserProfile();
      
      if (profile == null) {
        // Enrutar al onboarding si no hay perfil
        Navigator.of(context).pushReplacementNamed('/onboarding');
        return;
      }

      if (profile['is_banned'] == true) {
        Navigator.of(context).pushReplacementNamed('/banned');
        return;
      }

      final List favoriteGames = profile['favorite_games'] ?? [];
      if (favoriteGames.isEmpty) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Error de Acceso',
        message: e.toString().replaceAll('Exception:', '').trim(),
        type: AlertType.error,
        iconText: '❌',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: GamioTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Text(
                    'GAMIO',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      foreground: Paint()..shader = GamioTheme.neonTextShader,
                      shadows: [
                        Shadow(
                          color: GamioTheme.primary.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Plataforma Social de Gamificación LFG',
                    style: TextStyle(
                      color: GamioTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: GamioTheme.surfaceCard.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: GamioTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'INICIAR SESIÓN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Email input
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined, color: GamioTheme.textMuted),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        // Password input
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline, color: GamioTheme.textMuted),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: GamioTheme.textMuted,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        // Submit button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GamioTheme.secondary,
                              shadowColor: GamioTheme.secondary.withOpacity(0.5),
                              elevation: 5,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'ENTRAR AL LOBBY',
                                    style: TextStyle(letterSpacing: 1.0),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(color: GamioTheme.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed('/signup'),
                        child: const Text(
                          'Regístrate gratis',
                          style: TextStyle(
                            color: GamioTheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
