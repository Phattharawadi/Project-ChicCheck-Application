class Product {
  final int id;
  final String brand;
  final String name;
  final double price;
  final String? priceSign;
  final String? currency;
  final String image;
  final String description;
  final String? category;
  final String? productType;
  final List<String> tagList;
  bool favorite; // ทำให้เปลี่ยนแปลงได้

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    this.priceSign,
    this.currency,
    required this.image,
    required this.description,
    this.category,
    this.productType,
    required this.tagList,
    this.favorite = false,
  });

  factory Product.fromApi(Map<String, dynamic> json) {
    // แปลงข้อมูล tag_list เป็น List<String>
    List<String> tags = [];
    if (json['tag_list'] != null) {
      tags = List<String>.from(json['tag_list'].map((tag) => tag.toString().toLowerCase()));
    }

    return Product(
      id: json['id'] ?? 0,
      brand: json['brand'] ?? 'Unknown Brand',
      name: json['name'] ?? 'Unknown Product',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      priceSign: json['price_sign'],
      currency: json['currency'],
      image: json['image_link'] ?? '',
      description: json['description'] ?? 'No description available',
      category: json['category'],
      productType: json['product_type'],
      tagList: tags,
      favorite: false,
    );
  }

  // เพิ่มเมธอด fromJson สำหรับการอ่านจาก SharedPreferences
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      brand: json['brand'] ?? 'Unknown Brand',
      name: json['name'] ?? 'Unknown Product',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      priceSign: json['price_sign'],
      currency: json['currency'],
      image: json['image'] ?? '',
      description: json['description'] ?? 'No description available',
      category: json['category'],
      productType: json['product_type'],
      tagList: json['tag_list'] != null
          ? List<String>.from(json['tag_list'].map((tag) => tag.toString()))
          : [],
      favorite: json['favorite'] ?? false,
    );
  }

  // เพิ่มเมธอด toJson สำหรับการบันทึกใน SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'name': name,
      'price': price.toString(), // แปลงกลับเป็น String
      'price_sign': priceSign,
      'currency': currency,
      'image': image,
      'description': description,
      'category': category,
      'product_type': productType,
      'tag_list': tagList,
      'favorite': favorite,
    };
  }

  Product copyWith({
    int? id,
    String? brand,
    String? name,
    double? price,
    String? priceSign,
    String? currency,
    String? image,
    String? description,
    String? category,
    String? productType,
    List<String>? tagList,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      name: name ?? this.name,
      price: price ?? this.price,
      priceSign: priceSign ?? this.priceSign,
      currency: currency ?? this.currency,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      productType: productType ?? this.productType,
      tagList: tagList ?? this.tagList,
      favorite: favorite ?? this.favorite,
    );
  }
}