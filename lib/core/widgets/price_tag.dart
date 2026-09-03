import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Composant d'affichage de prix haute précision (inspiré d'Apple & Stripe).
class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final String currencySymbol;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final bool isPromotional;
  final bool showDecimals;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.currencySymbol = 'Fcfa',
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700,
    this.color,
    this.isPromotional = false,
    this.showDecimals = true,
  });

  /// Variante large pour les fiches produits et totaux panier.
  const PriceTag.large({
    super.key,
    required this.price,
    this.originalPrice,
    this.currencySymbol = 'Fcfa',
    this.color,
    this.isPromotional = false,
    this.showDecimals = true,
  }) : fontSize = 28,
       fontWeight = FontWeight.w800;

  /// Variante compacte pour les cartes produits et listes.
  const PriceTag.compact({
    super.key,
    required this.price,
    this.originalPrice,
    this.currencySymbol = 'Fcfa',
    this.color,
    this.isPromotional = false,
    this.showDecimals = true,
  }) : fontSize = 16,
       fontWeight = FontWeight.w700;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor =
        color ??
        (isPromotional
            ? AppColors.error
            : (isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight));

    final formattedPrice = showDecimals
        ? price.toStringAsFixed(0).replaceAll('.', ',')
        : price.toInt().toString();

    final hasDiscount = originalPrice != null && originalPrice! > price;

    final semanticsText = hasDiscount
        ? 'Prix: $formattedPrice $currencySymbol, réduit depuis ${originalPrice!.toStringAsFixed(0)} $currencySymbol'
        : 'Prix: $formattedPrice $currencySymbol';

    return Semantics(
      label: semanticsText,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // Prix principal
          Text(
            '$formattedPrice $currencySymbol',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: effectiveColor,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),

          // Prix barré en cas de réduction
          if (hasDiscount) ...[
            const SizedBox(width: 8),
            Text(
              '${showDecimals ? originalPrice!.toStringAsFixed(0).replaceAll('.', ',') : originalPrice!.toInt()} $currencySymbol',
              style: TextStyle(
                fontSize: fontSize * 0.72,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
                decoration: TextDecoration.lineThrough,
                decorationColor: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
