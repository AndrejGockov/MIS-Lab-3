import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_info.dart';

class MealService{
  static Future<List<Category>> getCategories() async{
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if(response.statusCode != 200){
      throw Exception("Failed to load categories.");
    }

    final List data = jsonDecode(response.body)['categories'];

    return data.map((json) => Category.fromJson(json)).toList();
  }

  static Future<List<Meal>> getMealsForCategory(String categoryName) async{
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?c=" + categoryName));

    if(response.statusCode != 200){
      throw Exception("Failed to load meals.");
    }

    final List data = jsonDecode(response.body)['meals'];

    return data.map((json) => Meal.fromJson(json)).toList();
  }

  static Future<MealInfo> getMeal(String mealId) async{
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + mealId));

    if(response.statusCode != 200){
      throw Exception("Meal was not found or failed to load.");
    }

    final data = jsonDecode(response.body)['meals'][0];

    return MealInfo.fromJson(data);
  }

  static Future<String> getRandomMeal() async {
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php"));

    if(response.statusCode != 200){
      throw Exception("Meal was not found or failed to load.");
    }

    final data = jsonDecode(response.body)['meals'][0];
    return MealInfo.fromJson(data).id;
  }
}