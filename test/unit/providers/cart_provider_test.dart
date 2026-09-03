import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/cart/data/local_cart_repository.dart';
import 'package:somba/features/cart/domain/cart_item.dart';
import 'package:somba/features/cart/presentation/providers/cart_provider.dart';
import 'package:somba/features/products/domain/product.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  List<CartItem> memoryCart = [];

  @override
  Future<void> saveCart(List<CartItem> items) async {
    memoryCart = List.from(items);
  }

  @override
  List<CartItem> loadCart() {
    return List.from(memoryCart);
  }

  @override
  Future<void> clearCart() async {
    memoryCart.clear();
  }
}

void main() {
  group('CartNotifier & CartState Unit Tests', () {
    late FakeLocalCartRepository fakeRepo;
    late CartNotifier cartNotifier;

    const productA = Product(
      id: 'p_1',
      title: 'Sneakers Nike Air',
      description: 'Chaussures de sport',
      price: 65000,
      category: 'Mode',
      imageUrl: 'https://example.com/nike.png',
    );

    const productB = Product(
      id: 'p_2',
      title: 'Montre Seiko 5',
      description: 'Montre automatique',
      price: 120000,
      category: 'Accessoires',
      imageUrl: 'https://example.com/seiko.png',
    );

    setUp(() {
      fakeRepo = FakeLocalCartRepository();
      cartNotifier = CartNotifier(fakeRepo);
    });

    test('initial state doit être vide', () {
      expect(cartNotifier.state.isEmpty, isTrue);
      expect(cartNotifier.state.totalPrice, 0.0);
      expect(cartNotifier.state.totalItemsCount, 0);
    });

    test('addToCart doit ajouter un produit avec quantité 1 par défaut', () {
      cartNotifier.addToCart(productA);

      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.first.product.id, 'p_1');
      expect(cartNotifier.state.items.first.quantity, 1);
      expect(cartNotifier.state.totalPrice, 65000);
      expect(cartNotifier.state.totalItemsCount, 1);
      expect(cartNotifier.state.uniqueProductCount, 1);
    });

    test('addToCart sur un produit existant doit incrémenter la quantité', () {
      cartNotifier.addToCart(productA, 2);
      cartNotifier.addToCart(productA, 3);

      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.first.quantity, 5);
      expect(cartNotifier.state.totalPrice, 325000); // 65000 * 5
      expect(cartNotifier.state.totalItemsCount, 5);
    });

    test('addToCart avec plusieurs produits distincts calcule correctement le total', () {
      cartNotifier.addToCart(productA, 2); // 130 000
      cartNotifier.addToCart(productB, 1); // 120 000

      expect(cartNotifier.state.items.length, 2);
      expect(cartNotifier.state.totalPrice, 250000);
      expect(cartNotifier.state.totalItemsCount, 3);
      expect(cartNotifier.state.quantityOf('p_1'), 2);
      expect(cartNotifier.state.quantityOf('p_2'), 1);
      expect(cartNotifier.state.quantityOf('p_inexistant'), 0);
    });

    test('incrementQuantity et decrementQuantity mettent à jour le total', () {
      cartNotifier.addToCart(productA, 2);

      cartNotifier.incrementQuantity('p_1');
      expect(cartNotifier.state.quantityOf('p_1'), 3);
      expect(cartNotifier.state.totalPrice, 195000);

      cartNotifier.decrementQuantity('p_1');
      expect(cartNotifier.state.quantityOf('p_1'), 2);
      expect(cartNotifier.state.totalPrice, 130000);
    });

    test('decrementQuantity à 0 retire l\'article du panier', () {
      cartNotifier.addToCart(productA, 1);
      cartNotifier.decrementQuantity('p_1');

      expect(cartNotifier.state.isEmpty, isTrue);
      expect(cartNotifier.state.items, isEmpty);
      expect(cartNotifier.state.totalPrice, 0.0);
    });

    test('removeFromCart retire complètement un article', () {
      cartNotifier.addToCart(productA, 2);
      cartNotifier.addToCart(productB, 1);

      cartNotifier.removeFromCart('p_1');

      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.first.product.id, 'p_2');
      expect(cartNotifier.state.totalPrice, 120000);
    });

    test('clearCart vide l\'intégralité du panier', () {
      cartNotifier.addToCart(productA, 3);
      cartNotifier.addToCart(productB, 2);

      cartNotifier.clearCart();

      expect(cartNotifier.state.isEmpty, isTrue);
      expect(cartNotifier.state.items, isEmpty);
      expect(fakeRepo.memoryCart, isEmpty);
    });
  });
}
