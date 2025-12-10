import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMealsService{
  static String key = "favorites";

  // Adds or removes a meal from the users favorite meals
  static Future<void> toggleFavorites(String id) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final favoritesList = preferences.getStringList(key) ?? [];

    if(!favoritesList.contains(id)){
      favoritesList.add(id);
    } else {
      favoritesList.remove(id);
    }

    await preferences.setStringList(key, favoritesList);
    print(favoritesList);
  }

  static Future<List<String>> getFavorites() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key) ?? [];
  }

  static Future<bool> favoritesContains(String id) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final favoritesList = preferences.getStringList(key) ?? [];
    return favoritesList.contains(id);
  }
}