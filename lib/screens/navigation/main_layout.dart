import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/neon_border.dart';
import '../community/community_screen.dart';
import '../dashboard/home_screen.dart';
import '../games/games_screen.dart';
import '../messages/inbox_screen.dart';
import '../shop/rewards_screen.dart';

class MainLayout extends StatefulWidget {
  final int initialTab;

  const MainLayout({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  Map<String, dynamic>? _profile;
  bool _isLoadingProfile = true;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GamesScreen(),
    const CommunityScreen(),
    const RewardsScreen(),
    const InboxScreen(),
  ];

  StreamSubscription? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _loadProfile();
    _subscribeToProfile();
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await SupabaseService().getCurrentUserProfile();
    if (profile != null) {
      if (profile['is_banned'] == true) {
        Navigator.of(context).pushReplacementNamed('/banned');
        return;
      }
      setState(() {
        _profile = profile;
        _isLoadingProfile = false;
      });
    }
  }

  void _subscribeToProfile() {
    _profileSubscription?.cancel();
    _profileSubscription = SupabaseService().getProfileStream().listen((profile) {
      if (profile.isNotEmpty) {
        if (profile['is_banned'] == true) {
          Navigator.of(context).pushReplacementNamed('/banned');
          return;
        }
        if (mounted) {
          setState(() {
            _profile = profile;
            _isLoadingProfile = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile?['name'] ?? 'Cargando...';
    final title = _profile?['selected_title'] ?? '';
    final border = _profile?['selected_border'] ?? '';
    final points = _profile?['points'] ?? 0;
    final isAdmin = _profile?['is_admin'] ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: Text(
          _currentIndex == 0
              ? 'GAMIO 🎮'
              : _currentIndex == 1
                  ? 'CATÁLOGO DE JUEGOS'
                  : _currentIndex == 2
                      ? 'COMUNIDAD LFG'
                      : _currentIndex == 3
                          ? 'TIENDA DE PREMIOS'
                          : 'CHAT PRIVADO',
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          // Points Counter indicator on Topbar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: GamioTheme.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GamioTheme.borderColor),
            ),
            child: Row(
              children: [
                const Text('💎 ', style: TextStyle(fontSize: 12)),
                Text(
                  '$points pts',
                  style: const TextStyle(
                    color: GamioTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: GamioTheme.bgPrimary,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: GamioTheme.bgSecondary,
                border: Border(
                  bottom: BorderSide(color: GamioTheme.borderColor, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeonBorder(
                    borderType: border,
                    radius: 32,
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: _profile?['avatar_url']?.isNotEmpty == true
                          ? Image.network(
                              _profile!['avatar_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => _defaultAvatar(name),
                            )
                          : _defaultAvatar(name),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  if (title.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      GamioTheme.translateTitle(title).toUpperCase(),
                      style: const TextStyle(
                        color: GamioTheme.accentLight,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    SupabaseService().currentUser?.email ?? '',
                    style: const TextStyle(
                      color: GamioTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Menu items
            ListTile(
              leading: const Icon(Icons.dashboard_outlined, color: GamioTheme.textSecondary),
              title: const Text('Inicio / Novedades'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_outlined, color: GamioTheme.textSecondary),
              title: const Text('Buscador de Jugadores (LFG)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/matchmaking');
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum_outlined, color: GamioTheme.textSecondary),
              title: const Text('Sala de Chat Global'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/chat');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: GamioTheme.textSecondary),
              title: const Text('Mi Perfil e Inventario'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/profile').then((_) => _loadProfile());
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent, color: GamioTheme.textSecondary),
              title: const Text('Soporte Técnico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/support');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: GamioTheme.textSecondary),
              title: const Text('Quiénes Somos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/about');
              },
            ),
            if (isAdmin) ...[
              const Divider(color: GamioTheme.borderColor),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined, color: GamioTheme.warning),
                title: const Text('Panel de Administración', style: TextStyle(color: GamioTheme.warning)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/admin');
                },
              ),
            ],
            const Spacer(),
            const Divider(color: GamioTheme.borderColor),
            ListTile(
              leading: const Icon(Icons.logout, color: GamioTheme.error),
              title: const Text('Cerrar Sesión', style: TextStyle(color: GamioTheme.error)),
              onTap: () async {
                Navigator.pop(context);
                await SupabaseService().logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Juegos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Comunidad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Chat Privado',
          ),
        ],
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
          fontSize: 24,
        ),
      ),
    );
  }
}
