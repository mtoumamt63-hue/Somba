import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/profile/domain/order_history.dart';

void main() {
  group('OrderSummary Model Tests', () {
    test('doit valider les statuts de commande avec leurs labels', () {
      expect(OrderStatus.processing.label, 'En préparation');
      expect(OrderStatus.shipped.label, 'Expédiée');
      expect(OrderStatus.delivered.label, 'Livrée');
      expect(OrderStatus.cancelled.label, 'Annulée');
    });

    test('doit créer un résumé de commande avec les informations clés', () {
      final orderDate = DateTime(2025, 10, 15);
      final order = OrderSummary(
        id: 'ord_999',
        orderNumber: 'SOMBA-99901',
        date: orderDate,
        status: OrderStatus.shipped,
        totalAmount: 450000,
        itemsCount: 3,
        previewImageUrls: ['https://example.com/item1.png'],
      );

      expect(order.id, 'ord_999');
      expect(order.orderNumber, 'SOMBA-99901');
      expect(order.date, orderDate);
      expect(order.status, OrderStatus.shipped);
      expect(order.totalAmount, 450000);
      expect(order.itemsCount, 3);
      expect(order.previewImageUrls.length, 1);
    });

    test('doit vérifier l\'égalité basée sur l\'identifiant unique', () {
      final now = DateTime.now();
      final order1 = OrderSummary(
        id: 'ord_same',
        orderNumber: 'SOMBA-1',
        date: now,
        status: OrderStatus.processing,
        totalAmount: 100000,
        itemsCount: 1,
      );

      final order2 = OrderSummary(
        id: 'ord_same',
        orderNumber: 'SOMBA-2',
        date: now,
        status: OrderStatus.delivered,
        totalAmount: 200000,
        itemsCount: 2,
      );

      expect(order1, equals(order2));
      expect(order1.hashCode, equals(order2.hashCode));
    });
  });
}
