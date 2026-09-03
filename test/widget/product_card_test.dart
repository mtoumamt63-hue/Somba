import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/products/domain/product.dart';
import 'package:somba/features/products/presentation/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests', () {
    const testProduct = Product(
      id: 'prod_card_test',
      title: 'Casque Sony WH-1000XM5',
      description: 'Casque à réduction de bruit active',
      price: 240000,
      category: 'Audio',
      imageUrl: 'https://example.com/sony.jpg',
      rating: 4.8,
    );

    testWidgets('doit afficher les informations du produit (titre, categorie, prix, note)', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 280,
                height: 380,
                child: ProductCard(product: testProduct),
              ),
            ),
          ),
        ),
      );

      // Titre et catégorie
      expect(find.text('Casque Sony WH-1000XM5'), findsOneWidget);
      expect(find.text('AUDIO'), findsOneWidget);
      expect(find.text('240000 Fcfa'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
    });

    testWidgets('doit afficher l\'icone de favori par defaut non selectionnee', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 280,
                height: 380,
                child: ProductCard(product: testProduct),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    });
  });
}
