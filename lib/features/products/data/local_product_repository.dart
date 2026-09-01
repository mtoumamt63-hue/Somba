import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/hive_keys.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../domain/product.dart';

/// Repository gérant le cache local des produits via Hive.
class LocalProductRepository {
  /// Sauvegarde la liste des produits dans la boîte Hive.
  Future<void> cacheProducts(List<Product> products) async {
    try {
      final box = LocalStorageService.productsBox;
      final rawList = products.map((p) => jsonEncode(p.toJson())).toList();
      await box.put(HiveKeys.keyProductsList, rawList);
      await box.put(
        HiveKeys.keyProductsTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('⚠️ Erreur lors de la mise en cache des produits : $e');
    }
  }

  /// Récupère la liste des produits stockés dans le cache Hive.
  List<Product> getCachedProducts() {
    try {
      final box = LocalStorageService.productsBox;
      final dynamic raw = box.get(HiveKeys.keyProductsList);
      if (raw == null || raw is! List) {
        return [];
      }

      return raw
          .map((item) {
            try {
              if (item is String) {
                final Map<String, dynamic> json =
                    jsonDecode(item) as Map<String, dynamic>;
                return Product.fromJson(json);
              }
              if (item is Map) {
                return Product.fromJson(Map<String, dynamic>.from(item));
              }
            } catch (_) {}
            return null;
          })
          .whereType<Product>()
          .toList();
    } catch (e) {
      debugPrint('⚠️ Erreur lors de la lecture du cache des produits : $e');
      return [];
    }
  }

  /// Récupère l'horodatage de la dernière synchronisation du cache.
  DateTime? getLastSyncTime() {
    try {
      final box = LocalStorageService.productsBox;
      final int? timestamp = box.get(HiveKeys.keyProductsTimestamp) as int?;
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (_) {}
    return null;
  }

  /// Efface le cache des produits.
  Future<void> clearCache() async {
    try {
      final box = LocalStorageService.productsBox;
      await box.delete(HiveKeys.keyProductsList);
      await box.delete(HiveKeys.keyProductsTimestamp);
    } catch (e) {
      debugPrint('⚠️ Erreur lors du nettoyage du cache : $e');
    }
  }
}
