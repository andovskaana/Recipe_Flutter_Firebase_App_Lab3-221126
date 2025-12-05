class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String? instructions;
  final List<Map<String, String>> ingredients;
  final String? youtube;
  final String? category;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.instructions,
    this.ingredients = const [],
    this.youtube,
    this.category,
  });

  factory Meal.fromFilterJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }

  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    final List<Map<String, String>> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add({
          'ingredient': ingredient,
          'measure': measure ?? '',
        });
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'],
      youtube: json['strYoutube'],
      ingredients: ingredients,
      category: json['strCategory'],
    );
  }
}
