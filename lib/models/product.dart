class Product {
  final int id;
  final String name;
  final String category; // ✅ TAMBAH
  final double price;
  final String? image;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.image,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      category: json['category'] ?? 'Uncategorized', // ✅ SAFE
      price: double.parse(json['price'].toString()),
      image: json['image'], // nullable
      description: json['description'],
    );
  }
}





