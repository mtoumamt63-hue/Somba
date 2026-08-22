import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_repository.dart';
import '../../domain/product.dart';

// =============================================================================
// 1. ENUMS & ÉTAT DES FILTRES ET DE RECHERCHE
// =============================================================================

/// Options de tri applicables au catalogue de produits.
enum SortOption {
  popularity('Popularité'),
  priceAsc('Prix croissant'),
  priceDesc('Prix décroissant'),
  ratingDesc('Meilleures notes'),
  nameAsc('Nom A-Z');

  const SortOption(this.label);
  final String label;
}

/// État immutable représentant les critères de recherche, filtrage et tri.
@immutable
class ProductFilterState {
  /// Mot-clé saisi dans la barre de recherche.
  final String searchQuery;

  /// Catégorie sélectionnée (null ou 'Tous' = toutes les catégories).
  final String? selectedCategory;

  /// Option de tri actuelle.
  final SortOption sortOption;

  /// Filtre de prix minimum (optionnel).
  final double? minPrice;

  /// Filtre de prix maximum (optionnel).
  final double? maxPrice;

  const ProductFilterState({
    this.searchQuery = '',
    this.selectedCategory,
    this.sortOption = SortOption.popularity,
    this.minPrice,
    this.maxPrice,
  });

  /// Crée une copie de l'état avec des valeurs modifiées.
  ProductFilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
    SortOption? sortOption,
    double? minPrice,
    double? maxPrice,
    bool clearPriceFilter = false,
  }) {
    return ProductFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      sortOption: sortOption ?? this.sortOption,
      minPrice: clearPriceFilter ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceFilter ? null : (maxPrice ?? this.maxPrice),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductFilterState &&
          other.searchQuery == searchQuery &&
          other.selectedCategory == selectedCategory &&
          other.sortOption == sortOption &&
          other.minPrice == minPrice &&
          other.maxPrice == maxPrice);

  @override
  int get hashCode => Object.hash(
        searchQuery,
        selectedCategory,
        sortOption,
        minPrice,
        maxPrice,
      );
}

// =============================================================================
// 2. NOTIFIER : GESTION DES FILTRES & RECHERCHE
// =============================================================================

/// Notifier responsable de la mutation de l'état des filtres et recherche.
class ProductSearchAndFilterNotifier extends Notifier<ProductFilterState> {
  @override
  ProductFilterState build() => const ProductFilterState();

  /// Met à jour la requête de recherche textuelle.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  /// Sélectionne une catégorie (ou l'annule si on sélectionne la même / 'Tous').
  void setCategory(String? category) {
    if (category == null ||
        category.toLowerCase() == 'tous' ||
        category == state.selectedCategory) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  /// Modifie le mode de tri.
  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  /// Applique une plage de prix.
  void setPriceRange({double? min, double? max}) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  /// Réinitialise l'ensemble des filtres.
  void resetFilters() {
    state = const ProductFilterState();
  }
}

// =============================================================================
// 3. PROVIDERS RIVERPOD
// =============================================================================

/// Provider 1 : productsProvider (FutureProvider)
/// Récupère la liste brute des produits via le ProductRepository (AsyncValue).
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

/// Provider 2 : productSearchAndFilterProvider (NotifierProvider)
/// Gère l'état réactif des filtres (recherche, catégorie, tri).
final productSearchAndFilterProvider =
    NotifierProvider<ProductSearchAndFilterNotifier, ProductFilterState>(
  ProductSearchAndFilterNotifier.new,
);

/// Provider 3 : filteredProductsProvider (Provider)
/// Combine le productsProvider (AsyncValue) et le productSearchAndFilterProvider
/// pour fournir une liste filtrée et triée réactive.
final filteredProductsProvider =
    Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final filter = ref.watch(productSearchAndFilterProvider);

  return productsAsync.whenData((products) {
    // 1. Filtrage par texte (titre ou description)
    var result = products.where((product) {
      if (filter.searchQuery.isEmpty) return true;
      final q = filter.searchQuery.toLowerCase();
      return product.title.toLowerCase().contains(q) ||
          product.description.toLowerCase().contains(q) ||
          product.category.toLowerCase().contains(q);
    }).toList();

    // 2. Filtrage par catégorie
    if (filter.selectedCategory != null &&
        filter.selectedCategory!.isNotEmpty &&
        filter.selectedCategory!.toLowerCase() != 'tous') {
      result = result
          .where((product) =>
              product.category.toLowerCase() ==
              filter.selectedCategory!.toLowerCase())
          .toList();
    }

    // 3. Filtrage par plage de prix
    if (filter.minPrice != null) {
      result = result.where((p) => p.price >= filter.minPrice!).toList();
    }
    if (filter.maxPrice != null) {
      result = result.where((p) => p.price <= filter.maxPrice!).toList();
    }

    // 4. Tri des résultats
    switch (filter.sortOption) {
      case SortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingDesc:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.nameAsc:
        result.sort((a, b) =>
            a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.popularity:
        // Ordre initial du catalogue
        break;
    }

    return result;
  });
});

/// Provider pour récupérer la liste unique des catégories disponibles.
final categoriesListProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getCategories();
});

/// Provider Family pour accéder au détail d'un produit via son ID.
final productByIdProvider =
    FutureProvider.family<Product?, String>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});
