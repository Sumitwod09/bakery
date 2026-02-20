class ProductModel {
  final String id;
  final String? categoryId;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final List<String> imageUrls;
  final bool isFeatured;
  final bool isAvailable;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    this.categoryId,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    required this.imageUrls,
    this.isFeatured = false,
    this.isAvailable = true,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        categoryId: json['category_id'] as String?,
        name: json['name'] as String,
        slug: json['slug'] as String,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        imageUrls: json['image_urls'] != null
            ? (json['image_urls'] as List).map((e) => e as String).toList()
            : (json['image_url'] != null ? [json['image_url'] as String] : []),
        isFeatured: json['is_featured'] as bool? ?? false,
        isAvailable: json['is_available'] as bool? ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
        'slug': slug,
        'description': description,
        'price': price,
        'image_url': imageUrls.isNotEmpty ? imageUrls.first : null,
        'is_featured': isFeatured,
        'is_available': isAvailable,
      };

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? slug,
    String? description,
    double? price,
    List<String>? imageUrls,
    bool? isFeatured,
    bool? isAvailable,
    DateTime? createdAt,
  }) =>
      ProductModel(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrls: imageUrls ?? this.imageUrls,
        isFeatured: isFeatured ?? this.isFeatured,
        isAvailable: isAvailable ?? this.isAvailable,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) => other is ProductModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
