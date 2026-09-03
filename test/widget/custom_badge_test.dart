import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somba/core/widgets/custom_badge.dart';

void main() {
  group('CustomBadge Widget Tests', () {
    testWidgets('doit afficher le texte du badge simple', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBadge(text: 'Nouveauté'),
          ),
        ),
      );

      expect(find.text('Nouveauté'), findsOneWidget);
    });

    testWidgets('CustomBadge.discount doit formater le pourcentage de remise', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomBadge.discount(25),
          ),
        ),
      );

      expect(find.text('-25%'), findsOneWidget);
    });

    testWidgets('CustomBadge.category doit afficher la categorie', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomBadge.category('Smartphones'),
          ),
        ),
      );

      expect(find.text('Smartphones'), findsOneWidget);
    });

    testWidgets('CustomBadge.success doit afficher le statut avec dot', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomBadge.success('En Stock'),
          ),
        ),
      );

      expect(find.text('En Stock'), findsOneWidget);
    });
  });
}
