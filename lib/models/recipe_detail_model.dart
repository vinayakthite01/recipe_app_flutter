class RecipeDetail {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbnail;
  final List<String> ingredients;

  RecipeDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    List<String> extractIngredients(Map<String, dynamic> json) {
      List<String> ingredients = [];
      for (int i = 1; i <= 20; i++) {
        final ingredient = json['strIngredient$i'];
        final measure = json['strMeasure$i'];
        if (ingredient != null && ingredient.isNotEmpty) {
          ingredients.add('$ingredient - $measure');
        }
      }
      return ingredients;
    }

    return RecipeDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      ingredients: extractIngredients(json),
    );
  }
}