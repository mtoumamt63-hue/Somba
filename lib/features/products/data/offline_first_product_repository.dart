import 'package:flutter/foundation.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/connectivity_service.dart';
import '../domain/product.dart';
import 'firestore_product_repository.dart';
import 'local_product_repository.dart';
import 'mock_products_data.dart';
import 'product_repository.dart';

/// Repository Offline-First orchestrant Cloud Firestore et le cache local Hive.
/// Priorise les données fraîches du serveur, et bascule instantanément sur le cache local
/// en cas d'absence de connexion ou d'erreur réseau.
class OfflineFirstProductRepository implements ProductRepository {
  final FirestoreProductRepository _remoteRepo;
  final LocalProductRepository _localRepo;
  final ConnectivityService _connectivity;

  OfflineFirstProductRepository({
    FirestoreProductRepository? remoteRepo,
    LocalProductRepository? localRepo,
    ConnectivityService? connectivity,
  })  : _remoteRepo = remoteRepo ?? FirestoreProductRepository(),
        _localRepo = localRepo ?? LocalProductRepository(),
        _connectivity = connectivity ?? ConnectivityService();

  @override
  Future<List<Product>> getProducts() async {
    final isOnline = await _connectivity.isConnected;

    if (isOnline) {
      try {
        // 1. Tenter la récupération depuis Firestore
        final remoteProducts = await _remoteRepo.getProducts();

        // 2. Mettre en cache localement pour une utilisation hors-ligne ultérieure
        if (remoteProducts.isNotEmpty) {
          await _localRepo.cacheProducts(remoteProducts);
        }

        return remoteProducts;
      } catch (e) {
        debugPrint('⚠️ Erreur Firestore, tentative de secours via le cache Hive : $e');
        final cached = _localRepo.getCachedProducts();
        if (cached.isNotEmpty) {
          return cached;
        }
        // Si même le cache est vide, fallback sur le catalogue de démonstration
        return List<Product>.unmodifiable(kMockProducts);
      }
    } else {
      // Mode hors-ligne : lecture directe du cache Hive
      debugPrint('📡 Mode hors-ligne détecté : lecture du cache Hive...');
      final cached = _localRepo.getCachedProducts();
      if (cached.isNotEmpty) {
        return cached;
      }

      // Si le cache est vide et aucun réseau
      throw const NoInternetException();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    final isOnline = await _connectivity.isConnected;

    if (isOnline) {
      try {
        final product = await _remoteRepo.getProductById(id);
        if (product != null) return product;
      } catch (_) {}
    }

    // Recherche dans le cache local
    final cached = _localRepo.getCachedProducts();
    try {
      return cached.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final products = await getProducts();
    if (category.trim().isEmpty || category.toLowerCase() == 'tous') {
      return products;
    }
    return products
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final products = await getProducts();
    final categories = products.map((p) => p.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = await getProducts();
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return products;

    return products.where((product) {
      final matchTitle = product.title.toLowerCase().contains(trimmed);
      final matchDescription =
          product.description.toLowerCase().contains(trimmed);
      final matchCategory = product.category.toLowerCase().contains(trimmed);
      return matchTitle || matchDescription || matchCategory;
    }).toList();
  }
}
