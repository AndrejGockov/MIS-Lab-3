import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/meal_service.dart';
import '../services/favorite_meals_service.dart';
import 'package:mis_lab_2/models/meal_info.dart';

class MealPage extends StatefulWidget{
  const MealPage({super.key});

  @override
  State<MealPage> createState() => mealPage();
}

class mealPage extends State<MealPage>{
  late String mealId;
  late MealInfo meal;
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    mealId = ModalRoute.of(context)!.settings.arguments as String;
    loadMeal();
  }

  Future<void> loadMeal() async{
    try{
      final MealInfo loadMeals = await MealService.getMeal(mealId);
      isFavorite = await FavoriteMealsService.favoritesContains(loadMeals.id);
      setState(() {
        meal = loadMeals;
        isLoading = false;
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> launchYouTubeUrl(String url) async {
    print('url: ${url}');
    final String youtubeAppUrl = url.replaceFirst('https://', 'youtube://');

    try {
      if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
        await launchUrl(
          Uri.parse(youtubeAppUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      throw 'Couldn\'t open video';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          isLoading ? 'Loading meal...' : meal.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      meal.mealImage,
                      height: 350,
                      width: 350,
                    ),
                  ),

                  SizedBox(height: 8),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Instructions:",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    meal.instructions,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ingredients:",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),

                  Column(
                    children: List.generate(
                      meal.ingredients.length,
                          (index) => ListTile(
                            leading: Icon(Icons.circle, size: 6),
                            title: Text(
                              "${meal.ingredients[index]}, ${meal.measurements[index]}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  if(meal.youtubeLinkIsValid())
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => launchYouTubeUrl(meal.youtubeLink),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Watch on YouTube'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ])
        ),

      // Button for adding to favorite meals list
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          // Adds to favorite list
          setState(() {
            FavoriteMealsService.toggleFavorites(meal.id);
            isFavorite = !isFavorite;
          });
        },
        child: Icon(
          Icons.favorite,
          color: isFavorite ? Colors.red : Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}