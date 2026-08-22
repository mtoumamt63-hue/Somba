import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modes de tri disponibles dans le catalogue.
enum SortMode {
  popularity('Popularite'),
  priceLow('Prix croissant'),
  priceHigh('Prix decroissant');

  const SortMode(this.label);
  final String label;
}

/// Etat immutable du filtre et du tri.
class FilterSortState {
  /// Categorie selectionnee ; null = toutes les categories.
  final String? selectedCategory;
  final SortMode sortMode;

  const FilterSortState({
    this.selectedCategory,
    this.sortMode = SortMode.popularity,
  });

  FilterSortState copyWith({
    String? selectedCategory,
    bool clearCategory = false,
    SortMode? sortMode,
  }) {
    return FilterSortState(
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      sortMode: sortMode ?? this.sortMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterSortState &&
          other.selectedCategory == selectedCategory &&
          other.sortMode == sortMode);

  @override
  int get hashCode => Object.hash(selectedCategory, sortMode);
}

class FilterSortNotifier extends Notifier<FilterSortState> {
  @override
  FilterSortState build() => const FilterSortState();

  /// Selectionne une categorie — rappeler la meme valeur pour deselectioner.
  void setCategory(String? category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void setSortMode(SortMode mode) => state = state.copyWith(sortMode: mode);

  void reset() => state = const FilterSortState();
}

final filterSortProvider =
    NotifierProvider<FilterSortNotifier, FilterSortState>(
  FilterSortNotifier.new,
);
