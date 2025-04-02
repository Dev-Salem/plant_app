import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/features/admin/presentation/controllers/admin_controllers.dart';
import 'package:plant_app/features/admin/presentation/screens/order_form_screen.dart';
import 'package:plant_app/features/market/domain/entities.dart';

class OrderDetailsCard extends ConsumerWidget {
  final Order order;

  const OrderDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsAsync = ref.watch(adminOrderItemsProvider(order.id));
    final updateOrderStatusAsync = ref.watch(updateOrderStatusNotifierProvider);
    final isUpdating = updateOrderStatusAsync is AsyncLoading;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer information section
          const Text(
            'Delivery Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('User ID:', order.userId),
          _buildInfoRow('Address:', order.address),
          _buildInfoRow(
            'Date & Time:',
            DateFormat('MMM dd, yyyy • h:mm a').format(order.dateTime),
          ),

          const Divider(height: 24),

          // Order items section
          const Text(
            'Order Items',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          orderItemsAsync.when(
            data: (items) {
              return Column(
                children: [
                  ...items.map((item) => OrderItemTile(item: item)),

                  const Divider(height: 24),

                  // Order total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '\$').format(order.totalAmount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading:
                () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  ),
                ),
            error:
                (error, stack) => Text(
                  'Failed to load order items: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                ),
          ),

          const SizedBox(height: 16),

          // Action buttons section
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Edit button
              TextButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderFormScreen(order: order)),
                  );
                },
              ),
              const SizedBox(width: 8),
              // Delete button
              TextButton.icon(
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  _confirmDelete(context, ref);
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Mark as completed button (only for pending orders)
          if (order.status.toLowerCase() == 'pending')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUpdating ? null : () => _confirmStatusUpdate(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child:
                    isUpdating
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text('Mark as Completed'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmStatusUpdate(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Update Order Status'),
            content: const Text('Are you sure you want to mark this order as completed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref
                      .read(updateOrderStatusNotifierProvider.notifier)
                      .updateOrder(order.id)
                      .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order marked as completed'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      })
                      .catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update order: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                },
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Order'),
            content: Text(
              'Are you sure you want to delete Order #${order.id.substring(0, 8)}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref
                      .read(updateOrderStatusNotifierProvider.notifier)
                      .deleteOrder(order.id)
                      .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order deleted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      })
                      .catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete order: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  '${formatter.format(item.price)} × ${item.quantity}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            formatter.format(item.price * item.quantity),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
