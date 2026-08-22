import '../features/products/data/mock_products_data.dart';
import '../features/products/domain/product.dart';

export '../features/products/data/mock_products_data.dart';

/// Alias de compatibilité vers les données mockées du repository.
final List<Product> mockProducts = List<Product>.from(kMockProducts);
