import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart'; // Import the Recipe class
import '../models/recipe-details.dart';
import '../models/nutrition.dart';

class SpoonacularService {
  final String apiKey =
      '1000c9f4eae3458a9aaeb33bbdcaeac1'; // Replace with your API key
  final String baseUrl = 'https://api.spoonacular.com/recipes';

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/complexSearch?apiKey=$apiKey&query=$query&addRecipeInformation=true&number=10'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> getRandomRecipes({int number = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/random?apiKey=$apiKey&number=$number&addRecipeInformation=true'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['recipes'] as List)
            .map((json) => Recipe.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load random recipes');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Nutrition> getRecipeNutrition(int recipeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$recipeId/nutritionWidget.json?apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        return Nutrition.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load recipe nutrition');
      }
    } catch (e) {
      throw Exception('Error fetching nutrition data: $e');
    }
  }

  Future<RecipeDetail> getRecipeDetails(int id) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/$id/information?apiKey=$apiKey&includeNutrition=true'),
    );

    if (response.statusCode == 200) {
      return RecipeDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
