class Product {
  bool productFound;
  String barcode;
  String name;
  String image;
  String ingredients;
  String quantity;
  String nutritionImage;
  String ingredientsImage;
  String origins;
  String manufacturingPlaces;

  Product({
    this.productFound = false,
    this.barcode = "",
    this.name = "",
    this.image = "",
    this.ingredients = "",
    this.quantity = "",
    this.nutritionImage = "",
    this.ingredientsImage = "",
    this.origins = "",
    this.manufacturingPlaces = "",
  });

  // Add equality checks for product comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          barcode == other.barcode;

  @override
  int get hashCode => barcode.hashCode;

  // Add a named constructor for JSON deserialization
  Product.fromJson(Map<dynamic, dynamic> json)
      : productFound = json['status'] == 0 ? false : true,
        barcode = json['code'] ?? "",
        name = json['product']['product_name'] ?? "",
        ingredients = json['product']['ingredients_text'] ?? "",
        quantity = json['product']['quantity'] ?? "",
        image = json['product']['image_url'] ?? "",
        manufacturingPlaces = json['product']['manufacturing_places'] ?? "",
        nutritionImage = json['product']['image_nutrition_url'] ?? "",
        ingredientsImage = json['product']['image_ingredients_url'] ?? "",
        origins = json['product']['origins'] ?? "";

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productFound: map['productFound'] == 1,
      barcode: map['barcode'],
      name: map['name'],
      image: map['image'],
      ingredients: map['ingredients'],
      quantity: map['quantity'],
      nutritionImage: map['nutritionImage'],
      ingredientsImage: map['ingredientsImage'],
      origins: map['origins'],
      manufacturingPlaces: map['manufacturingPlaces'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productFound': productFound ? 1 : 0,
      'barcode': barcode,
      'name': name,
      'image': image,
      'ingredients': ingredients,
      'quantity': quantity,
      'nutritionImage': nutritionImage,
      'ingredientsImage': ingredientsImage,
      'origins': origins,
      'manufacturingPlaces': manufacturingPlaces,
    };
  }

  @override
  String toString() {
    return "$name\n$barcode";
  }
}
