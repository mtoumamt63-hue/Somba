import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cart_feedback_service.dart';
import '../../../../core/widgets/animated_add_to_cart_button.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/price_tag.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/product.dart';
import '../screens/product_detail_screen.dart';

/// Carte produit de luxe (Inspirée des boutiques Apple & SSENSE).
class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider).contains(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vignette image avec bouton favori et note en superposition
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(19),
                    ),
                    child: Hero(
                      tag: 'product_image_${product.id}',
                      child: CustomCachedImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // Dégradé léger en haut pour contraster les boutons
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bouton favori flottant en haut à droite
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Semantics(
                      button: true,
                      label: isFav
                          ? 'Retirer ${product.title} des favoris'
                          : 'Ajouter ${product.title} aux favoris',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .toggleFavorite(product.id);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: (isDark ? Colors.black : Colors.white)
                                  .withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                key: ValueKey(isFav),
                                size: 17,
                                color:
                                    isFav ? AppColors.coral : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Pastille de note en bas à gauche
                  if (product.rating > 0)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white)
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Contenu texte, prix et bouton d'action
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: isDark
                                ? AppColors.primaryLight
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            height: 1.25,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Ligne Prix et Bouton Panier Rapide
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PriceTag.compact(
                          price: product.price,
                        ),
                        AnimatedAddToCartButton(
                          isIconOnly: true,
                          onAddToCart: () {
                            ref
                                .read(cartProvider.notifier)
                                .addToCart(product);

                            CartFeedbackService.show(
                              context,
                              product: product,
                              onOpenCart: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const CartScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
