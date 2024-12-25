// ignore_for_file: hash_and_equals

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
  // List<String> images;
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
    // required this.images,
    required this.returnPolicy,
     this.productQuantity = 1,
    required this.warrantyInformation,
  });

    bool operator == (covariant Product other) => other.id == id;


  factory Product.fromJson(Map product) {
    return Product(
      category: product["category"] ?? "",
      description: product["description"] ?? "",
      id: product['id'] ?? 0,
      thumbnail: product['thumbnail'] ?? "",
      price: product["price"] ?? 0,
      title: product["title"] ?? "",
      brand: product["brand"] ?? "Gloceries",
      discountPercentage: product["discountpercentage"] ?? 0,
      rating: product["rating"] ?? 0,
      stock: product["stock"] ?? 0,
      availabilityStatus: product["availabilitystatus"] ?? "",
      // images: product["images"].cast<String>(),
      returnPolicy: product["returnpolicy"],
      warrantyInformation: product["warrantyinformation"],
      productQuantity: product["productQuantity"] ?? 1
    );
  }


  
}

Map productToMap(Product product){
  return {
     "category": product.category ,
      "description": product.description,
      "id": product.id,
      "thumbnail": product.thumbnail,
      "price": product.price,
      "title": product.title,
      "brand": product.brand,
      "discountpercentage": product.discountPercentage,
      "rating": product.rating,
      "stock": product.stock,
      "availabilitystatus": product.availabilityStatus,
      // "images": product.images,
      "returnpolicy": product.returnPolicy,
      "warrantyinformation": product.warrantyInformation,
      "productQuantity"  :product.productQuantity
  };
}

Product mapToProduct(Map product){
  return Product(  category: product["category"] ?? "",
      description: product["description"] ?? "",
      id: product['id'] ?? 0,
      thumbnail: product['thumbnail'] ?? "",
      price: product["price"] ?? 0,
      title: product["title"] ?? "",
      brand: product["brand"] ?? "Gloceries",
      discountPercentage: product["discountpercentage"] ?? 0,
      rating: product["rating"] ?? 0,
      stock: product["stock"] ?? 0,
      availabilityStatus: product["availabilitystatus"] ?? "",
      // images: product["images"].cast<String>(),
      returnPolicy: product["returnpolicy"],
      warrantyInformation: product["warrantyinformation"],
      productQuantity: product["productQuantity"] ?? 1,
      );
}
