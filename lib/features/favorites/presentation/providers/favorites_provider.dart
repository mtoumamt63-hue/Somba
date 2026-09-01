import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/hive_keys.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../products/domain/product.dart';
import '../../../products/presentation/providers/products_provider.dart';

// =============================================================================
// NOTIFIER : GESTION DES FAVORIS AVEC PERSISTANCE HIVE
// =============================================================================

/// Notifier gérant la liste des IDs des produits marqués en favoris via Hive.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(const {}) {
    _loadFavoritesFromStorage();
  }

  /// Charge les favoris sauvegardés au démarrage depuis Hive.
  void _loadFavoritesFromStorage() {
    try {
      final box = LocalStorageService.favoritesBox;
      final dynamic raw = box.get(HiveKeys.keyFavoritesIds);
      if (raw != null && raw is List) {
        state = Set<String>.unmodifiable(raw.cast<String>());
      }
    } catch (e) {
      debugPrint('⚠️ Erreur lors du chargement des favoris Hive : $e');
    }
  }

  /// Sauvegarde l'état actuel des favoris dans Hive.
  Future<void> _persistFavorites(Set<String> favorites) async {
    try {
      final box = LocalStorageService.favoritesBox;
      await box.put(HiveKeys.keyFavoritesIds, favorites.toList());
    } catch (e) {
      debugPrint('⚠️ Erreur lors de la sauvegarde des favoris Hive : $e');
    }
  }

  /// Bascule l'état d'un produit (ajoute s'il n'y est pas, retire s'il y est).
  void toggleFavorite(String productId) {
    final updated = Set<String>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = Set<String>.unmodifiable(updated);
    _persistFavorites(state);
  }

  /// Ajoute explicitement un produit aux favoris.
  void addFavorite(String productId) {
    if (!state.contains(productId)) {
      final updated = Set<String>.from(state)..add(productId);
      state = Set<String>.unmodifiable(updated);
      _persistFavorites(state);
    }
  }

  /// Supprime explicitement un produit des favoris.
  void removeFavorite(String productId) {
    if (state.contains(productId)) {
      final updated = Set<String>.from(state)..remove(productId);
      state = Set<String>.unmodifiable(updated);
      _persistFavorites(state);
    }
  }

  /// Vérifie instantanément si un produit est dans les favoris.
  bool isFavorite(String productId) => state.contains(productId);

  /// Réinitialise et vide la liste des favoris.
  void clearFavorites() {
    state = const {};
    _persistFavorites(state);
  }
}

// =============================================================================
// PROVIDERS EXPOSÉS
// =============================================================================

/// Provider 5 : favoritesProvider (StateNotifierProvider)
/// Gère la liste des favoris avec synchronisation et persistance locale.
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

/// Provider retournant le nombre total de favoris.
final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).length;
});

/// Provider retournant la liste complète des objets Product mis en favoris.
final favoriteProductsListProvider =
    Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final favoriteIds = ref.watch(favoritesProvider);

  return productsAsync.whenData((products) {
    return products.where((product) => favoriteIds.contains(product.id)).toList();
  });
});
