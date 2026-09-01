import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../features/products/data/mock_products_data.dart';

/// Service gérant les interactions de base et le seeding avec Cloud Firestore.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Collection principale des produits.
  CollectionReference<Map<String, dynamic>> get productsRef =>
      _firestore.collection('products');

  /// Collection des catégories de produits.
  CollectionReference<Map<String, dynamic>> get categoriesRef =>
      _firestore.collection('categories');

  /// Initialise la base de données Firestore avec les produits initiaux
  /// si la collection est actuellement vide.
  Future<void> seedInitialDataIfEmpty() async {
    try {
      final snapshot = await productsRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        debugPrint('🌱 Initialisation du catalogue Firestore avec les données par défaut...');
        final batch = _firestore.batch();

        for (final product in kMockProducts) {
          final docRef = productsRef.doc(product.id);
          batch.set(docRef, product.toJson());
        }

        // Seeding des catégories
        final categories = kMockProducts.map((p) => p.category).toSet();
        for (final cat in categories) {
          final catRef = categoriesRef.doc(cat);
          batch.set(catRef, {'name': cat, 'createdAt': FieldValue.serverTimestamp()});
        }

        await batch.commit();
        debugPrint('✅ Seeding Firestore terminé avec succès (${kMockProducts.length} produits insérés).');
      }
    } catch (e) {
      debugPrint('⚠️ Erreur lors du seeding Firestore (continuera en mode dégradé) : $e');
    }
  }
}
