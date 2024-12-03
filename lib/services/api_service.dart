import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app_flutter/models/category_model.dart';
import 'package:recipe_app_flutter/models/recipe_model.dart';
import 'package:recipe_app_flutter/models/recipe_detail_model.dart';

class ApiService {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse("$_baseUrl/categories.php"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> categories = data['categories'];
      return categories.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    final response = await http.get(Uri.parse("$_baseUrl/filter.php?c=$category"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> recipes = data['meals'];
      return recipes.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load recipes for category: $category");
    }
  }

  Future<RecipeDetail> fetchRecipeDetails(String mealId) async {
    final response = await http.get(Uri.parse("$_baseUrl/lookup.php?i=$mealId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RecipeDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception("Failed to load recipe details");
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search.php?s=$query"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['meals'] != null) {
        final List<dynamic> recipes = data['meals'];
        return recipes.map((json) => Recipe.fromJson(json)).toList();
      } else {
        return []; // Return empty list if no results found
      }
    } else {
      throw Exception("Failed to search recipes");
    }
  }
}