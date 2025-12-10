class Meal {
  String id;
  String name;
  String mealThumb;

  Meal({
    required this.id,
    required this.name,
    required this.mealThumb
  });

  Meal.fromJson(Map<String, dynamic> data):
        id = data['idMeal'],
        name = data['strMeal'],
        mealThumb = data['strMealThumb'];

  String printMealName(){
    String ans = name.length > 20
        ? '${name.substring(0, 20)}...'
        : name;

    return ans;
  }
}