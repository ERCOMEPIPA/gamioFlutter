import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/reward.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  Map<String, dynamic>? _profile;
  List<Reward> _rewards = [];
  bool _isLoading = true;
  Timer? _countdownTimer;
  Duration _timeUntilNextClaim = Duration.zero;

  StreamSubscription? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _loadShopData();
    _subscribeToProfile();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToProfile() {
    _profileSubscription?.cancel();
    _profileSubscription = SupabaseService().getProfileStream().listen((profile) {
      if (profile.isNotEmpty && mounted) {
        setState(() {
          _profile = profile;
        });
        _startDailyCountdown();
      }
    });
  }

  Future<void> _loadShopData() async {
    try {
      final profile = await SupabaseService().getCurrentUserProfile();
      final List<dynamic> dbRewards = await SupabaseService().client.from('rewards').select();
      
      setState(() {
        _profile = profile;
        _rewards = dbRewards.map((json) => Reward.fromJson(json)).toList();
        _isLoading = false;
      });

      _startDailyCountdown();
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _startDailyCountdown() {
    _countdownTimer?.cancel();
    final lastClaimStr = _profile?['last_daily_claim'];
    if (lastClaimStr == null) return;

    final lastClaim = DateTime.parse(lastClaimStr).toLocal();
    final nextClaim = lastClaim.add(const Duration(hours: 24));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(nextClaim)) {
        setState(() {
          _timeUntilNextClaim = Duration.zero;
          timer.cancel();
        });
      } else {
        setState(() {
          _timeUntilNextClaim = nextClaim.difference(now);
        });
      }
    });
  }

  Future<void> _claimDailyPoints() async {
    setState(() => _isLoading = true);
    try {
      final awarded = await SupabaseService().claimDailyPoints();
      await CustomAlert.show(
        context: context,
        title: '¡Recompensa Reclamada!',
        message: 'Has obtenido +$awarded Puntos y +$awarded XP de regalo diario.',
        type: AlertType.success,
        iconText: '🎁',
      );
      _loadShopData();
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'No Disponible',
        message: e.toString().replaceAll('Exception:', '').trim(),
        type: AlertType.error,
        iconText: '⏰',
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buyReward(Reward reward) async {
    final userPoints = _profile?['points'] ?? 0;
    if (userPoints < reward.cost) {
      CustomAlert.show(
        context: context,
        title: 'Saldo Insuficiente',
        message: 'Necesitas tener al menos ${reward.cost} Puntos para canjear "${reward.title}". Actualmente tienes $userPoints pts.',
        type: AlertType.error,
        iconText: '💎',
      );
      return;
    }

    final List claimedList = _profile?['claimed_rewards'] ?? [];
    if (claimedList.contains(reward.id)) {
      CustomAlert.show(
        context: context,
        title: 'Premio Adquirido',
        message: 'Ya has comprado esta recompensa anteriormente. Ve a tu perfil para equiparla.',
        type: AlertType.error,
        iconText: '🛡️',
      );
      return;
    }

    final confirm = await CustomAlert.show(
      context: context,
      title: 'Confirmar Canje',
      message: '¿Estás seguro de que deseas canjear "${reward.title}" por un costo de ${reward.cost} Puntos?',
      type: AlertType.confirm,
      primaryButtonText: 'CANJEAR',
      secondaryButtonText: 'CANCELAR',
      iconText: '🛒',
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final success = await SupabaseService().buyReward(reward.id);
        if (success) {
          await CustomAlert.show(
            context: context,
            title: 'Canje Exitoso 🎉',
            message: 'Has adquirido "${reward.title}". Si es un cosmético, ya puedes equiparlo desde tu perfil. Si es saldo de juego, abre un ticket en Soporte con tu ID para cargarlo.',
            type: AlertType.success,
            iconText: '✅',
          );
        }
        _loadShopData();
      } catch (e) {
        CustomAlert.show(
          context: context,
          title: 'Error de Compra',
          message: e.toString(),
          type: AlertType.error,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _profile == null) {
      return const Center(child: CircularProgressIndicator(color: GamioTheme.primary));
    }

    final points = _profile?['points'] ?? 0;
    final xp = _profile?['xp'] ?? 0;
    final level = _profile?['level'] ?? 1;
    final claimed = List<String>.from(_profile?['claimed_rewards'] ?? []);

    final showDailyButton = _timeUntilNextClaim == Duration.zero;

    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header Info Stats card
            _buildUserStatsCard(points, xp, level),
            const SizedBox(height: 24),
            // Daily check-in claim card
            _buildDailyClaimCard(showDailyButton),
            const SizedBox(height: 32),
            // Store Title section
            const Text(
              'CATÁLOGO DE RECOMPENSAS',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            // Store items
            _rewards.isEmpty
                ? const Center(
                    child: Text(
                      'No hay premios disponibles.',
                      style: TextStyle(color: GamioTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _rewards.length,
                    itemBuilder: (context, index) {
                      final reward = _rewards[index];
                      final isAlreadyBought = claimed.contains(reward.id);
                      return _buildRewardItemCard(reward, isAlreadyBought);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatsCard(int points, int xp, int level) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GamioTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GamioTheme.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PUNTOS DISPONIBLES',
                    style: TextStyle(
                      color: GamioTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('💎 ', style: TextStyle(fontSize: 20)),
                      Text(
                        '$points',
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: GamioTheme.primary,
                        ),
                      ),
                      const Text(
                        ' pts',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: GamioTheme.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: GamioTheme.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GamioTheme.secondary),
                ),
                child: Text(
                  'NIVEL $level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('PROGRESO NIVEL (XP)', style: TextStyle(fontSize: 10, color: GamioTheme.textSecondary)),
              Text('${xp % 100}/100 XP', style: const TextStyle(fontSize: 10, color: GamioTheme.primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (xp % 100) / 100,
              backgroundColor: GamioTheme.bgPrimary,
              valueColor: const AlwaysStoppedAnimation<Color>(GamioTheme.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyClaimCard(bool showDailyButton) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GamioTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GamioTheme.accent.withOpacity(0.2)),
        boxShadow: GamioTheme.neonGlow(color: GamioTheme.accent, opacity: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('🎁 ', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              const Text(
                'RECOMPENSA DIARIA',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Reclama gratis +25 Puntos y +25 XP de Experiencia cada 24 horas por hacer check-in.',
            style: TextStyle(color: GamioTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: showDailyButton ? GamioTheme.accent : GamioTheme.bgPrimary,
              foregroundColor: showDailyButton ? Colors.white : GamioTheme.textMuted,
              disabledBackgroundColor: GamioTheme.bgPrimary,
              disabledForegroundColor: GamioTheme.textMuted,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: showDailyButton ? _claimDailyPoints : null,
            child: Text(
              showDailyButton
                  ? 'RECLAMAR RECOMPENSA DIARIA'
                  : 'SIGUIENTE EN: ${_formatDuration(_timeUntilNextClaim)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItemCard(Reward reward, bool isAlreadyBought) {
    Color itemColor;
    String prefix = '🎁';
    
    switch (reward.type) {
      case 'title':
        itemColor = GamioTheme.accentLight;
        prefix = '🏷️';
        break;
      case 'border':
        itemColor = GamioTheme.primary;
        prefix = '🖼️';
        break;
      case 'badge':
      default:
        itemColor = GamioTheme.warning;
        prefix = '💰';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GamioTheme.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAlreadyBought ? GamioTheme.borderLight : GamioTheme.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: itemColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: itemColor.withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: Text(prefix, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.description,
                      style: const TextStyle(
                        color: GamioTheme.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('💎 ', style: TextStyle(fontSize: 14)),
                  Text(
                    '${reward.cost}',
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: GamioTheme.primary,
                    ),
                  ),
                  const Text(' pts', style: TextStyle(fontSize: 12, color: GamioTheme.textMuted)),
                ],
              ),
              isAlreadyBought
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: GamioTheme.borderLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ADQUIRIDO',
                        style: TextStyle(
                          color: GamioTheme.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GamioTheme.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      onPressed: () => _buyReward(reward),
                      child: const Text('CANJEAR', style: TextStyle(fontSize: 11)),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
