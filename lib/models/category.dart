class Category{
  String id;
  String name;
  String categoryThumb;
  String categoryDescription;

  Category({
    required this.id,
    required this.name,
    required this.categoryThumb,
    required this.categoryDescription
  });

  Category.fromJson(Map<String, dynamic> data):
        id = data['idCategory'],
        name = data['strCategory'],
        categoryThumb = data['strCategoryThumb'],
        categoryDescription = data['strCategoryDescription'];

  String printCategoryDesc(){
    String ans = categoryDescription.length > 50
        ? '${categoryDescription.substring(0, 50)}...'
        : categoryDescription;

    return ans;
  }
}