import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/products/domain/product.dart';

void main() {
  group('Product Model Tests', () {
    const testProduct = Product(
      id: 'prod_001',
      title: 'iPhone 15 Pro Max',
      description: 'Smartphone haut de gamme Apple en titane',
      price: 850000,
      category: 'Smartphones',
      imageUrl: 'https://example.com/iphone.png',
      rating: 4.9,
      isFavorite: true,
    );

    test('doit instancier correctement un produit', () {
      expect(testProduct.id, 'prod_001');
      expect(testProduct.title, 'iPhone 15 Pro Max');
      expect(testProduct.price, 850000);
      expect(testProduct.category, 'Smartphones');
      expect(testProduct.rating, 4.9);
      expect(testProduct.isFavorite, isTrue);
    });

    test('doit cloner avec copyWith en modifiant uniquement les champs ciblés', () {
      final updatedProduct = testProduct.copyWith(
        price: 799000,
        isFavorite: false,
      );

      expect(updatedProduct.id, testProduct.id);
      expect(updatedProduct.title, testProduct.title);
      expect(updatedProduct.price, 799000);
      expect(updatedProduct.isFavorite, isFalse);
      expect(updatedProduct.category, testProduct.category);
    });

    test('doit sérialiser et désérialiser en JSON fidèlement', () {
      final json = testProduct.toJson();
      final parsedProduct = Product.fromJson(json);

      expect(parsedProduct, equals(testProduct));
      expect(parsedProduct.id, testProduct.id);
      expect(parsedProduct.title, testProduct.title);
      expect(parsedProduct.price, testProduct.price);
    });

    test('doit vérifier l\'égalité par valeur entre deux instances identiques', () {
      const identicalProduct = Product(
        id: 'prod_001',
        title: 'iPhone 15 Pro Max',
        description: 'Smartphone haut de gamme Apple en titane',
        price: 850000,
        category: 'Smartphones',
        imageUrl: 'https://example.com/iphone.png',
        rating: 4.9,
        isFavorite: true,
      );

      expect(testProduct, equals(identicalProduct));
      expect(testProduct.hashCode, equals(identicalProduct.hashCode));
    });
  });
}
