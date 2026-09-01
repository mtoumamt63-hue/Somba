import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/hive_keys.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../domain/cart_item.dart';

/// Repository de persistance locale pour le panier d'achat via Hive.
class LocalCartRepository {
  /// Sauvegarde les articles du panier dans Hive.
  Future<void> saveCart(List<CartItem> items) async {
    try {
      final box = LocalStorageService.cartBox;
      final rawList = items.map((item) => jsonEncode(item.toJson())).toList();
      await box.put(HiveKeys.keyCartItems, rawList);
    } catch (e) {
      debugPrint('⚠️ Erreur lors de la sauvegarde du panier : $e');
    }
  }

  /// Charge les articles du panier depuis Hive.
  List<CartItem> loadCart() {
    try {
      final box = LocalStorageService.cartBox;
      final dynamic raw = box.get(HiveKeys.keyCartItems);
      if (raw == null || raw is! List) {
        return [];
      }

      return raw
          .map((item) {
            try {
              if (item is String) {
                final Map<String, dynamic> json =
                    jsonDecode(item) as Map<String, dynamic>;
                return CartItem.fromJson(json);
              }
              if (item is Map) {
                return CartItem.fromJson(Map<String, dynamic>.from(item));
              }
            } catch (_) {}
            return null;
          })
          .whereType<CartItem>()
          .toList();
    } catch (e) {
      debugPrint('⚠️ Erreur lors du chargement du panier sauvegardé : $e');
      return [];
    }
  }

  /// Réinitialise le stockage du panier.
  Future<void> clearCart() async {
    try {
      final box = LocalStorageService.cartBox;
      await box.delete(HiveKeys.keyCartItems);
    } catch (e) {
      debugPrint('⚠️ Erreur lors du nettoyage du panier : $e');
    }
  }
}
