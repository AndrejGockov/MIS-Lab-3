class MealInfo{
  String id;
  String name;
  String youtubeLink;
  String mealImage;
  String instructions;
  List<String> ingredients;
  List<String> measurements;
  bool isFavorite;

  MealInfo({
    required this.id,
    required this.name,
    required this.youtubeLink,
    required this.mealImage,
    required this.instructions,
    required this.ingredients,
    required this.measurements,
    this.isFavorite = false
  });

  MealInfo.fromJson(Map<String, dynamic> data):
        id = data['idMeal'] ?? 'Invalid ID',
        name = data['strMeal'] ?? 'Unknown Meal',
        youtubeLink = data['strYoutube'],
        mealImage = data['strMealThumb'],
        instructions = data['strInstructions'],
        ingredients = getIngredients(data),
        measurements = getMeasurements(data),
        this.isFavorite = false;

  static List<String> getIngredients(Map<String, dynamic> json) {
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json["strIngredient$i"];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient);
      }
    }

    return ingredients;
  }

  static List<String> getMeasurements(Map<String, dynamic> json) {
    List<String> measurements = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json["strMeasure$i"];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        measurements.add(ingredient);
      }
    }

    return measurements;
  }

  bool youtubeLinkIsValid(){
    return youtubeLink != null && !youtubeLink.isEmpty;
  }
}