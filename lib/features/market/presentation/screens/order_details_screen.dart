import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:plant_app/features/market/presentation/controllers/market_controller.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsAsync = ref.watch(orderItemsProvider(orderId));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${orderId.substring(0, 8)}'),
        elevation: 0,
      ),
      body: orderItemsAsync.when(
        data: (orderItems) {
          if (orderItems.isEmpty) {
            return const Center(child: Text('No items found for this order'));
          }
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          OrderSummary(orderId: orderId, orderItems: orderItems),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Order Items',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Order items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      return OrderItemCard(orderItem: orderItems[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading order details: ${error.toString()}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class OrderSummary extends ConsumerWidget {
  final String orderId;
  final List<OrderItem> orderItems;
  
  const OrderSummary({super.key, required this.orderId, required this.orderItems});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersList = ref.watch(userOrdersProvider);
    
    return ordersList.when(
      data: (orders) {
        final order = orders.firstWhere((o) => o.id == orderId);
        final formattedDate = DateFormat('MMMM dd, yyyy').format(order.dateTime);
        final formattedTime = DateFormat('h:mm a').format(order.dateTime);
        
        return Column(
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(formattedDate, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(formattedTime, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            
            if (order.address != null && order.address!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.address!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            
            const Divider(),
            const SizedBox(height: 8),
            
            SummaryItem(
              title: 'Items', 
              value: '${orderItems.length}',
            ),
            const SizedBox(height: 4),
            SummaryItem(
              title: 'Status', 
              value: order.status.toUpperCase(),
              valueColor: order.status == 'completed' ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 4),
            SummaryItem(
              title: 'Total',
              value: '\$${order.totalAmount.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: ${error.toString()}'),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool isTotal;
  
  const SummaryItem({
    super.key, 
    required this.title, 
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isTotal 
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? (isTotal ? Theme.of(context).colorScheme.primary : null),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItem orderItem;
  
  const OrderItemCard({super.key, required this.orderItem});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderItem.productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Unit price: \$${orderItem.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity: ${orderItem.quantity}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '\$${(orderItem.price * orderItem.quantity).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
