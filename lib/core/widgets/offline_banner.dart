import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_service.dart';
import '../theme/app_colors.dart';

/// Bandeau flottant élégant indiquant que l'application fonctionne en mode hors-ligne
/// avec les données locales sauvegardées.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(isOnlineProvider);

    final isOnline = connectivityAsync.maybeWhen(
      data: (status) => status,
      orElse: () => true, // Par défaut en ligne
    );

    if (isOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.warning,
      child: const SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Mode hors-ligne • Données locales affichées',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
