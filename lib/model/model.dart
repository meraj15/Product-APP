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
  int stock;
  String availabilityStatus;
  List<String> images;
  String returnPolicy;
  int productQuantity = 1;
  String warrantyInformation;

  Product({
    required this.category,
    required this.description,
    required this.id,
    required this.thumbnail,
    required this.price,
    required this.title,
    required this.brand,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.availabilityStatus,
    required this.images,
    required this.returnPolicy,
    required this.warrantyInformation,
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
      stock: product["stock"] ?? 0,
      availabilityStatus: product["availabilityStatus"] ?? "",
      images: product["images"].cast<String>(),
      returnPolicy: product["returnPolicy"],
      warrantyInformation: product["warrantyInformation"],
    );
  }
}
