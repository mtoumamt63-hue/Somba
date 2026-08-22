import 'package:flutter/foundation.dart';

/// Statut d'une commande passée.
enum OrderStatus {
  processing('En préparation'),
  shipped('Expédiée'),
  delivered('Livrée'),
  cancelled('Annulée');

  const OrderStatus(this.label);
  final String label;
}

/// Modèle immutable représentant une commande passée.
@immutable
class OrderSummary {
  final String id;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final double totalAmount;
  final int itemsCount;
  final List<String> previewImageUrls;

  const OrderSummary({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.itemsCount,
    this.previewImageUrls = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is OrderSummary && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Données mockées réalistes pour l'historique des commandes.
final List<OrderSummary> kMockOrders = [
  OrderSummary(
    id: 'ord_101',
    orderNumber: 'SOMBA-89423',
    date: DateTime.now().subtract(const Duration(days: 2)),
    status: OrderStatus.processing,
    totalAmount: 245000,
    itemsCount: 2,
    previewImageUrls: [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=400&auto=format&fit=crop&q=80',
    ],
  ),
  OrderSummary(
    id: 'ord_102',
    orderNumber: 'SOMBA-78210',
    date: DateTime.now().subtract(const Duration(days: 14)),
    status: OrderStatus.delivered,
    totalAmount: 1329000,
    itemsCount: 1,
    previewImageUrls: [
      'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&auto=format&fit=crop&q=80',
    ],
  ),
  OrderSummary(
    id: 'ord_103',
    orderNumber: 'SOMBA-64119',
    date: DateTime.now().subtract(const Duration(days: 42)),
    status: OrderStatus.delivered,
    totalAmount: 18000,
    itemsCount: 1,
    previewImageUrls: [
      'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop&q=80',
    ],
  ),
];
