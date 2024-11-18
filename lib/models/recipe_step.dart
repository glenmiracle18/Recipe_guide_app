class RecipeStep {
  final int number;
  final String step;

  RecipeStep({
    required this.number,
    required this.step,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      number: json['number'] ?? 0,
      step: json['step'] ?? '',
    );
  }
}
