import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bouton interactif avec micro-animation d'échelle et rebond (AnimatedScale)
/// pour l'ajout au panier, entièrement réactif et protégé contre les débordements d'écran.
class AnimatedAddToCartButton extends StatefulWidget {
  final VoidCallback onAddToCart;
  final bool isIconOnly;
  final String text;
  final double height;
  final double borderRadius;

  const AnimatedAddToCartButton({
    super.key,
    required this.onAddToCart,
    this.isIconOnly = false,
    this.text = 'Ajouter au panier',
    this.height = 50,
    this.borderRadius = 14,
  });

  @override
  State<AnimatedAddToCartButton> createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton> {
  double _scale = 1.0;
  bool _isSuccess = false;

  void _handleTap() async {
    setState(() {
      _scale = 0.88;
      _isSuccess = true;
    });

    widget.onAddToCart();

    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      setState(() => _scale = 1.05);
    }

    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (mounted) {
      setState(() => _scale = 1.0);
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _isSuccess = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: widget.isIconOnly ? _buildIconButton() : _buildFullButton(),
    );
  }

  Widget _buildIconButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isSuccess ? AppColors.accent : AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (_isSuccess ? AppColors.accent : AppColors.primary)
                    .withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _isSuccess ? Icons.check_rounded : Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildFullButton() {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isSuccess ? AppColors.accent : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isSuccess
              ? const Row(
                  key: ValueKey('success'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Ajouté !',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : FittedBox(
                  key: const ValueKey('idle'),
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
