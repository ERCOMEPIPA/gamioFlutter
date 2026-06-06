class Game {
  final String name;
  final String genre;
  final String colorTheme;
  final String image;
  final int playersCount;

  Game({
    required this.name,
    required this.genre,
    required this.colorTheme,
    required this.image,
    required this.playersCount,
  });

  factory Game.fromJson(Map<String, dynamic> json, {int? realPlayersCount}) {
    return Game(
      name: json['name'] ?? '',
      genre: json['genre'] ?? 'Videojuego',
      colorTheme: json['color_theme'] ?? 'blue',
      image: json['image'] ?? 'https://images.igdb.com/igdb/image/upload/t_cover_big/co49wj.jpg',
      playersCount: realPlayersCount ?? json['players_count'] ?? 0,
    );
  }
}
