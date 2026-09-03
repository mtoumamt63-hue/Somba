import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/favorites/presentation/providers/favorites_provider.dart';

void main() {
  group('FavoritesNotifier Unit Tests', () {
    late FavoritesNotifier favoritesNotifier;

    setUp(() {
      favoritesNotifier = FavoritesNotifier();
    });

    test('initial state doit être vide', () {
      expect(favoritesNotifier.state, isEmpty);
      expect(favoritesNotifier.isFavorite('prod_100'), isFalse);
    });

    test('toggleFavorite ajoute un produit s\'il n\'est pas présent', () {
      favoritesNotifier.toggleFavorite('prod_100');

      expect(favoritesNotifier.state.contains('prod_100'), isTrue);
      expect(favoritesNotifier.isFavorite('prod_100'), isTrue);
      expect(favoritesNotifier.state.length, 1);
    });

    test('toggleFavorite retire un produit s\'il est déjà présent', () {
      favoritesNotifier.toggleFavorite('prod_100');
      expect(favoritesNotifier.isFavorite('prod_100'), isTrue);

      favoritesNotifier.toggleFavorite('prod_100');
      expect(favoritesNotifier.isFavorite('prod_100'), isFalse);
      expect(favoritesNotifier.state, isEmpty);
    });

    test('addFavorite et removeFavorite gèrent l\'état explicitement', () {
      favoritesNotifier.addFavorite('prod_A');
      favoritesNotifier.addFavorite('prod_B');
      expect(favoritesNotifier.state.length, 2);

      // Doublon
      favoritesNotifier.addFavorite('prod_A');
      expect(favoritesNotifier.state.length, 2);

      favoritesNotifier.removeFavorite('prod_A');
      expect(favoritesNotifier.isFavorite('prod_A'), isFalse);
      expect(favoritesNotifier.isFavorite('prod_B'), isTrue);
    });

    test('clearFavorites vide l\'ensemble des favoris', () {
      favoritesNotifier.addFavorite('prod_1');
      favoritesNotifier.addFavorite('prod_2');
      favoritesNotifier.addFavorite('prod_3');

      favoritesNotifier.clearFavorites();
      expect(favoritesNotifier.state, isEmpty);
    });
  });
}
