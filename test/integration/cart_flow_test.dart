import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/cart/data/local_cart_repository.dart';
import 'package:somba/features/cart/domain/cart_item.dart';
import 'package:somba/features/cart/presentation/providers/cart_provider.dart';
import 'package:somba/features/products/domain/product.dart';

class MockLocalCartRepository implements LocalCartRepository {
  List<CartItem> storage = [];

  @override
  Future<void> saveCart(List<CartItem> items) async {
    storage = List.from(items);
  }

  @override
  List<CartItem> loadCart() {
    return List.from(storage);
  }

  @override
  Future<void> clearCart() async {
    storage.clear();
  }
}

void main() {
  group('Integration Flow: Panier & Validation de Commande', () {
    late MockLocalCartRepository mockRepo;
    late CartNotifier cartNotifier;

    const macbook = Product(
      id: 'it_prod_1',
      title: 'MacBook Air M2',
      description: 'Ultraportable Apple',
      price: 750000,
      category: 'Informatique',
      imageUrl: 'https://example.com/macbook.png',
    );

    const airpods = Product(
      id: 'it_prod_2',
      title: 'AirPods Pro 2',
      description: 'Écouteurs sans fil',
      price: 180000,
      category: 'Audio',
      imageUrl: 'https://example.com/airpods.png',
    );

    setUp(() {
      mockRepo = MockLocalCartRepository();
      cartNotifier = CartNotifier(mockRepo);
    });

    test('Flux complet du panier : Ajout -> Modification Quantités -> Calculs -> Suppression', () async {
      // 1. Panier initialement vide
      expect(cartNotifier.state.isEmpty, isTrue);
      expect(cartNotifier.state.totalPrice, 0);

      // 2. Ajout du premier article (MacBook Air)
      cartNotifier.addToCart(macbook, 1);
      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.totalPrice, 750000);
      expect(cartNotifier.state.totalItemsCount, 1);

      // 3. Ajout du deuxième article (AirPods Pro x2)
      cartNotifier.addToCart(airpods, 2);
      expect(cartNotifier.state.items.length, 2);
      expect(cartNotifier.state.totalPrice, 750000 + (180000 * 2)); // 1 110 000
      expect(cartNotifier.state.totalItemsCount, 3);

      // 4. Incrémentation de la quantité des AirPods Pro
      cartNotifier.incrementQuantity('it_prod_2');
      expect(cartNotifier.state.quantityOf('it_prod_2'), 3);
      expect(cartNotifier.state.totalPrice, 750000 + (180000 * 3)); // 1 290 000

      // 5. Décrémentation
      cartNotifier.decrementQuantity('it_prod_2');
      expect(cartNotifier.state.quantityOf('it_prod_2'), 2);

      // 6. Suppression unitaire du MacBook
      cartNotifier.removeFromCart('it_prod_1');
      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.quantityOf('it_prod_1'), 0);
      expect(cartNotifier.state.totalPrice, 360000);

      // 7. Vidage complet du panier
      cartNotifier.clearCart();
      expect(cartNotifier.state.isEmpty, isTrue);
      expect(cartNotifier.state.totalPrice, 0);
      expect(mockRepo.storage, isEmpty);
    });
  });
}
