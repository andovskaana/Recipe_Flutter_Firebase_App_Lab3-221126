import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const String _baseUrl = 'www.themealdb.com';

  Future<List<Category>> fetchCategories() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/categories.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['categories'];
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Не можам да ги превземам категориите');
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/filter.php', {
      'c': category,
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['meals'] ?? [];
      return list.map((e) => Meal.fromFilterJson(e)).toList();
    } else {
      throw Exception('Не можам да ги превземам јадењата');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/search.php', {
      's': query,
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List? list = data['meals'];
      if (list == null) return [];
      return list.map((e) => Meal.fromDetailJson(e)).toList();
    } else {
      throw Exception('Не можам да пребарам јадења');
    }
  }

  Future<Meal> fetchMealDetail(String id) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/lookup.php', {
      'i': id,
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['meals'] as List;
      return Meal.fromDetailJson(list.first);
    } else {
      throw Exception('Не можам да го превземам рецептот');
    }
  }

  Future<Meal> fetchRandomMeal() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/random.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['meals'] as List;
      return Meal.fromDetailJson(list.first);
    } else {
      throw Exception('Не можам да превземам рандом рецепт');
    }
  }
}
