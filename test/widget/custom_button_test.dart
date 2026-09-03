import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/core/widgets/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('doit afficher le texte du bouton et repondre au clic', (tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Valider ma commande',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Valider ma commande'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('doit afficher un indicateur de chargement et desactiver le clic quand isLoading est vrai', (tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Chargement...',
              isLoading: true,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement...'), findsNothing);

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });

    testWidgets('doit afficher l\'icone lorsqu\'elle est specifiee', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Ajouter',
              icon: Icons.shopping_bag_outlined,
            ),
          ),
        ),
      );

      expect(find.text('Ajouter'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });
  });
}
