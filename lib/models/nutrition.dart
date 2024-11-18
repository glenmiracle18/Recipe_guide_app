// lib/models/nutrition.dart
class Nutrition {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final List<Nutrient> nutrients;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.nutrients,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    List<Nutrient> nutrientsList = [];

    if (json['nutrients'] != null) {
      nutrientsList = (json['nutrients'] as List)
          .map((nutrient) => Nutrient.fromJson(nutrient))
          .toList();
    }

    // Find specific nutrients
    double findNutrientAmount(String name) {
      final nutrient = nutrientsList.firstWhere(
        (n) => n.name == name,
        orElse: () => Nutrient(
          name: name,
          amount: 0,
          unit: 'g',
          percentOfDaily: 0,
        ),
      );
      return nutrient.amount;
    }

    return Nutrition(
      calories: findNutrientAmount('Calories'),
      protein: findNutrientAmount('Protein'),
      fat: findNutrientAmount('Fat'),
      carbs: findNutrientAmount('Carbohydrates'),
      nutrients: nutrientsList,
    );
  }
}

class Nutrient {
  final String name;
  final double amount;
  final String unit;
  final double percentOfDaily;

  Nutrient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.percentOfDaily,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      percentOfDaily: (json['percentOfDailyNeeds'] ?? 0).toDouble(),
    );
  }
}
