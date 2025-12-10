import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';
import 'package:mis_lab_2/services/notification_service.dart';

import '../services/meal_service.dart';
import '../models/category.dart';
import 'package:mis_lab_2/widgets/category_card.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key, required this.name});
  final String name;

  @override
  State<HomePage> createState() => homePage();
}

class homePage extends State<HomePage>{
  late String randomMealId = "";
  List<Category>categories = [];
  List<Category>filteredCategories = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    loadCategories();
    searchController.addListener(filterCategories);
  }

  Future<void> loadCategories() async{
    try{
      final List<Category> loadCategories = await MealService.getCategories();
      setState(() {
        categories = loadCategories;
        filteredCategories = categories;
        isLoading = false;
      });
    }catch(e){
      print(e);
    }
  }

  void filterCategories() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCategories = categories;
      } else {
        filteredCategories = categories
            .where((category) =>
            category.name.toLowerCase().startsWith(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              List<String> arg = [];
              Navigator.pushNamed(context, "/favorites", arguments: arg);
              searchController.clear();
            },
            icon: const Icon(Icons.favorite),
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          TextButton(
            onPressed: () async {
              Navigator.pushNamed(context, "/meal", arguments: await MealService.getRandomMeal());
              searchController.clear();
              },
            child: Text("Random Meal!"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          )
        ],
      ),

      body : isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [

          //  -------- FOR TESTING LOCAL NOTIFICATIONS --------
          ElevatedButton(
              onPressed: () async {
                String mealId = await MealService.getRandomMeal();
                NotificationService.showNotification(payload: mealId);
                },
              child: const Text("TEST NOTIFICATIONS BUTTON")
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(

                hintText: "Search categories...",
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,),

                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),

          SizedBox(height: 8),

          // Categories list
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/category", arguments: filteredCategories[index].name);
                    searchController.clear();
                  },
                    child: categoryCard(category: filteredCategories[index])
                  );

                },
            ),
          )
        ],
      ),
    );
  }
}