import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/recipe_detail.dart';
import 'package:recipe_app_flutter/services/api_service.dart';
import 'package:recipe_app_flutter/models/recipe_model.dart';


class Recipes extends StatelessWidget {
  final String category;
  final ApiService _apiService = ApiService();

  Recipes({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipes for $category")),
      body: FutureBuilder<List<Recipe>>(
        future: _apiService.fetchRecipesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No recipes available"));
          }

          final recipes = snapshot.data!;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Image.network(recipe.thumbnail, width: 50, height: 50),
                  title: Text(recipe.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(mealId: recipe.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}