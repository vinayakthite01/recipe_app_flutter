import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/services/api_service.dart';
import 'package:recipe_app_flutter/screens/recipes.dart';
import 'package:flutter/material.dart';

import '../delegates.dart';
import '../models/category_model.dart';
import '../models/recipe_model.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _apiService = ApiService();
  TextEditingController _searchController = TextEditingController();
  List<Category> _categories = [];
  List<Recipe> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final categories = await _apiService.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }
/*
  void _searchRecipes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    } else {
      final searchResults = await _apiService.searchRecipes(query);
      setState(() {
        _searchResults = searchResults;
        _isSearching = true;
      });
    }
  }
 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: RecipeSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: _isSearching
          ? _buildSearchResults()
          : _buildCategoriesList(),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final recipe = _searchResults[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(recipe.thumbnail, width: 50, height: 50),
            title: Text(recipe.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recipes(category: recipe.name),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(category.image, width: 50, height: 50),
            title: Text(category.name),
            subtitle: Text(category.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recipes(category: category.name),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
