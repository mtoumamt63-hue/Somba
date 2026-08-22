import 'package:flutter/foundation.dart';

/// Modèle immutable représentant un produit e-commerce.
@immutable
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final double rating;
  final String imageUrl;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.rating = 0.0,
    this.isFavorite = false,
  });

  /// Crée une copie de l'instance avec des valeurs modifiées (Immutabilité).
  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    double? rating,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Sérialisation vers Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'rating': rating,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  /// Désérialisation depuis Map JSON.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.category == category &&
        other.rating == rating &&
        other.imageUrl == imageUrl &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    price,
    category,
    rating,
    imageUrl,
    isFavorite,
  );

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price Fcfa, category: $category, rating: $rating, isFavorite: $isFavorite)';
  }
}
