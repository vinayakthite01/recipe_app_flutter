class Recipe {
  final String id;
  final String name;
  final String thumbnail;

  Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }
}