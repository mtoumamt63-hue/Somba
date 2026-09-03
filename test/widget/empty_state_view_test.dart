import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/core/widgets/empty_state_view.dart';

void main() {
  group('EmptyStateView Widget Tests', () {
    testWidgets('doit afficher le titre, sous-titre et icone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateView(
              title: 'Votre panier est vide',
              subtitle: 'Découvrez nos articles tendances et commencez votre shopping',
              icon: Icons.shopping_cart_outlined,
            ),
          ),
        ),
      );

      expect(find.text('Votre panier est vide'), findsOneWidget);
      expect(
        find.text('Découvrez nos articles tendances et commencez votre shopping'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('doit afficher et declencher le bouton d\'action optionnel', (tester) async {
      var buttonClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateView(
              title: 'Aucun favori',
              subtitle: 'Ajoutez des articles en favoris',
              icon: Icons.favorite_border,
              buttonText: 'Explorer le catalogue',
              onButtonPressed: () {
                buttonClicked = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Explorer le catalogue'), findsOneWidget);

      await tester.tap(find.text('Explorer le catalogue'));
      await tester.pump();

      expect(buttonClicked, isTrue);
    });
  });
}
