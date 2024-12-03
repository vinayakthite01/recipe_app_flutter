import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/recipe_detail.dart';
import 'package:recipe_app_flutter/services/api_service.dart';

import 'models/recipe_model.dart';

class RecipeSearchDelegate extends SearchDelegate {
  final ApiService _apiService = ApiService();

  @override
  String get searchFieldLabel => 'Search for recipes';

  List<Recipe> _searchResults = [];
  bool _isLoading = false;

  @override
  Widget buildResults(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_searchResults.isEmpty) {
      print("No recipes found. Try another search term.");
      return const Center(
        child: Text('Press enter to search for your query'),
      );
    } else {
      print("Recipe Name is needed:");
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final recipe = _searchResults[index];
          print("Recipe Name:");
          print(recipe.name);
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
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(
        child: Text('Enter a recipe name to search'),
      );
    } else {
      return const Center(
        child: Text('Press enter to search for your query'),
      );
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          _searchResults = [];
          _isLoading = false;
          showSuggestions(context); // Rebuild the UI to show suggestions
        },
      ),
    ];
  }

  @override
  void showResults(BuildContext context) async {
    if (query.trim().isEmpty) return;

    // Set loading state and clear previous results
    _isLoading = true;
    _searchResults = [];
    // Trigger UI rebuild to show the loading spinner

    try {
      final results = await _apiService.searchRecipes(query.trim());
      _searchResults = results;
    } catch (e) {
      print('Error fetching search results: $e');
      _searchResults = [];
    } finally {
      _isLoading = false;
      // Trigger the UI update  after data is fetched
    }
  }
}
