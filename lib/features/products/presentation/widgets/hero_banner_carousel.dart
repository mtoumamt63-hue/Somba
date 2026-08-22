import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_cached_image.dart';

/// Modèle pour les bannières promotionnelles éditoriales.
class PromoBannerItem {
  final String title;
  final String subtitle;
  final String tag;
  final String imageUrl;
  final String ctaText;
  final Color tagColor;

  const PromoBannerItem({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.imageUrl,
    required this.ctaText,
    this.tagColor = AppColors.primary,
  });
}

const List<PromoBannerItem> kPromoBanners = [
  PromoBannerItem(
    tag: 'NOUVEAUTÉ 2026',
    title: 'Veste Biker en Cuir Véritable',
    subtitle: 'Découvrez la nouvelle gamme de vestes Biker.',
    ctaText: 'Explorer',
    tagColor: AppColors.primaryLight,
    imageUrl:
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80',
  ),
  PromoBannerItem(
    tag: 'ÉDITION LIMITÉE',
    title: 'Montres & Chronographes en Titane',
    subtitle: 'Précision suisse et élégance intemporelle à votre poignet.',
    ctaText: 'Découvrir',
    tagColor: AppColors.gold,
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200&auto=format&fit=crop&q=85',
  ),
  PromoBannerItem(
    tag: 'OFFRE SPÉCIALE',
    title: 'Sneakers & Streetwear de Luxe',
    subtitle: 'Jusqu\'à -30% sur une sélection de silhouettes iconiques.',
    ctaText: 'Profiter',
    tagColor: AppColors.accent,
    imageUrl:
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=1200&auto=format&fit=crop&q=85',
  ),
];

/// Carrousel Hero visuel avec pagination et défilement automatique doux.
class HeroBannerCarousel extends StatefulWidget {
  final VoidCallback? onBannerTap;

  const HeroBannerCarousel({super.key, this.onBannerTap});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % kPromoBanners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: kPromoBanners.length,
            itemBuilder: (context, index) {
              final banner = kPromoBanners[index];
              return _buildBannerCard(banner);
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicateurs de points (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            kPromoBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(PromoBannerItem banner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: widget.onBannerTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image d'arrière plan
                CustomCachedImage(imageUrl: banner.imageUrl, fit: BoxFit.cover),

                // Dégradé sombre pour lisibilité texte
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Contenu éditorial
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tag Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: banner.tagColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          banner.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Titre
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: Text(
                          banner.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Sous-titre
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          banner.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
