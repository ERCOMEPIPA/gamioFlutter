import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'theme/gamio_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/navigation/main_layout.dart';
import 'screens/matchmaking/matchmaking_screen.dart';
import 'screens/chat/global_chat_screen.dart';
import 'screens/messages/private_chat_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/support/ticket_screen.dart';
import 'screens/admin/admin_panel_screen.dart';
import 'screens/about/about_screen.dart';
import 'screens/banned/banned_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización segura de Supabase y variables .env
  await SupabaseService.initialize();

  runApp(const GamioApp());
}

class GamioApp extends StatelessWidget {
  const GamioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamio LFG Mobile',
      debugShowCheckedModeBanner: false,
      theme: GamioTheme.darkTheme,
      home: const AuthSessionGate(),
      onGenerateRoute: (settings) {
        if (settings.name == '/chat_private') {
          final conversationId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PrivateChatScreen(conversationId: conversationId),
          );
        }
        if (settings.name == '/matchmaking') {
          final initialGame = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => MatchmakingScreen(initialGameFilter: initialGame),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const MainLayout(initialTab: 0),
        '/chat': (context) => const GlobalChatScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/support': (context) => const TicketScreen(),
        '/admin': (context) => const AdminPanelScreen(),
        '/about': (context) => const AboutScreen(),
        '/banned': (context) => const BannedScreen(),
      },
    );
  }
}

class AuthSessionGate extends StatefulWidget {
  const AuthSessionGate({Key? key}) : super(key: key);

  @override
  State<AuthSessionGate> createState() => _AuthSessionGateState();
}

class _AuthSessionGateState extends State<AuthSessionGate> {
  bool _checkingSession = true;
  String _targetRoute = '/login';

  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    final service = SupabaseService();
    if (!service.isAuthenticated) {
      setState(() {
        _targetRoute = '/login';
        _checkingSession = false;
      });
      return;
    }

    try {
      final profile = await service.getCurrentUserProfile();
      
      if (profile == null) {
        _targetRoute = '/onboarding';
      } else if (profile['is_banned'] == true) {
        _targetRoute = '/banned';
      } else {
        final List favGames = profile['favorite_games'] ?? [];
        if (favGames.isEmpty) {
          _targetRoute = '/onboarding';
        } else {
          _targetRoute = '/dashboard';
        }
      }
    } catch (_) {
      _targetRoute = '/login';
    }

    if (mounted) {
      setState(() {
        _checkingSession = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(
        backgroundColor: GamioTheme.bgPrimary,
        body: Center(
          child: CircularProgressIndicator(color: GamioTheme.primary),
        ),
      );
    }

    // Navegar y reubicar según decisión del Gate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(_targetRoute);
    });

    return const Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      body: SizedBox(),
    );
  }
}
