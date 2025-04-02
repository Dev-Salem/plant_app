import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/features/admin/presentation/controllers/admin_controllers.dart';
import 'package:plant_app/features/admin/presentation/widgets/order_details_card.dart';
import 'package:plant_app/features/market/domain/entities.dart';

class OrdersTab extends ConsumerWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(
            child: Text('No orders found', style: TextStyle(fontSize: 16, color: Colors.grey)),
          );
        }

        // Sort orders by date - newest first
        orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderListItem(order: order);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32))),
      error:
          (error, stackTrace) => Center(
            child: Text(
              'Error loading orders: ${error.toString()}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
    );
  }
}

class OrderListItem extends ConsumerWidget {
  final Order order;

  const OrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          'Order #${order.id.substring(0, 8)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          '${dateFormat.format(order.dateTime)} • ${currencyFormat.format(order.totalAmount)}',
          style: TextStyle(color: Colors.grey[700]),
        ),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.shopping_bag, color: Color(0xFF2E7D32)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            order.status.toUpperCase(),
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        children: [OrderDetailsCard(order: order)],
      ),
    );
  }
}
