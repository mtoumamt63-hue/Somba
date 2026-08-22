import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../products/domain/product.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../providers/favorites_provider.dart';

/// Écran des Favoris / Coups de Cœur de l'utilisateur.
class FavoritesScreen extends ConsumerWidget {
  final VoidCallback? onExplore;

  const FavoritesScreen({
    super.key,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProductsAsync = ref.watch(favoriteProductsListProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes Favoris ($favoritesCount)',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          if (favoritesCount > 0)
            TextButton.icon(
              onPressed: () => _confirmClearFavorites(context, ref),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Tout effacer'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
        ],
      ),
      body: AsyncValueWidget<List<Product>>(
        value: favoriteProductsAsync,
        data: (products) {
          if (products.isEmpty) {
            return EmptyStateView(
              title: 'Aucun favori pour le moment',
              subtitle:
                  'Appuyez sur l\'icône cœur sur les fiches produits pour retrouver vos articles coup de cœur ici.',
              icon: Icons.favorite_border_rounded,
              buttonText: 'Explorer le catalogue',
              onButtonPressed: onExplore,
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }

  void _confirmClearFavorites(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vider les favoris ?'),
        content: const Text(
          'Tous vos articles enregistrés seront retirés de votre liste de souhaits.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).clearFavorites();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }
}
