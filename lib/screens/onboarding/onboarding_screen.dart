import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Games
  final List<String> _availableGames = [
    'League of Legends',
    'Valorant',
    'EA FC 25',
    'Dead By Daylight',
    'Call of Duty: Warzone',
    'Rocket League',
    'Fortnite',
    'Apex Legends',
  ];
  final List<String> _selectedGames = [];

  // Step 2: Style
  final List<String> _styles = [
    'Competitivo 🔥 (Tryhard)',
    'Casual 🎮 (Relax)',
    'Cooperativo 🛡️ (Team player)',
    'Trollete 👾 (Fun & memes)',
  ];
  String _selectedStyle = 'Casual 🎮 (Relax)';

  // Step 3: Schedule
  final List<String> _schedules = [
    'Mañanas 🌅 (09:00 - 14:00)',
    'Tardes 🌇 (14:00 - 20:00)',
    'Noches 🌌 (20:00 - 02:00)',
    'Madrugadas 🧛 (02:00 - 08:00)',
    'Todo el día ⚡ (Flexibilidad)',
  ];
  String _selectedSchedule = 'Tardes 🌇 (14:00 - 20:00)';

  void _nextStep() {
    if (_currentStep == 0 && _selectedGames.isEmpty) {
      CustomAlert.show(
        context: context,
        title: 'Selección Requerida',
        message: 'Por favor, selecciona al menos un juego de tu preferencia para continuar.',
        type: AlertType.error,
        iconText: '🎮',
      );
      return;
    }

    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitOnboarding();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitOnboarding() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseService().saveOnboarding(
        favoriteGames: _selectedGames,
        gameStyle: _selectedStyle,
        timeSlot: _selectedSchedule,
      );
      
      await CustomAlert.show(
        context: context,
        title: '¡Perfil Completado!',
        message: '¡Excelente! Te hemos otorgado +10 Puntos de fidelidad y +20 XP de bienvenida.',
        type: AlertType.success,
        iconText: '💎',
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Fallo al Guardar',
        message: e.toString(),
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
      backgroundColor: GamioTheme.bgPrimary,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Step indicators
                    Row(
                      children: List.generate(3, (index) {
                        final active = index <= _currentStep;
                        return Expanded(
                          child: Container(
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: active
                                  ? (index == _currentStep ? GamioTheme.primary : GamioTheme.secondary)
                                  : GamioTheme.borderColor,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: active && index == _currentStep
                                  ? GamioTheme.neonGlow(color: GamioTheme.primary, opacity: 0.5)
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (step) => setState(() => _currentStep = step),
                        children: [
                          _buildGamesStep(),
                          _buildStyleStep(),
                          _buildScheduleStep(),
                        ],
                      ),
                    ),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              side: const BorderSide(color: GamioTheme.borderColor),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _prevStep,
                            child: const Text('ATRÁS', style: TextStyle(color: Colors.white)),
                          )
                        else
                          const SizedBox(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GamioTheme.primary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            shadowColor: GamioTheme.primary.withOpacity(0.4),
                          ),
                          onPressed: _nextStep,
                          child: Text(
                            _currentStep == 2 ? 'COMPLETAR PERFIL' : 'SIGUIENTE',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGamesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TUS JUEGOS FAVORITOS',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selecciona los videojuegos que dominas o buscas jugar en equipo. (Elige mínimo uno)',
          style: TextStyle(color: GamioTheme.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: _availableGames.length,
            itemBuilder: (context, index) {
              final game = _availableGames[index];
              final isSelected = _selectedGames.contains(game);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedGames.remove(game);
                    } else {
                      _selectedGames.add(game);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? GamioTheme.secondary.withOpacity(0.2) : GamioTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? GamioTheme.primary : GamioTheme.borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: GamioTheme.primary.withOpacity(0.15), blurRadius: 10)]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    game,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected ? Colors.white : GamioTheme.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStyleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ESTILO DE JUEGO',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '¿Cuál es tu actitud habitual en tus sesiones de juego cooperativas?',
          style: TextStyle(color: GamioTheme.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.builder(
            itemCount: _styles.length,
            itemBuilder: (context, index) {
              final style = _styles[index];
              final isSelected = _selectedStyle == style;
              return GestureDetector(
                onTap: () => setState(() => _selectedStyle = style),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? GamioTheme.secondary.withOpacity(0.15) : GamioTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? GamioTheme.primary : GamioTheme.borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? GamioTheme.primary : GamioTheme.textMuted,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        style,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : GamioTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FRANJA HORARIA',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '¿A qué hora del día sueles conectarte habitualmente para jugar?',
          style: TextStyle(color: GamioTheme.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _schedules.length,
            itemBuilder: (context, index) {
              final sched = _schedules[index];
              final isSelected = _selectedSchedule == sched;
              return GestureDetector(
                onTap: () => setState(() => _selectedSchedule = sched),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? GamioTheme.secondary.withOpacity(0.15) : GamioTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? GamioTheme.primary : GamioTheme.borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? GamioTheme.primary : GamioTheme.textMuted,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        sched,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : GamioTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
