import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/price_tag.dart';
import '../../domain/order_history.dart';

/// Carte pour afficher une commande passée avec statut visuel et vignettes.
class OrderHistoryCard extends StatelessWidget {
  final OrderSummary order;
  final VoidCallback? onTap;

  const OrderHistoryCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête commande : N° de commande & Badge Statut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNumber,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(order.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 12),

          // Vignettes miniatures des produits commandés
          if (order.previewImageUrls.isNotEmpty) ...[
            Row(
              children: [
                ...order.previewImageUrls.map(
                  (url) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CustomCachedImage(
                      imageUrl: url,
                      width: 48,
                      height: 48,
                      borderRadius: 10,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (order.itemsCount > order.previewImageUrls.length)
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceSecondaryDark
                          : AppColors.surfaceSecondaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '+${order.itemsCount - order.previewImageUrls.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${order.itemsCount} article${order.itemsCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    PriceTag.compact(price: order.totalAmount),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return const CustomBadge(
          text: 'Livrée',
          variant: BadgeVariant.success,
          showDot: true,
          fontSize: 11,
        );
      case OrderStatus.processing:
        return const CustomBadge(
          text: 'En préparation',
          variant: BadgeVariant.warning,
          showDot: true,
          fontSize: 11,
        );
      case OrderStatus.shipped:
        return const CustomBadge(
          text: 'Expédiée',
          variant: BadgeVariant.primary,
          showDot: true,
          fontSize: 11,
        );
      case OrderStatus.cancelled:
        return const CustomBadge(
          text: 'Annulée',
          variant: BadgeVariant.error,
          showDot: true,
          fontSize: 11,
        );
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
