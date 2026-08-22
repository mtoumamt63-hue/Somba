import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../domain/product.dart';
import '../providers/products_provider.dart';
import '../widgets/category_chips_bar.dart';
import '../widgets/hero_banner_carousel.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';

/// Écran principal du catalogue Somba (Design Flagship E-Commerce).
class HomeScreen extends ConsumerWidget {
  final VoidCallback? onOpenCart;

  const HomeScreen({super.key, this.onOpenCart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(filteredProductsProvider);
    final filterState = ref.watch(productSearchAndFilterProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider);
          await ref.read(productsProvider.future);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Top App Bar avec Marque de Luxe
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: isDark
                  ? AppColors.backgroundDark
                  : AppColors.backgroundLight,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/B.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOMBA',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Édition Exclusive',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textSecondaryLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aucune nouvelle notification.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),

            // Barre de recherche moderne
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: ProductSearchBar(),
              ),
            ),

            // Carrousel Hero Promotionnel (affiché quand pas de filtre textuel)
            if (filterState.searchQuery.isEmpty &&
                filterState.selectedCategory == null) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: HeroBannerCarousel(),
                ),
              ),
            ],

            // En-tête de section Catégories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Catégories',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      filterState.selectedCategory ?? 'Toutes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.primaryLight
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Chips horizontaux de catégories
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: CategoryChipsBar(),
              ),
            ),

            // En-tête de la grille
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notre Sélection',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      filterState.sortOption.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grille responsive de produits gérée en Sliver
            AsyncValueWidget<List<Product>>.sliver(
              value: filteredProductsAsync,
              onRetry: () => ref.refresh(productsProvider),
              loading: () => _buildSkeletonGrid(isDark),
              data: (products) {
                if (products.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateView(
                      title: 'Aucun produit trouvé',
                      subtitle:
                          'Essayez de modifier votre recherche ou de réinitialiser vos critères.',
                      icon: Icons.search_off_rounded,
                      buttonText: 'Réinitialiser les filtres',
                      onButtonPressed: () {
                        ref
                            .read(productSearchAndFilterProvider.notifier)
                            .resetFilters();
                      },
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.60,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(product: products[index]);
                    }, childCount: products.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Grille de squelettes de chargement Shimmer adaptée aux slivers.
  Widget _buildSkeletonGrid(bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 14,
          childAspectRatio: 0.60,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(
                  width: double.infinity,
                  height: 160,
                  borderRadius: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(width: 50, height: 10, borderRadius: 4),
                      SizedBox(height: 8),
                      LoadingShimmer(width: 120, height: 14, borderRadius: 4),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LoadingShimmer(
                            width: 50,
                            height: 16,
                            borderRadius: 4,
                          ),
                          LoadingShimmer(
                            width: 36,
                            height: 36,
                            borderRadius: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }, childCount: 6),
      ),
    );
  }
}
