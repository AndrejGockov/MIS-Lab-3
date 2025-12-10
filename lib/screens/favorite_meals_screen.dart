import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../models/meal_info.dart';
import '../services/meal_service.dart';
import '../services/favorite_meals_service.dart';
import '../widgets/meal_card.dart';

class FavoriteMealsPage extends StatefulWidget {
  const FavoriteMealsPage({super.key});

  @override
  State<FavoriteMealsPage> createState() => _FavoriteMealsPageState();
}

class _FavoriteMealsPageState extends State<FavoriteMealsPage> {
  var mealsList;
  List<MealInfo> meals = [];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    loadDishes();
  }

  Future<void> loadDishes() async{
    final List<String> loadMeals = await FavoriteMealsService.getFavorites();
    final List<MealInfo> favorites = [];

    for(String id in loadMeals) {
      favorites.add(await MealService.getMeal(id));
    }

    setState(() {
      meals = favorites;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title:  Text(
            isLoading ? "Loading Favorite Meals..." : "Favorite Meals",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ),

        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Meals grid
            Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4, // Spacing between items (rows in vertical scroll)
                      crossAxisSpacing: 4,// Spacing between columns (not applicable here)
                      childAspectRatio: 200/244 // Aspect ratio of each item (width/height)
                  ),

                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(onTap: () async {
                          await Navigator.pushNamed(
                              context, "/meal", arguments: meals[index].id
                          );
                          loadDishes();
                        },
                        child: mealCard(
                            meal : new Meal(id: meals[index].id, name: meals[index].name, mealThumb: meals[index].mealImage))
                    );
                  }
              ),
            )
          ],
        )
    );
  }
}
