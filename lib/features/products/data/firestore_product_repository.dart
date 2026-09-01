import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/product.dart';
import 'mock_products_data.dart';
import 'product_repository.dart';

/// Implémentation du ProductRepository basée sur Cloud Firestore.
class FirestoreProductRepository implements ProductRepository {
  final FirebaseFirestore _firestore;

  FirestoreProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');

  @override
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _productsRef.get();
      if (snapshot.docs.isEmpty) {
        // Fallback sécurisé vers le catalogue par défaut
        return List<Product>.unmodifiable(kMockProducts);
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      // En cas d'erreur ou d'absence de réseau direct, relancer l'erreur
      // qui sera interceptée par le repository offline-first
      rethrow;
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _productsRef.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      return Product.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      if (category.trim().isEmpty || category.toLowerCase() == 'tous') {
        return await getProducts();
      }

      final snapshot = await _productsRef
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final products = await getProducts();
      final categories = products.map((p) => p.category).toSet().toList();
      categories.sort();
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final allProducts = await getProducts();
      final trimmed = query.trim().toLowerCase();
      if (trimmed.isEmpty) return allProducts;

      return allProducts.where((product) {
        final matchTitle = product.title.toLowerCase().contains(trimmed);
        final matchDescription =
            product.description.toLowerCase().contains(trimmed);
        final matchCategory = product.category.toLowerCase().contains(trimmed);
        return matchTitle || matchDescription || matchCategory;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
