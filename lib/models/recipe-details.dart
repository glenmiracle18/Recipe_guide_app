import 'nutrition.dart';

class RecipeDetail {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final int healthScore;
  final List<String> dishTypes;
  final List<Ingredient> ingredients;
  final List<Step> instructions;
  final Nutrition nutrition;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;

  RecipeDetail({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.healthScore,
    required this.dishTypes,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      healthScore: json['healthScore'] ?? 0,
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      ingredients: (json['extendedIngredients'] as List? ?? [])
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      instructions: (json['analyzedInstructions'] as List? ?? [])
          .expand((instruction) => (instruction['steps'] as List? ?? [])
              .map((step) => Step.fromJson(step)))
          .toList(),
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      vegetarian: json['vegetarian'] ?? false,
      vegan: json['vegan'] ?? false,
      glutenFree: json['glutenFree'] ?? false,
      dairyFree: json['dairyFree'] ?? false,
    );
  }
}

class Ingredient {
  final String name;
  final double amount;
  final String unit;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}

class Step {
  final int number;
  final String step;

  Step({
    required this.number,
    required this.step,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      number: json['number'] ?? 0,
      step: json['step'] ?? '',
    );
  }
}
