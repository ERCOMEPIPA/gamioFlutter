import 'package:flutter/material.dart';
import '../../models/game.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/game_card.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final _searchController = TextEditingController();
  List<Game> _allGames = [];
  List<Game> _filteredGames = [];
  bool _isLoading = true;
  String _activeCategory = 'Todos';

  final List<String> _categories = [
    'Todos',
    'FPS',
    'MOBA',
    'Battle Royale',
    'Deportes',
    'Sandbox',
  ];

  final List<Map<String, String>> _staticGames = [
    {
      'name': 'League of Legends',
      'genre': 'MOBA',
      'color_theme': 'violet',
      'image': 'https://images.igdb.com/igdb/image/upload/t_cover_big/co49wj.jpg'
    },
    {
      'name': 'Valorant',
      'genre': 'FPS',
      'color_theme': 'blue',
      'image': 'https://images.igdb.com/igdb/image/upload/t_cover_big/co2mvt.jpg'
    },
    {
      'name': 'EA FC 25',
      'genre': 'Deportes',
      'color_theme': 'green',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/2669320/library_600x900.jpg'
    },
    {
      'name': 'Dead By Daylight',
      'genre': 'Sandbox',
      'color_theme': 'violet',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/381210/library_600x900.jpg'
    },
    {
      'name': 'Call of Duty: Warzone',
      'genre': 'Battle Royale',
      'color_theme': 'orange',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/1962663/library_600x900.jpg'
    },
    {
      'name': 'Rocket League',
      'genre': 'Deportes',
      'color_theme': 'blue',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/252950/library_600x900.jpg'
    },
    {
      'name': 'Fortnite',
      'genre': 'Battle Royale',
      'color_theme': 'violet',
      'image': 'https://upload.wikimedia.org/wikipedia/en/a/ae/Fortnite_Save_The_World.jpg'
    },
    {
      'name': 'Apex Legends',
      'genre': 'Battle Royale',
      'color_theme': 'orange',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/1172470/library_600x900.jpg'
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadGamesData();
    _searchController.addListener(_filterGames);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGamesData() async {
    try {
      final dbGames = await SupabaseService().fetchGames();
      final profiles = await SupabaseService().fetchAllProfiles();

      // Calcular número real de jugadores contando favoritos en tiempo real
      final gameCounts = <String, int>{};
      for (var p in profiles) {
        final favs = p['favorite_games'] as List?;
        if (favs != null) {
          for (var gameName in favs) {
            var key = gameName.toString().toLowerCase().trim();
            if (key == 'call of duty') key = 'call of duty: warzone';
            if (key == 'ea fc 24') key = 'ea fc 25';
            gameCounts[key] = (gameCounts[key] ?? 0) + 1;
          }
        }
      }

      final merged = <Game>[];

      // Fusionar catálogo estático y base de datos
      for (var staticG in _staticGames) {
        final name = staticG['name']!;
        final dbG = dbGames.firstWhere((g) => g['name'] == name, orElse: () => {});
        final realCount = gameCounts[name.toLowerCase()] ?? 0;
        
        merged.add(Game(
          name: name,
          genre: staticG['genre']!,
          colorTheme: staticG['color_theme']!,
          image: staticG['image']!,
          playersCount: realCount,
        ));
      }

      // Añadir juegos de la BD que no estuviesen en estáticos
      for (var dbG in dbGames) {
        final name = dbG['name'] ?? '';
        if (!merged.any((g) => g.name == name)) {
          final realCount = gameCounts[name.toLowerCase()] ?? 0;
          merged.add(Game(
            name: name,
            genre: dbG['genre'] ?? 'Videojuego',
            colorTheme: dbG['color_theme'] ?? 'blue',
            image: dbG['image'] ?? 'https://images.igdb.com/igdb/image/upload/t_cover_big/co49wj.jpg',
            playersCount: realCount,
          ));
        }
      }

      // Ordenar por el conteo real
      merged.sort((a, b) => b.playersCount.compareTo(a.playersCount));

      setState(() {
        _allGames = merged;
        _filteredGames = merged;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _filterGames() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredGames = _allGames.where((game) {
        final matchesSearch = game.name.toLowerCase().contains(query);
        final matchesCategory = _activeCategory == 'Todos' ||
            game.genre.toLowerCase().contains(_activeCategory.toLowerCase());
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _setCategory(String category) {
    setState(() {
      _activeCategory = category;
    });
    _filterGames();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
        : Column(
            children: [
              // Search input bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar juego...',
                    prefixIcon: const Icon(Icons.search, color: GamioTheme.textMuted),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: GamioTheme.textMuted),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              // Category chips list
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final active = _activeCategory == cat;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            color: active ? Colors.white : GamioTheme.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        selected: active,
                        onSelected: (_) => _setCategory(cat),
                        selectedColor: GamioTheme.primary.withOpacity(0.3),
                        backgroundColor: GamioTheme.surfaceCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: active ? GamioTheme.primary : GamioTheme.borderColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Games Grid
              Expanded(
                child: _filteredGames.isEmpty
                    ? Center(
                        child: Text(
                          'No se han encontrado juegos.',
                          style: TextStyle(color: GamioTheme.textMuted),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredGames.length,
                        itemBuilder: (context, index) {
                          final game = _filteredGames[index];
                          return GameCard(
                            game: game,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/matchmaking',
                                arguments: game.name,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
  }
}
