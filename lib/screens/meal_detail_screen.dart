import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final Meal? meal;

  const MealDetailScreen({
    Key? key,
    required this.mealId,
    this.meal,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService _apiService = ApiService();
  Meal? _meal;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.meal != null && widget.meal!.instructions != null) {
      _meal = widget.meal;
      _loading = false;
    } else {
      _loadDetail();
    }
  }

  Future<void> _loadDetail() async {
    try {
      final meal = await _apiService.fetchMealDetail(widget.mealId);
      setState(() {
        _meal = meal;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }
  Future<void> _openYoutube() async {
    if (_meal?.youtube == null ||
        _meal!.youtube!.trim().isEmpty) return;

    final uri = Uri.parse(_meal!.youtube!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не можам да го отворам линкот')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = _meal;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal?.name ?? 'Рецепт'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : meal == null
          ? const Center(child: Text('Нема податоци за рецептот'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meal.thumbnail,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (meal.category != null) ...[
              const SizedBox(height: 4),
              Text(
                'Категорија: ${meal.category}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Состојки:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...meal.ingredients.map((ing) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${ing['ingredient']} - ${ing['measure']}',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            const Text(
              'Инструкции:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              meal.instructions ?? 'Нема инструкции.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              meal.instructions ?? 'Нема инструкции.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            if (meal.youtube != null &&
                meal.youtube!.trim().isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _openYoutube,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Погледни на YouTube'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
