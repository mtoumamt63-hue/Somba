import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/core/widgets/price_tag.dart';

void main() {
  group('PriceTag Widget Tests', () {
    testWidgets('doit afficher le prix formate correctement', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTag(price: 45000),
          ),
        ),
      );

      expect(find.text('45000 Fcfa'), findsOneWidget);
    });

    testWidgets('doit afficher le prix barre lorsque originalPrice est superieur au prix', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTag(
              price: 35000,
              originalPrice: 50000,
            ),
          ),
        ),
      );

      expect(find.text('35000 Fcfa'), findsOneWidget);
      expect(find.text('50000 Fcfa'), findsOneWidget);
    });

    testWidgets('PriceTag.large doit appliquer une taille de texte accrue', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTag.large(price: 120000),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('120000 Fcfa'));
      expect(textWidget.style?.fontSize, 28);
      expect(textWidget.style?.fontWeight, FontWeight.w800);
    });
  });
}
