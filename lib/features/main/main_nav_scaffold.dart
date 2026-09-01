import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/offline_banner.dart';
import '../cart/presentation/providers/cart_provider.dart';
import '../cart/presentation/screens/cart_screen.dart';
import '../favorites/presentation/providers/favorites_provider.dart';
import '../favorites/presentation/screens/favorites_screen.dart';
import '../products/presentation/screens/home_screen.dart';
import '../profile/presentation/screens/profile_screen.dart';

/// Structure principale de l'application avec barre de navigation flottante moderne.
class MainNavScaffold extends ConsumerStatefulWidget {
  const MainNavScaffold({super.key});

  @override
  ConsumerState<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends ConsumerState<MainNavScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = ref.watch(cartTotalCountProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);

    final screens = [
      HomeScreen(
        onOpenCart: () => setState(() => _currentIndex = 2),
      ),
      FavoritesScreen(
        onExplore: () => setState(() => _currentIndex = 0),
      ),
      CartScreen(
        onExploreProducts: () => setState(() => _currentIndex = 0),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
              .withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront_rounded,
              label: 'Accueil',
              isDark: isDark,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.favorite_border_rounded,
              activeIcon: Icons.favorite_rounded,
              label: 'Favoris',
              badgeCount: favoritesCount,
              isDark: isDark,
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.shopping_bag_outlined,
              activeIcon: Icons.shopping_bag_rounded,
              label: 'Panier',
              badgeCount: cartCount,
              isDark: isDark,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profil',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primaryLight.withValues(alpha: 0.18)
                  : AppColors.primarySubtle)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected
                      ? (isDark ? AppColors.primaryLight : AppColors.primary)
                      : (isDark
                          ? AppColors.textMutedDark
                          : AppColors.textSecondaryLight),
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
