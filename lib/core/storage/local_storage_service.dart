import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'hive_keys.dart';

/// Service centralisé pour l'initialisation et l'accès aux boîtes Hive.
class LocalStorageService {
  static bool _isInitialized = false;

  /// Initialise Hive pour Flutter et ouvre les boîtes nécessaires au démarrage.
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // Ouvrir les boîtes essentielles en parallèle
      await Future.wait([
        Hive.openBox(HiveKeys.productsBox),
        Hive.openBox(HiveKeys.cartBox),
        Hive.openBox(HiveKeys.favoritesBox),
        Hive.openBox(HiveKeys.appSettingsBox),
      ]);

      _isInitialized = true;
      debugPrint('📦 Hive CE initialisé et boîtes ouvertes avec succès.');
    } catch (e) {
      debugPrint('⚠️ Erreur lors de l\'initialisation de Hive CE : $e');
    }
  }

  /// Boîte des produits en cache.
  static Box get productsBox => Hive.box(HiveKeys.productsBox);

  /// Boîte de persistance du panier.
  static Box get cartBox => Hive.box(HiveKeys.cartBox);

  /// Boîte des favoris.
  static Box get favoritesBox => Hive.box(HiveKeys.favoritesBox);

  /// Boîte des réglages et préférences.
  static Box get appSettingsBox => Hive.box(HiveKeys.appSettingsBox);
}
