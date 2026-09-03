import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:somba/features/products/domain/product.dart';
import 'package:somba/features/products/presentation/providers/products_provider.dart';

void main() {
  group('Integration Flow: Catalogue & Gestion des Favoris', () {
    const p1 = Product(
      id: 'fav_flow_1',
      title: 'iPad Pro 11"',
      description: 'Tablette tactile Apple',
      price: 600000,
      category: 'Tablettes',
      imageUrl: 'https://example.com/ipad.png',
    );

    const p2 = Product(
      id: 'fav_flow_2',
      title: 'Apple Watch Ultra',
      description: 'Montre connectée sportive',
      price: 550000,
      category: 'Montres',
      imageUrl: 'https://example.com/watch.png',
    );

    const p3 = Product(
      id: 'fav_flow_3',
      title: 'Magic Keyboard',
      description: 'Clavier pour iPad',
      price: 190000,
      category: 'Accessoires',
      imageUrl: 'https://example.com/keyboard.png',
    );

    test('Flux complet des favoris : Ajout multiple -> Filtrage des produits -> Retrait', () async {
      final container = ProviderContainer(
        overrides: [
          productsProvider.overrideWith((ref) => [p1, p2, p3]),
        ],
      );
      addTearDown(container.dispose);

      // 1. Initialement aucun favori
      expect(container.read(favoritesProvider), isEmpty);
      expect(container.read(favoritesCountProvider), 0);

      // 2. Ajout de p1 et p2 aux favoris
      final favoritesNotifier = container.read(favoritesProvider.notifier);
      favoritesNotifier.addFavorite(p1.id);
      favoritesNotifier.addFavorite(p2.id);

      expect(container.read(favoritesProvider).length, 2);
      expect(container.read(favoritesCountProvider), 2);
      expect(favoritesNotifier.isFavorite(p1.id), isTrue);
      expect(favoritesNotifier.isFavorite(p2.id), isTrue);
      expect(favoritesNotifier.isFavorite(p3.id), isFalse);

      // 3. Toggle sur p2 pour le retirer des favoris
      favoritesNotifier.toggleFavorite(p2.id);
      expect(favoritesNotifier.isFavorite(p2.id), isFalse);
      expect(container.read(favoritesCountProvider), 1);

      // 4. Retrait de p1
      favoritesNotifier.removeFavorite(p1.id);
      expect(container.read(favoritesProvider), isEmpty);
      expect(container.read(favoritesCountProvider), 0);
    });
  });
}
