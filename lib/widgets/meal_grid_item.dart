import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/favorites_service.dart';

class MealGridItem extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealGridItem({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  State<MealGridItem> createState() => _MealGridItemState();
}

class _MealGridItemState extends State<MealGridItem> {
  bool _isProcessing = false;

  Future<void> _toggleFavorite() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    await FavoritesService.toggleFavorite(widget.meal);

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFav = FavoritesService.isFavorite(widget.meal);

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                child: Image.network(
                  widget.meal.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isProcessing ? null : _toggleFavorite,
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
