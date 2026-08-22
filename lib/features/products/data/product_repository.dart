import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';
import 'mock_products_data.dart';

/// Interface du Repository des Produits.
abstract class ProductRepository {
  /// Récupère l'intégralité des produits disponibles.
  Future<List<Product>> getProducts();

  /// Récupère un produit spécifique par son identifiant unique.
  Future<Product?> getProductById(String id);

  /// Récupère les produits d'une catégorie donnée.
  Future<List<Product>> getProductsByCategory(String category);

  /// Récupère la liste distincte de toutes les catégories.
  Future<List<String>> getCategories();

  /// Recherche des produits par mot-clé (titre, description ou catégorie).
  Future<List<Product>> searchProducts(String query);
}

/// Implémentation simulant une API distante avec latence réseau réaliste.
class MockProductRepository implements ProductRepository {
  final Duration latency;
  final List<Product> _products;

  MockProductRepository({
    this.latency = const Duration(milliseconds: 100),
    List<Product>? initialProducts,
  }) : _products = List<Product>.from(initialProducts ?? kMockProducts);

  @override
  Future<List<Product>> getProducts() async {
    await Future<void>.delayed(latency);
    return List<Product>.unmodifiable(_products);
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future<void>.delayed(latency);
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future<void>.delayed(latency);
    if (category.trim().isEmpty || category.toLowerCase() == 'tous') {
      return List<Product>.unmodifiable(_products);
    }
    return _products
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future<void>.delayed(latency);
    final categories = _products.map((p) => p.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future<void>.delayed(latency);
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isEmpty) {
      return List<Product>.unmodifiable(_products);
    }

    return _products.where((product) {
      final matchTitle = product.title.toLowerCase().contains(trimmedQuery);
      final matchDescription = product.description.toLowerCase().contains(
        trimmedQuery,
      );
      final matchCategory = product.category.toLowerCase().contains(
        trimmedQuery,
      );
      return matchTitle || matchDescription || matchCategory;
    }).toList();
  }
}

/// Provider Riverpod exposant l'instance du repository des produits.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return MockProductRepository();
});
