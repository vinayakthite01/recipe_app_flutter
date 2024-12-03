import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/categories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Categories',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: CategoriesScreen(),
    );
  }
}
