class Reward {
  final String id;
  final String title;
  final String description;
  final int cost;
  final String type; // 'title', 'border', 'badge' (game coins)
  final String value;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.type,
    required this.value,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      cost: json['cost'] ?? 0,
      type: json['type'] ?? 'title',
      value: json['value'] ?? '',
    );
  }
}
