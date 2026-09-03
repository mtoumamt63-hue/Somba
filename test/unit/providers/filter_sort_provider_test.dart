import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/providers/filter_sort_provider.dart';

void main() {
  group('FilterSortProvider Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state a aucune categorie et un tri par popularite', () {
      final state = container.read(filterSortProvider);

      expect(state.selectedCategory, isNull);
      expect(state.sortMode, SortMode.popularity);
    });

    test('setCategory selectionne une nouvelle categorie', () {
      container.read(filterSortProvider.notifier).setCategory('Smartphones');

      final state = container.read(filterSortProvider);
      expect(state.selectedCategory, 'Smartphones');
    });

    test('setCategory avec la meme categorie la deselectionne (toggle)', () {
      final notifier = container.read(filterSortProvider.notifier);

      notifier.setCategory('Mode');
      expect(container.read(filterSortProvider).selectedCategory, 'Mode');

      notifier.setCategory('Mode');
      expect(container.read(filterSortProvider).selectedCategory, isNull);
    });

    test('setSortMode modifie le mode de tri', () {
      final notifier = container.read(filterSortProvider.notifier);

      notifier.setSortMode(SortMode.priceLow);
      expect(container.read(filterSortProvider).sortMode, SortMode.priceLow);

      notifier.setSortMode(SortMode.priceHigh);
      expect(container.read(filterSortProvider).sortMode, SortMode.priceHigh);
    });

    test('reset reinitialise tous les filtres a l\'etat par defaut', () {
      final notifier = container.read(filterSortProvider.notifier);

      notifier.setCategory('Informatique');
      notifier.setSortMode(SortMode.priceHigh);

      notifier.reset();

      final state = container.read(filterSortProvider);
      expect(state.selectedCategory, isNull);
      expect(state.sortMode, SortMode.popularity);
    });
  });
}
