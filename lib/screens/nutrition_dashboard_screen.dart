import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/recipe-details.dart';
import '../models/nutrition.dart';
import '../services/spoonacular_service.dart';

class RecipeNutritionScreen extends StatefulWidget {
  final int recipeId;

  const RecipeNutritionScreen({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  _RecipeNutritionScreenState createState() => _RecipeNutritionScreenState();
}

class _RecipeNutritionScreenState extends State<RecipeNutritionScreen> {
  final SpoonacularService _spoonacularService = SpoonacularService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Facts'),
        elevation: 0,
      ),
      body: FutureBuilder<Nutrition>(
        future: _spoonacularService.getRecipeNutrition(widget.recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Retry loading
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No nutrition data available'));
          }

          final nutrition = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Quick Facts Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickFact(
                        'Calories',
                        nutrition.calories.round().toString(),
                        Icons.local_fire_department,
                        Colors.orange,
                      ),
                      _buildQuickFact(
                        'Protein',
                        '${nutrition.protein.round()}g',
                        Icons.fitness_center,
                        Colors.red,
                      ),
                      _buildQuickFact(
                        'Carbs',
                        '${nutrition.carbs.round()}g',
                        Icons.grain,
                        Colors.green,
                      ),
                      _buildQuickFact(
                        'Fat',
                        '${nutrition.fat.round()}g',
                        Icons.circle,
                        Colors.blue,
                      ),
                    ],
                  ),
                ),

                // Macronutrient Chart
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: PieChart(
                    PieChartData(
                      sections: _createPieChartSections(nutrition),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),

                // Detailed Nutrients List
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detailed Nutrition Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...nutrition.nutrients
                          .where((nutrient) => nutrient.percentOfDaily > 0)
                          .map((nutrient) => _buildNutrientRow(nutrient)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickFact(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(Nutrition nutrition) {
    final total = nutrition.protein + nutrition.fat + nutrition.carbs;

    return [
      PieChartSectionData(
        value: nutrition.protein,
        title: '${(nutrition.protein / total * 100).round()}%',
        color: Colors.red,
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: nutrition.fat,
        title: '${(nutrition.fat / total * 100).round()}%',
        color: Colors.blue,
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: nutrition.carbs,
        title: '${(nutrition.carbs / total * 100).round()}%',
        color: Colors.green,
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  Widget _buildNutrientRow(Nutrient nutrient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nutrient.name),
              Text(
                '${nutrient.amount.toStringAsFixed(1)}${nutrient.unit}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: nutrient.percentOfDaily / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(nutrient.percentOfDaily),
            ),
          ),
          Text(
            '${nutrient.percentOfDaily.round()}% of daily needs',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 30) return Colors.red;
    if (percentage < 70) return Colors.orange;
    return Colors.green;
  }
}
