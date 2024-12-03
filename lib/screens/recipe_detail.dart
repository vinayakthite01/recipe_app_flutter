import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/services/api_service.dart';
import 'package:recipe_app_flutter/models/recipe_detail_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String mealId;
  final ApiService _apiService = ApiService();

  RecipeDetailScreen({required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Details")),
      body: FutureBuilder<RecipeDetail>(
        future: _apiService.fetchRecipeDetails(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No details available"));
          }

          final recipe = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(recipe.thumbnail, width: double.infinity, height: 250, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text("Category: ${recipe.category}", style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Text("Ingredients", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.map((ingredient) => Text("• $ingredient")),
                      const SizedBox(height: 16),
                      Text("Instructions", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(recipe.instructions),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}