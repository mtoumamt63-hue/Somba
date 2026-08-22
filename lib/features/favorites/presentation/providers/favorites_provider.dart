import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../products/domain/product.dart';
import '../../../products/presentation/providers/products_provider.dart';

// =============================================================================
// PERSISTANCE LOCALE : GESTIONNAIRE DE STOCKAGE
// =============================================================================

/// Clé SharedPreferences pour la sauvegarde des favoris.
const String _kFavoritesStorageKey = 'somba_user_favorites_ids';

/// Provider pour initialiser ou accéder à l'instance SharedPreferences de manière asynchrone / sûre.
final sharedPrefsInstanceProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// =============================================================================
// NOTIFIER : GESTION DES FAVORIS AVEC PERSISTANCE
// =============================================================================

/// Notifier gérant la liste des IDs des produits marqués en favoris.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final SharedPreferences? _prefs;

  FavoritesNotifier([this._prefs]) : super(const {}) {
    _loadFavoritesFromStorage();
  }

  /// Charge les favoris sauvegardés au démarrage.
  void _loadFavoritesFromStorage() {
    if (_prefs != null) {
      final savedIds = _prefs.getStringList(_kFavoritesStorageKey);
      if (savedIds != null && savedIds.isNotEmpty) {
        state = Set<String>.unmodifiable(savedIds);
        return;
      }
    } else {
      // Chargement asynchrone si SharedPreferences n'a pas été injecté au constructeur
      SharedPreferences.getInstance().then((prefs) {
        final savedIds = prefs.getStringList(_kFavoritesStorageKey);
        if (savedIds != null && savedIds.isNotEmpty) {
          state = Set<String>.unmodifiable(savedIds);
        }
      }).catchError((_) {
        // Mode dégradé si SharedPreferences échoue
      });
    }
  }

  /// Sauvegarde l'état actuel des favoris dans le stockage local persistant.
  Future<void> _persistFavorites(Set<String> favorites) async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setStringList(_kFavoritesStorageKey, favorites.toList());
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des favoris : $e');
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
