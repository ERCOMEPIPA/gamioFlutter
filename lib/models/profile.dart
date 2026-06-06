class Profile {
  final String id;
  final String name;
  final String avatarUrl;
  final int points;
  final int xp;
  final int level;
  final List<String> favoriteGames;
  final String gameStyle;
  final String timeSlot;
  final List<String> claimedRewards;
  final String selectedTitle;
  final String selectedBorder;
  final bool isAdmin;
  final bool isBanned;
  final String? lastDailyClaim;

  Profile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.points,
    required this.xp,
    required this.level,
    required this.favoriteGames,
    required this.gameStyle,
    required this.timeSlot,
    required this.claimedRewards,
    required this.selectedTitle,
    required this.selectedBorder,
    required this.isAdmin,
    required this.isBanned,
    this.lastDailyClaim,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Gamer',
      avatarUrl: json['avatar_url'] ?? '',
      points: json['points'] ?? 0,
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 1,
      favoriteGames: List<String>.from(json['favorite_games'] ?? []),
      gameStyle: json['game_style'] ?? 'Casual',
      timeSlot: json['time_slot'] ?? 'Cualquiera',
      claimedRewards: List<String>.from(json['claimed_rewards'] ?? []),
      selectedTitle: json['selected_title'] ?? '',
      selectedBorder: json['selected_border'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      isBanned: json['is_banned'] ?? false,
      lastDailyClaim: json['last_daily_claim'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'points': points,
      'xp': xp,
      'level': level,
      'favorite_games': favoriteGames,
      'game_style': gameStyle,
      'time_slot': timeSlot,
      'claimed_rewards': claimedRewards,
      'selected_title': selectedTitle,
      'selected_border': selectedBorder,
      'is_admin': isAdmin,
      'is_banned': isBanned,
      'last_daily_claim': lastDailyClaim,
    };
  }
}
