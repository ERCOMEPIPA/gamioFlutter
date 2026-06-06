import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _totalGamers = 0;
  bool _isLoadingStats = true;
  int _activeTimelineStep = 0;

  final List<Map<String, String>> _popularGames = [
    {
      'name': 'League of Legends',
      'image': 'https://images.igdb.com/igdb/image/upload/t_cover_big/co49wj.jpg'
    },
    {
      'name': 'Valorant',
      'image': 'https://images.igdb.com/igdb/image/upload/t_cover_big/co2mvt.jpg'
    },
    {
      'name': 'EA FC 25',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/2669320/library_600x900.jpg'
    },
    {
      'name': 'Call of Duty: Warzone',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/1962663/library_600x900.jpg'
    },
  ];

  final List<Map<String, String>> _timelineSteps = [
    {
      'title': '1. REGÍSTRATE Y ÚNETE 🎮',
      'desc': 'Crea tu perfil gaming de forma 100% gratuita y accede de inmediato al Lobby general.'
    },
    {
      'title': '2. DEFINE TU ONBOARDING 📝',
      'desc': 'Configura tus videojuegos favoritos, estilo competitivo y horas de conexión preferentes.'
    },
    {
      'title': '3. BUSCA AFINIDAD LFG 🛡️',
      'desc': 'Nuestro emparejador te presentará escuadrones compatibles. ¡Dile adiós a la toxicidad!'
    },
    {
      'title': '4. GANA RIOT POINTS Y MÁS 💎',
      'desc': 'Acumula puntos por interactuar sanamente y canjéalos por monedas virtuales reales en la Tienda.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final profiles = await SupabaseService().fetchAllProfiles();
      setState(() {
        _totalGamers = profiles.length;
        _isLoadingStats = false;
      });
    } catch (_) {
      setState(() => _isLoadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Cyberpunk banner
          _buildHero(),
          const SizedBox(height: 28),
          // Stats Row
          _buildStats(),
          const SizedBox(height: 32),
          // Games Slider Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'JUEGOS POPULARES',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Cambiar de tab a Catálogo de Juegos
                },
                child: const Text(
                  'Ver Catálogo',
                  style: TextStyle(
                    color: GamioTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Games Slider list
          _buildGamesSlider(),
          const SizedBox(height: 36),
          // Sequential Timeline
          const Text(
            'CÓMO FUNCIONA GAMIO',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeline(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GamioTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GamioTheme.primary.withOpacity(0.15)),
        boxShadow: GamioTheme.neonGlow(color: GamioTheme.primary, opacity: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: GamioTheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GamioTheme.secondary.withOpacity(0.5)),
            ),
            child: const Text(
              '🎮 PLATAFORMA DE PRODUCCIÓN',
              style: TextStyle(
                color: GamioTheme.secondaryLight,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'CONECTA Y JUEGA SIN LÍMITES',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Entra en el motor LFG definitivo, chatea en tiempo real con amigos y canjea tus puntos por premios reales.',
            style: TextStyle(
              color: GamioTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            '${_isLoadingStats ? '...' : _totalGamers}',
            'MIEMBROS REGISTRADOS',
            GamioTheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            '100% SEC',
            'AUTENTICACIÓN RLS',
            GamioTheme.accent,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: GamioTheme.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GamioTheme.borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: [
                Shadow(color: color.withOpacity(0.3), blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: GamioTheme.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesSlider() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _popularGames.length,
        itemBuilder: (context, index) {
          final game = _popularGames[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: GamioTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GamioTheme.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    game['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    game['name']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GamioTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GamioTheme.borderColor),
      ),
      child: Column(
        children: List.generate(_timelineSteps.length, (index) {
          final step = _timelineSteps[index];
          final isActive = _activeTimelineStep == index;
          return GestureDetector(
            onTap: () => setState(() => _activeTimelineStep = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isActive ? GamioTheme.bgTertiary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? GamioTheme.primary.withOpacity(0.5) : Colors.transparent,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? GamioTheme.primary : GamioTheme.borderColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.black : GamioTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isActive ? GamioTheme.primaryLight : Colors.white,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(height: 6),
                          Text(
                            step['desc']!,
                            style: const TextStyle(
                              color: GamioTheme.textSecondary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
