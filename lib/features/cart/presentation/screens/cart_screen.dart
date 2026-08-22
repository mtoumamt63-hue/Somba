import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/order_summary_card.dart';

/// Écran complet du Panier d'achat avec résumé et passage en caisse.
class CartScreen extends ConsumerWidget {
  final VoidCallback? onExploreProducts;

  const CartScreen({super.key, this.onExploreProducts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mon Panier (${cartState.totalItemsCount})',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (cartState.isNotEmpty)
            TextButton.icon(
              onPressed: () => _confirmClearCart(context, cartNotifier),
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              label: const Text('Vider'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
        ],
      ),
      body: cartState.isEmpty
          ? EmptyStateView(
              title: 'Votre panier est vide',
              subtitle:
                  'Parcourez notre catalogue et ajoutez vos articles favoris en un clic.',
              icon: Icons.shopping_bag_outlined,
              buttonText: 'Découvrir les produits',
              onButtonPressed: () {
                if (onExploreProducts != null) {
                  onExploreProducts!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  children: [
                    // Liste des articles
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartState.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cartState.items[index];
                        return CartItemCard(
                          item: item,
                          onIncrement: () =>
                              cartNotifier.incrementQuantity(item.product.id),
                          onDecrement: () =>
                              cartNotifier.decrementQuantity(item.product.id),
                          onRemove: () =>
                              cartNotifier.removeFromCart(item.product.id),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Champ Code Promo Fictif
                    _buildPromoCodeField(context, isDark),
                    const SizedBox(height: 24),

                    // Résumé financier
                    OrderSummaryCard(subtotal: cartState.totalPrice),
                  ],
                ),

                // Barre fixe de paiement en bas
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.4 : 0.08,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: CustomButton(
                        text:
                            'Procéder au paiement (${cartState.totalPrice.toStringAsFixed(0)} Fcfa)',
                        icon: Icons.lock_outline_rounded,
                        onPressed: () => _showCheckoutBottomSheet(
                          context,
                          ref,
                          cartState.totalPrice,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPromoCodeField(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Code promotionnel (ex: SOMBA20)',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Code promo appliqué avec succès !'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  void _confirmClearCart(BuildContext context, CartNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vider le panier ?'),
        content: const Text(
          'Tous les articles actuellement dans votre panier seront retirés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              notifier.clearCart();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutBottomSheet(
    BuildContext context,
    WidgetRef ref,
    double total,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.accentSubtle,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accentDark,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Paiement Réussi !',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre commande de ${total.toStringAsFixed(0)} Fcfa a été validée avec succès. Un e-mail de confirmation vous a été envoyé.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Continuer mes achats',
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
