import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/order_history.dart';
import '../providers/profile_provider.dart';
import '../widgets/order_history_card.dart';

/// Écran de profil utilisateur avec carte VIP Gold, commandes et réglages.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mon Compte')),
        body: const Center(child: Text('Aucun utilisateur connecté')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil à jour.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        physics: const BouncingScrollPhysics(),
        children: [
          // Carte de Membre VIP Signature (Style Apple Card Métallique)
          _buildVipMembershipCard(user.fullName),
          const SizedBox(height: 20),

          // Statistiques rapides
          _buildQuickStats(context, favoritesCount, isDark),
          const SizedBox(height: 24),

          // Section : Historique des commandes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historiques  de  Commandes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Voir tout')),
            ],
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kMockOrders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return OrderHistoryCard(order: kMockOrders[index]);
            },
          ),
          const SizedBox(height: 24),

          // Section : Préférences & Paramètres
          Text(
            'Paramètres & Sécurité',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsGroup(
            isDark: isDark,
            children: [
              _buildSettingsTile(
                icon: Icons.notifications_active_outlined,
                title: 'Notifications push',
                subtitle: 'Alertes promos & suivi de livraison',
                trailing: Switch.adaptive(
                  value: _notificationsEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                  },
                ),
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.fingerprint_rounded,
                title: 'Authentification biométrique',
                subtitle: 'Face ID / Empreinte digitale',
                trailing: Switch.adaptive(
                  value: _biometricsEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _biometricsEnabled = val);
                  },
                ),
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.credit_card_outlined,
                title: 'Moyens de paiement',
                subtitle: 'Visa •••• 4242 & Apple Pay',
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.location_on_outlined,
                title: 'Adresses de livraison',
                subtitle: '1 adresse par défaut',
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section : Assistance & Déconnexion
          _buildSettingsGroup(
            isDark: isDark,
            children: [
              _buildSettingsTile(
                icon: Icons.headset_mic_outlined,
                title: 'Service Concierge & Support 24/7',
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Confidentialité & Données',
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.logout_rounded,
                title: 'Déconnexion',
                titleColor: AppColors.error,
                iconColor: AppColors.error,
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.error,
                ),
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Carte de Membre VIP Haute Joaillerie / Apple Card.
  Widget _buildVipMembershipCard(String fullName) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1B4B), // Deep Indigo
            Color(0xFF312E81),
            Color(0xFF4338CA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFFCD34D),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SOMBA CLUB PRIVILÈGE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCD34D).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFCD34D).withValues(alpha: 0.5),
                  ),
                ),
                child: const Text(
                  'GOLD VIP',
                  style: TextStyle(
                    color: Color(0xFFFCD34D),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '••••  ••••  ••••  8942',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'monospace',
              letterSpacing: 3.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TITULAIRE',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fullName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'POINTS FIDÉLITÉ',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '3 450 pts',
                    style: TextStyle(
                      color: Color(0xFFFCD34D),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    int favoritesCount,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            label: 'Commandes',
            value: '${kMockOrders.length}',
            icon: Icons.shopping_bag_outlined,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            label: 'Favoris',
            value: '$favoritesCount',
            icon: Icons.favorite_border_rounded,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            label: 'Adresses',
            value: '1',
            icon: Icons.pin_drop_outlined,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: trailing,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(profileProvider.notifier).logout();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
