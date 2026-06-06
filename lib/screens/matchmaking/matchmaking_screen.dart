import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/neon_border.dart';

class MatchmakingScreen extends StatefulWidget {
  final String? initialGameFilter;

  const MatchmakingScreen({
    Key? key,
    this.initialGameFilter,
  }) : super(key: key);

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  // Filters state
  String _selectedGame = 'Todos';
  String _selectedStyle = 'Todos';
  String _selectedTime = 'Todos';

  final List<String> _games = [
    'Todos',
    'League of Legends',
    'Valorant',
    'EA FC 25',
    'Dead By Daylight',
    'Call of Duty: Warzone',
    'Rocket League',
    'Fortnite',
    'Apex Legends',
  ];

  final List<String> _styles = [
    'Todos',
    'Competitivo 🔥 (Tryhard)',
    'Casual 🎮 (Relax)',
    'Cooperativo 🛡️ (Team player)',
    'Trollete 👾 (Fun & memes)',
  ];

  final List<String> _times = [
    'Todos',
    'Mañanas 🌅 (09:00 - 14:00)',
    'Tardes 🌇 (14:00 - 20:00)',
    'Noches 🌌 (20:00 - 02:00)',
    'Madrugadas 🧛 (02:00 - 08:00)',
    'Todo el día ⚡ (Flexibilidad)',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialGameFilter != null) {
      _selectedGame = widget.initialGameFilter!;
    }
    _loadProfiles();
    _searchController.addListener(_loadProfiles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    try {
      final list = await SupabaseService().fetchMatchmakingProfiles(
        game: _selectedGame,
        style: _selectedStyle,
        timeSlot: _selectedTime,
        search: _searchController.text,
      );
      setState(() {
        _profiles = list;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendFriendRequest(String targetId, String targetName) async {
    try {
      await SupabaseService().sendFriendRequest(targetId);
      CustomAlert.show(
        context: context,
        title: 'Solicitud Enviada',
        message: '¡Enhorabuena! Le hemos enviado tu solicitud de amistad a $targetName.',
        type: AlertType.success,
        iconText: '👥',
      );
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Error de Envío',
        message: 'Ya existe una solicitud de amistad pendiente o establecida entre vosotros.',
        type: AlertType.error,
        iconText: '❌',
      );
    }
  }

  Future<void> _startChat(String targetId) async {
    try {
      final convId = await SupabaseService().startConversation(targetId);
      Navigator.of(context).pushNamed('/chat_private', arguments: convId);
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Error de Chat',
        message: e.toString(),
        type: AlertType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: const Text(
          'BUSCADOR LFG',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter card
          _buildFiltersPanel(),
          // Profile list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
                : _profiles.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay jugadores compatibles en este momento.',
                          style: TextStyle(color: GamioTheme.textMuted),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _profiles.length,
                        itemBuilder: (context, index) {
                          final p = _profiles[index];
                          return _buildProfileCard(p);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ExpansionTile(
        title: Row(
          children: [
            const Icon(Icons.tune, color: GamioTheme.primary, size: 20),
            const SizedBox(width: 10),
            const Text(
              'FILTRAR JUGADORES',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar por nombre...',
              prefixIcon: Icon(Icons.search, size: 20),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 12),
          // Game dropdown
          _buildDropdown('Videojuego', _selectedGame, _games, (v) {
            setState(() => _selectedGame = v!);
            _loadProfiles();
          }),
          const SizedBox(height: 8),
          // Style dropdown
          _buildDropdown('Actitud de juego', _selectedStyle, _styles, (v) {
            setState(() => _selectedStyle = v!);
            _loadProfiles();
          }),
          const SizedBox(height: 8),
          // Time dropdown
          _buildDropdown('Franja Horaria', _selectedTime, _times, (v) {
            setState(() => _selectedTime = v!);
            _loadProfiles();
          }),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String currentValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: GamioTheme.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: GamioTheme.bgPrimary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: GamioTheme.borderColor),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: GamioTheme.bgSecondary,
            onChanged: onChanged,
            items: items.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> p) {
    final name = p['name'] ?? 'Usuario';
    final avatar = p['avatar_url'] ?? '';
    final border = p['selected_border'] ?? '';
    final title = p['selected_title'] ?? '';
    final level = p['level'] ?? 1;
    final xp = p['xp'] ?? 0;
    final gameStyle = p['game_style'] ?? 'Casual';
    final timeSlot = p['time_slot'] ?? 'Tardes';
    final favGames = List<String>.from(p['favorite_games'] ?? []);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeonBorder(
                  borderType: border,
                  radius: 24,
                  child: avatar.isNotEmpty
                      ? Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                          errorBuilder: (c, e, s) => _defaultAvatar(name),
                        )
                      : _defaultAvatar(name),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Level badge indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: GamioTheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: GamioTheme.primary),
                            ),
                            child: Text(
                              'NIVEL $level',
                              style: const TextStyle(
                                color: GamioTheme.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (title.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: GamioTheme.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: GamioTheme.accent.withOpacity(0.3)),
                          ),
                          child: Text(
                            GamioTheme.translateTitle(title),
                            style: const TextStyle(
                              color: GamioTheme.accentLight,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // XP bar
            Row(
              children: [
                const Text(
                  'XP ',
                  style: TextStyle(
                    color: GamioTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (xp % 100) / 100,
                      backgroundColor: GamioTheme.bgPrimary,
                      valueColor: const AlwaysStoppedAnimation<Color>(GamioTheme.primary),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${xp % 100}/100',
                  style: const TextStyle(
                    color: GamioTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tags style and times
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GamioTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: GamioTheme.secondary.withOpacity(0.3)),
                  ),
                  child: Text(
                    gameStyle,
                    style: const TextStyle(
                      color: GamioTheme.secondaryLight,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GamioTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: GamioTheme.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    timeSlot,
                    style: const TextStyle(
                      color: GamioTheme.primaryLight,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (favGames.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'JUEGOS FAVORITOS:',
                style: TextStyle(
                  color: GamioTheme.textMuted,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: favGames.map((g) => Chip(
                  label: Text(g, style: const TextStyle(fontSize: 9, color: Colors.white)),
                  backgroundColor: GamioTheme.bgTertiary,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ],
            const SizedBox(height: 14),
            const Divider(color: GamioTheme.borderColor),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.forum_outlined, color: GamioTheme.primary),
                  tooltip: 'Chat Directo',
                  onPressed: () => _startChat(p['id']),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    backgroundColor: GamioTheme.secondary,
                  ),
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 16),
                  label: const Text('Agregar Amigo', style: TextStyle(fontSize: 12)),
                  onPressed: () => _sendFriendRequest(p['id'], name),
                ),
              ],
            ),
          ],
        ),
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
          fontSize: 20,
        ),
      ),
    );
  }
}
