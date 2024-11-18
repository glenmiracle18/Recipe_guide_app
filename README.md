# Recipe App

A Flutter application for discovering recipes, tracking nutrition, and meal planning using the Spoonacular API.

## Features

### Recipe Discovery
- Browse random recipes on home screen
- Search recipes by name
- Filter recipes by dietary preferences

### Recipe Details
- Detailed recipe information
- Step-by-step cooking instructions
- Ingredient lists with measurements
- Nutritional information breakdown

### Nutrition Dashboard
- Calorie tracking
- Macronutrient breakdown
- Vitamin and mineral content
- Daily dietary goals tracking
- Visual charts and progress indicators

### Additional Features
- Add recipes to favorites
- Create shopping lists from recipes
- Meal planning functionality

## Technical Stack

- **Framework**: Flutter
- **API**: Spoonacular Food API
- **Charts**: fl_chart
- **HTTP Client**: http package
- **State Management**: Provider/Riverpod (recommended)

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/yourusername/recipe_app.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API Key:
   - Sign up at [Spoonacular](https://spoonacular.com/food-api)
   - Get your API key
   - Add to `lib/services/spoonacular_service.dart`

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/
│   ├── recipe.dart
│   ├── recipe_detail.dart
│   ├── recipe_step.dart
│   ├── ingredient.dart
│   └── nutrition.dart
├── screens/
│   ├── home_screen.dart
│   ├── recipe_detail_screen.dart
│   └── recipe_nutrition_screen.dart
├── services/
│   └── spoonacular_service.dart
├── widgets/
│   └── recipe_card.dart
└── main.dart
```

## API Integration

The app uses following Spoonacular endpoints:

- `/recipes/random` - Get random recipes
- `/recipes/complexSearch` - Search recipes
- `/recipes/{id}/information` - Get recipe details
- `/recipes/{id}/nutritionWidget.json` - Get nutrition information

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  fl_chart: ^0.65.0
  provider: ^6.0.5
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
