import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      CustomAlert.show(
        context: context,
        title: 'Campos Vacíos',
        message: 'Por favor, rellena todos los datos requeridos.',
        type: AlertType.error,
        iconText: '📝',
      );
      return;
    }

    if (password != repeatPassword) {
      CustomAlert.show(
        context: context,
        title: 'Contraseñas Diferentes',
        message: 'Las contraseñas que has introducido no coinciden.',
        type: AlertType.error,
        iconText: '🔒',
      );
      return;
    }

    if (password.length < 6) {
      CustomAlert.show(
        context: context,
        title: 'Contraseña Corta',
        message: 'La contraseña debe tener una longitud mínima de 6 caracteres.',
        type: AlertType.error,
        iconText: '🔑',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().signup(email, password, username);
      
      await CustomAlert.show(
        context: context,
        title: '¡Registro Exitoso!',
        message: 'Tu cuenta ha sido creada. Configura tu perfil para completar tu matchmaking.',
        type: AlertType.success,
        iconText: '🎉',
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Error de Registro',
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
                  // Title
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
                    'Únete a la comunidad de matchmaking e interacción social',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: GamioTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Box
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
                          'CREAR NUEVA CUENTA',
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
                        // Email
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
                        // Username
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'Nombre de usuario',
                            prefixIcon: Icon(Icons.person_outline, color: GamioTheme.textMuted),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Contraseña (mín. 6 caracteres)',
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
                        const SizedBox(height: 16),
                        // Repeat Password
                        TextField(
                          controller: _repeatPasswordController,
                          obscureText: _obscurePassword,
                          decoration: const InputDecoration(
                            hintText: 'Repetir Contraseña',
                            prefixIcon: Icon(Icons.lock_reset_outlined, color: GamioTheme.textMuted),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        // Submit
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GamioTheme.primary,
                              foregroundColor: Colors.black,
                              shadowColor: GamioTheme.primary.withOpacity(0.5),
                              elevation: 5,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'CREAR CUENTA Y CONTINUAR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
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
                        '¿Ya tienes cuenta? ',
                        style: TextStyle(color: GamioTheme.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                        child: const Text(
                          'Inicia Sesión',
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
