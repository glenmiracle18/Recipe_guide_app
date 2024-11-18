import 'package:flutter/material.dart';
import '../models/recipe-details.dart';
import '../services/spoonacular_service.dart';
import '../models/recipe_step.dart';
import '../models/nutrition.dart';
import '../screens/nutrition_dashboard_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RecipeDetail>(
        future: SpoonacularService().getRecipeDetails(widget.recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No recipe data available'));
          }

          final recipe = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'recipe_${recipe.id}',
                    child: Image.network(
                      recipe.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      // TODO: Implement favorites functionality
                    },
                  ),
                ],
              ),

              // Recipe Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Tags
                      Text(
                        recipe.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildTags(recipe),
                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.analytics,
                              label: 'Nutrition',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeNutritionScreen(
                                      recipeId: widget.recipeId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.calendar_today,
                              label: 'Add to Meal Plan',
                              onPressed: () {
                                // TODO: Implement meal plan functionality
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.shopping_cart,
                              label: 'Add to Shopping List',
                              onPressed: () {
                                // TODO: Implement shopping list functionality
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nutritional Information
                      _buildNutritionalInfo(recipe.nutrition),
                      const SizedBox(height: 24),

                      // Ingredients
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildIngredientsList(recipe.ingredients),
                      const SizedBox(height: 24),

                      // Instructions
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInstructions(recipe.instructions
                          .map((step) => RecipeStep(
                                number: step.number,
                                step: step.step,
                              ))
                          .toList()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTags(RecipeDetail recipe) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (recipe.vegetarian) _buildTag('Vegetarian', Colors.green),
        if (recipe.vegan) _buildTag('Vegan', Colors.green),
        if (recipe.glutenFree) _buildTag('Gluten Free', Colors.orange),
        if (recipe.dairyFree) _buildTag('Dairy Free', Colors.blue),
        ...recipe.dishTypes.map((type) => _buildTag(type, Colors.purple)),
      ],
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.8),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: Colors.green),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo(Nutrition nutrition) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutritional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientInfo('Calories', nutrition.calories, 'kcal'),
                _buildNutrientInfo('Protein', nutrition.protein, 'g'),
                _buildNutrientInfo('Fat', nutrition.fat, 'g'),
                _buildNutrientInfo('Carbs', nutrition.carbs, 'g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, double value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(List<Ingredient> ingredients) {
    return Card(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ingredients.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            ),
            title: Text(ingredient.name),
            subtitle: Text('${ingredient.amount} ${ingredient.unit}'),
          );
        },
      ),
    );
  }

  Widget _buildInstructions(List<RecipeStep> steps) {
    return Card(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: steps.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final step = steps[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${step.number}'),
            ),
            title: Text(step.step),
          );
        },
      ),
    );
  }
}
