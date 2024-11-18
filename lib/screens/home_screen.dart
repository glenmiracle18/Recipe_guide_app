import 'package:flutter/material.dart';
import 'package:nutrition_app/screens/recipe_details_screen.dart';
import '../models/recipe.dart';
import '../services/spoonacular_service.dart';
import '../widgets/recipe_card.dart';
import '../screens/nutrition_dashboard_screen.dart';
import '../models/nutrition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpoonacularService _spoonacularService = SpoonacularService();
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;
  int _selectedIndex = 0; // Track selected bottom nav item

  @override
  void initState() {
    super.initState();
    _loadRandomRecipes(); // This will load random recipes when the screen first opens
  }

  Future<void> _searchRecipes(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _isSearching = true;
    });

    try {
      final recipes = await _spoonacularService.searchRecipes(query);
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRandomRecipes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final recipes = await _spoonacularService.getRandomRecipes();
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // You can add navigation logic here
    switch (index) {
      case 0: // Home
        _loadRandomRecipes();
        break;
      case 1: // Favorites
        // Navigate to favorites or show favorites content
        break;
      case 2: // Meal Plan
        // Navigate to meal plan or show meal plan content
        break;
      case 3: // Dashboard
      // Navigate to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadRandomRecipes(); // Load random recipes when search is cleared
                  },
                ),
              ),
              onSubmitted: _searchRecipes,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!),
                            ElevatedButton(
                              onPressed: _loadRandomRecipes,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _recipes[index];
                          return RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailScreen(recipeId: recipe.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Meal Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed, // Required for 4+ items
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
