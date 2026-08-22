import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/products_provider.dart';

/// Barre horizontale de sélecteurs de catégories (Chips modernes).
class CategoryChipsBar extends ConsumerWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final filterState = ref.watch(productSearchAndFilterProvider);
    final filterNotifier = ref.read(productSearchAndFilterProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return categoriesAsync.when(
      data: (categories) {
        final allCategories = ['Tous', ...categories];
        final selectedCategory = filterState.selectedCategory ?? 'Tous';

        return SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allCategories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = selectedCategory.toLowerCase() == category.toLowerCase();

              return GestureDetector(
                onTap: () => filterNotifier.setCategory(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.surfaceSecondaryDark
                            : AppColors.surfaceSecondaryLight),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 38),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
