class Recipe {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final int healthScore;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.healthScore,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      healthScore: json['healthScore'] ?? 0,
    );
  }
}
