import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Variantes de style pour le composant CustomBadge.
enum BadgeVariant {
  primary,
  accent,
  success,
  warning,
  error,
  neutral,
  outline,
}

/// Badge / Pill moderne et polyvalent avec support d'icône et pastille de statut.
class CustomBadge extends StatelessWidget {
  final String text;
  final BadgeVariant variant;
  final IconData? icon;
  final bool showDot;
  final Color? customBackgroundColor;
  final Color? customTextColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;

  const CustomBadge({
    super.key,
    required this.text,
    this.variant = BadgeVariant.primary,
    this.icon,
    this.showDot = false,
    this.customBackgroundColor,
    this.customTextColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 16,
    this.fontSize = 12,
  });

  /// Constructeur usine pour un badge de catégorie sobre.
  factory CustomBadge.category(String category) {
    return CustomBadge(
      text: category,
      variant: BadgeVariant.neutral,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: 12,
    );
  }

  /// Constructeur usine pour un badge de remise / promotion.
  factory CustomBadge.discount(int percentage) {
    return CustomBadge(
      text: '-$percentage%',
      variant: BadgeVariant.error,
      showDot: true,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    );
  }

  /// Constructeur usine pour un badge de statut 'En stock' ou 'Succès'.
  factory CustomBadge.success(String text) {
    return CustomBadge(
      text: text,
      variant: BadgeVariant.success,
      showDot: true,
      borderRadius: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bgColor, textColor, borderColor) = _resolveColors(isDark);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: customBackgroundColor ?? bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: customTextColor ?? textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: customTextColor ?? textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: customTextColor ?? textColor,
              letterSpacing: -0.1,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  (Color bg, Color text, Color? border) _resolveColors(bool isDark) {
    switch (variant) {
      case BadgeVariant.primary:
        return (
          isDark ? AppColors.primaryLight.withValues(alpha: 0.15) : AppColors.primarySubtle,
          isDark ? AppColors.primaryLight : AppColors.primary,
          isDark ? AppColors.primaryLight.withValues(alpha: 0.3) : null,
        );
      case BadgeVariant.accent:
      case BadgeVariant.success:
        return (
          isDark ? AppColors.accent.withValues(alpha: 0.15) : AppColors.successSubtle,
          isDark ? AppColors.accentLight : AppColors.accentDark,
          isDark ? AppColors.accent.withValues(alpha: 0.3) : null,
        );
      case BadgeVariant.warning:
        return (
          isDark ? AppColors.warning.withValues(alpha: 0.15) : AppColors.warningSubtle,
          isDark ? AppColors.warning : const Color(0xFFB45309),
          isDark ? AppColors.warning.withValues(alpha: 0.3) : null,
        );
      case BadgeVariant.error:
        return (
          isDark ? AppColors.error.withValues(alpha: 0.15) : AppColors.errorSubtle,
          isDark ? const Color(0xFFFCA5A5) : AppColors.error,
          isDark ? AppColors.error.withValues(alpha: 0.3) : null,
        );
      case BadgeVariant.neutral:
        return (
          isDark ? AppColors.surfaceSecondaryDark : AppColors.surfaceSecondaryLight,
          isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          isDark ? AppColors.borderDark : AppColors.borderLight,
        );
      case BadgeVariant.outline:
        return (
          Colors.transparent,
          isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          isDark ? AppColors.borderDark : AppColors.borderLight,
        );
    }
  }
}
