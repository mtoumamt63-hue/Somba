import 'package:flutter/foundation.dart';
import '../../products/domain/product.dart';

/// Modèle immutable représentant un article dans le panier d'achat.
@immutable
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1})
    : assert(quantity > 0, 'La quantité doit être supérieure à zéro');

  /// Calcul du montant total de l'article (prix unitaire x quantité).
  double get totalPrice => product.price * quantity;

  /// Crée une copie de l'instance avec des valeurs modifiées (Immutabilité).
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Sérialisation vers Map JSON.
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  /// Désérialisation depuis Map JSON.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(product, quantity);

  @override
  String toString() {
    return 'CartItem(product: ${product.title}, quantity: $quantity, total: $totalPrice)';
  }
}
