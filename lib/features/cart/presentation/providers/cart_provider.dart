import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local_cart_repository.dart';
import '../../domain/cart_item.dart';
import '../../../products/domain/product.dart';

// =============================================================================
// ÉTAT IMMUTABLE DU PANIER
// =============================================================================

/// État représentant le panier d'achat avec calculs dérivés optimisés.
@immutable
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  /// Montant total TTC du panier.
  double get totalPrice =>
      items.fold<double>(0.0, (total, item) => total + item.totalPrice);

  /// Nombre total d'unités d'articles dans le panier.
  int get totalItemsCount =>
      items.fold<int>(0, (count, item) => count + item.quantity);

  /// Nombre de références de produits uniques dans le panier.
  int get uniqueProductCount => items.length;

  /// Vérifie si le panier est vide.
  bool get isEmpty => items.isEmpty;

  /// Vérifie si le panier contient au moins un article.
  bool get isNotEmpty => items.isNotEmpty;

  /// Retourne la quantité d'un produit donné dans le panier (0 si absent).
  int quantityOf(String productId) {
    for (final item in items) {
      if (item.product.id == productId) {
        return item.quantity;
      }
    }
    return 0;
  }

  /// Crée une copie modifiée de l'état.
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartState && listEquals(other.items, items));

  @override
  int get hashCode => Object.hashAll(items);
}

// =============================================================================
// NOTIFIER : GESTION DU PANIER AVEC PERSISTANCE HIVE
// =============================================================================

/// Gestionnaire d'état du panier d'achat avec persistance Hive automatique.
class CartNotifier extends StateNotifier<CartState> {
  final LocalCartRepository _localCartRepo;

  CartNotifier([LocalCartRepository? localCartRepo])
      : _localCartRepo = localCartRepo ?? LocalCartRepository(),
        super(const CartState()) {
    _loadPersistedCart();
  }

  void _loadPersistedCart() {
    final savedItems = _localCartRepo.loadCart();
    if (savedItems.isNotEmpty) {
      state = CartState(items: List.unmodifiable(savedItems));
    }
  }

  void _persistState() {
    _localCartRepo.saveCart(state.items);
  }

  /// Ajoute un produit au panier ou augmente sa quantité s'il y est déjà.
  void addToCart(Product product, [int quantity = 1]) {
    if (quantity <= 0) return;

    final existingIndex =
        state.items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Produit déjà présent -> Incrémentation de la quantité
      final existingItem = state.items[existingIndex];
      final updatedList = List<CartItem>.from(state.items);
      updatedList[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = state.copyWith(items: List.unmodifiable(updatedList));
    } else {
      // Nouveau produit dans le panier
      final newItem = CartItem(product: product, quantity: quantity);
      state = state.copyWith(
        items: List.unmodifiable([...state.items, newItem]),
      );
    }
    _persistState();
  }

  /// Modifie directement la quantité d'un article (le retire si quantité <= 0).
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedList = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: List.unmodifiable(updatedList));
    _persistState();
  }

  /// Incrémente la quantité d'un produit d'une unité.
  void incrementQuantity(String productId) {
    final currentQty = state.quantityOf(productId);
    if (currentQty > 0) {
      updateQuantity(productId, currentQty + 1);
    }
  }

  /// Décrémente la quantité d'un produit d'une unité (le supprime si quantité tombe à 0).
  void decrementQuantity(String productId) {
    final currentQty = state.quantityOf(productId);
    if (currentQty > 0) {
      updateQuantity(productId, currentQty - 1);
    }
  }

  /// Retire complètement un article du panier via son ID.
  void removeFromCart(String productId) {
    final updatedList =
        state.items.where((item) => item.product.id != productId).toList();
    state = state.copyWith(items: List.unmodifiable(updatedList));
    _persistState();
  }

  /// Vide l'intégralité du panier d'achat.
  void clearCart() {
    state = const CartState();
    _localCartRepo.clearCart();
  }
}

// =============================================================================
// PROVIDERS EXPOSÉS
// =============================================================================

/// Provider 4 : cartProvider (StateNotifierProvider)
/// Gère l'état global du panier d'achat.
final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Provider dérivé pour écouter uniquement le montant total du panier.
final cartTotalPriceProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalPrice;
});

/// Provider dérivé pour écouter le nombre total d'articles dans le panier.
final cartTotalCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalItemsCount;
});

