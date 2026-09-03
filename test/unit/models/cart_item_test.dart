import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/cart/domain/cart_item.dart';
import 'package:somba/features/products/domain/product.dart';

void main() {
  group('CartItem Model Tests', () {
    const sampleProduct = Product(
      id: 'prod_mac',
      title: 'MacBook Pro M3',
      description: 'Ordinateur portable pour professionnels',
      price: 1500000,
      category: 'Informatique',
      imageUrl: 'https://example.com/macbook.png',
    );

    test('doit calculer correctement le totalPrice', () {
      const cartItem = CartItem(product: sampleProduct, quantity: 3);
      expect(cartItem.totalPrice, 4500000);
      expect(cartItem.quantity, 3);
    });

    test('doit cloner avec copyWith en modifiant la quantité', () {
      const cartItem = CartItem(product: sampleProduct, quantity: 1);
      final updated = cartItem.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.product, sampleProduct);
      expect(updated.totalPrice, 7500000);
    });

    test('doit lancer une assertion si la quantité est inférieure ou égale à 0', () {
      expect(
        () => CartItem(product: sampleProduct, quantity: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => CartItem(product: sampleProduct, quantity: -2),
        throwsA(isA<AssertionError>()),
      );
    });

    test('doit sérialiser et désérialiser en JSON fidèlement', () {
      const cartItem = CartItem(product: sampleProduct, quantity: 2);
      final json = cartItem.toJson();
      final fromJsonItem = CartItem.fromJson(json);

      expect(fromJsonItem, equals(cartItem));
      expect(fromJsonItem.totalPrice, 3000000);
    });
  });
}
