/// Noms des boîtes et clés de stockage pour Hive CE.
abstract class HiveKeys {
  // --- Noms des Boxes ---
  static const String productsBox = 'somba_products_box';
  static const String cartBox = 'somba_cart_box';
  static const String favoritesBox = 'somba_favorites_box';
  static const String appSettingsBox = 'somba_app_settings_box';

  // --- Clés de stockage spécifiques ---
  static const String keyProductsList = 'cached_products_list';
  static const String keyProductsTimestamp = 'cached_products_timestamp';
  static const String keyCartItems = 'saved_cart_items';
  static const String keyFavoritesIds = 'saved_favorites_ids';
}
