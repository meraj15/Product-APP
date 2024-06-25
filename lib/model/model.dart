class Product {
  int id;
  String title;
  String description;
  String category;
  num price;
  String thumbnail;
  String brand;
  num discountPercentage;
  num rating;

  Product({
    required this.category,
    required this.description,
    required this.id,
    required this.thumbnail,
    required this.price,
    required this.title,
    required this.brand,
    required this.discountPercentage,
    required this.rating
  });

  factory Product.fromJson(Map product) {
    return Product(
      category: product["category"] ?? "",
      description: product["description"] ?? "",
      id: product['id'] ?? 0,
      thumbnail: product['thumbnail'] ?? "",
      price: product["price"] ?? 0,
      title: product["title"] ?? "",
      brand: product["brand"] ?? "Gloceries",
      discountPercentage: product["discountPercentage"] ?? 0,
      rating: product["rating"] ?? 0,
    );
  }
}
