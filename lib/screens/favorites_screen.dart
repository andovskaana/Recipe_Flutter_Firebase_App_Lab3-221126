import 'package:flutter/material.dart';

import '../services/favorites_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени рецепти'),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text('Немате уште додадено омилени рецепти.'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final meal = favorites[index];
          return MealGridItem(
            meal: meal,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      MealDetailScreen(mealId: meal.id, meal: meal),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
