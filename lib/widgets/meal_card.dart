import 'package:flutter/material.dart';
import 'package:mis_lab_2/models/meal.dart';

class mealCard extends StatelessWidget{
  final Meal meal;

  const mealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.secondary,
        child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      meal.mealThumb,
                      fit: BoxFit.contain,
                      height: 180,
                      width: 180,
                    ),
                  )
              ),

              SizedBox(height: 8),

              Text(
                meal.printMealName(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ]
        )
    );
  }

}