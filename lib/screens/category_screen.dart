import 'package:flutter/material.dart';

import '../models/meal.dart';
import 'package:mis_lab_2/widgets/meal_card.dart';

import '../services/meal_service.dart';

class CategoryPage extends StatefulWidget{
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => categoryPage();
}

class categoryPage extends State<CategoryPage>{
  var categoryName;
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];

  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    searchController.addListener(filterMeals);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    categoryName = ModalRoute.of(context)!.settings.arguments as String;
    loadDishes();
  }

  Future<void> loadDishes() async{
    try{
      final List<Meal> loadMeals = await MealService.getMealsForCategory(categoryName);
      setState(() {
        meals = loadMeals;
        filteredMeals = meals;
        isLoading = false;
      });
    }catch(e){
      print(e);
    }
  }

  void filterMeals() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredMeals = meals;
      } else {
        filteredMeals = meals
            .where((meal) =>
            meal.name.toLowerCase().startsWith(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title:  Text(
            isLoading ? "Loading category..." : categoryName,
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search meals...",
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,),

                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),

          SizedBox(height: 8),

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

                  itemCount: filteredMeals.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/meal", arguments: filteredMeals[index].id);
                          searchController.clear();
                        },
                        child: mealCard(meal : filteredMeals[index])
                    );
                  }
              ),
          )
        ],
      )
    );
  }
}