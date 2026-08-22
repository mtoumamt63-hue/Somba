import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cart_feedback_service.dart';
import '../../../../core/widgets/animated_add_to_cart_button.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/price_tag.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/product.dart';

/// Écran de présentation détaillée d'un produit (Style Apple Store Flagship).
class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedQuantity = 1;
  int _selectedColorIndex = 0;

  final List<Color> _availableColors = const [
    Color(0xFF1E293B), // Midnight Slate
    Color(0xFF4F46E5), // Electric Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF1F5F9), // Silver White
  ];

  final List<String> _colorNames = const [
    'Noir Sidéral',
    'Indigo Électrique',
    'Vert Émeraude',
    'Argent Pur',
  ];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider).contains(product.id);
    final cartCount = ref.watch(cartTotalCountProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar immersive avec grande image Hero
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCircleButton(
                icon: Icons.arrow_back_rounded,
                isDark: isDark,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              // Bouton favori
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildCircleButton(
                  icon: isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: isFav ? AppColors.coral : null,
                  isDark: isDark,
                  onTap: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(product.id);
                  },
                ),
              ),
              // Bouton accès panier avec badge
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    _buildCircleButton(
                      icon: Icons.shopping_bag_outlined,
                      isDark: isDark,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_image_${product.id}',
                child: CustomCachedImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Corps de la fiche produit
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie & Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBadge.category(product.category),
                      if (product.rating > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceSecondaryDark
                                : AppColors.surfaceSecondaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating.toStringAsFixed(1)} (128 avis certifiés)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Titre
                  Text(
                    product.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Prix principal
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PriceTag.large(price: product.price),
                      const SizedBox(width: 12),
                      CustomBadge.success('En Stock'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sélecteur de Couleurs
                  Text(
                    'Coloris : ${_colorNames[_selectedColorIndex]}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(_availableColors.length, (index) {
                      final isSelected = _selectedColorIndex == index;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedColorIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _availableColors[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Bandeau de garanties
                  _buildHighlightsRow(isDark),
                  const SizedBox(height: 28),

                  // Description complète
                  Text(
                    'À propos du produit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Spécifications techniques rapides
                  _buildSpecsTable(isDark),
                ],
              ),
            ),
          ),
        ],
      ),

      // Barre fixe sticky en bas
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
              .withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Sélecteur de quantité compact
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceSecondaryDark
                      : AppColors.surfaceSecondaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 48,
                      ),
                      icon: const Icon(Icons.remove_rounded),
                      onPressed: _selectedQuantity > 1
                          ? () => setState(() => _selectedQuantity--)
                          : null,
                    ),
                    Text(
                      '$_selectedQuantity',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      iconSize: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 48,
                      ),
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () => setState(() => _selectedQuantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Bouton d'ajout animé au panier
              Expanded(
                child: AnimatedAddToCartButton(
                  text:
                      'Ajouter • ${(product.price * _selectedQuantity).toStringAsFixed(0)} Fcfa',
                  height: 52,
                  borderRadius: 16,
                  onAddToCart: () {
                    ref
                        .read(cartProvider.notifier)
                        .addToCart(product, _selectedQuantity);

                    CartFeedbackService.show(
                      context,
                      product: product,
                      onOpenCart: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color:
              iconColor ??
              (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildHighlightsRow(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHighlightItem(
            Icons.local_shipping_outlined,
            'Livraison 24/48h',
            isDark,
          ),
          _buildHighlightItem(
            Icons.verified_user_outlined,
            'Garantie 2 ans',
            isDark,
          ),
          _buildHighlightItem(Icons.replay_rounded, 'Retour 30 jours', isDark),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsTable(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSpecRow('Référence', widget.product.id.toUpperCase(), isDark),
          const Divider(height: 16),
          _buildSpecRow('Catégorie', widget.product.category, isDark),
          const Divider(height: 16),
          _buildSpecRow('Disponibilité', 'En stock immédiat', isDark),
          const Divider(height: 16),
          _buildSpecRow('Paiement', 'Airtel Money,  Mobile Money', isDark),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
