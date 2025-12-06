import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meal.dart';
import '../services/api_service.dart';

class FavoritesService {
  static final List<Meal> _favorites = [];
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static final _apiService = ApiService();

  static List<Meal> get favorites => List.unmodifiable(_favorites);

  static String? get _uid => _auth.currentUser?.uid;
/// Favorites ids from firestore, details from api
  static Future<void> loadFavoritesForCurrentUser() async {
    if (_uid == null) return;

    _favorites.clear();

    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .get();

    for (final doc in snapshot.docs) {
      final mealId = doc.id;
      try {
        final meal = await _apiService.fetchMealDetail(mealId);
        _favorites.add(meal);
      } catch (_) {
      }
    }
  }

  static bool isFavorite(Meal meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  /// Toggle favorite:  Firestore samo ID-то
  static Future<void> toggleFavorite(Meal meal) async {
    if (_uid == null) return;

    final favRef = _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(meal.id);

    final exists = await favRef.get();

    if (exists.exists) {
      await favRef.delete();
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      await favRef.set({});
      _favorites.add(meal);
    }
  }
}
