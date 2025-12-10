import 'package:flutter/material.dart';
import 'package:mis_lab_2/models/category.dart';

class categoryCard extends StatelessWidget{
  final Category category;

  const categoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8),
        color: Theme.of(context).colorScheme.secondary,
        child : Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    category.categoryThumb,
                    fit: BoxFit.contain,
                    height: 160,
                    width: 160,
                  ),
                )
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    category.printCategoryDesc(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}