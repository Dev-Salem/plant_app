import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/src/core/errors/error_messages.dart';
import 'package:plant_app/src/features/admin/presentation/controllers/admin_controllers.dart';
import 'package:plant_app/src/features/market/domain/entities.dart';

class OrderFormScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderFormScreen({super.key, required this.order});

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  late final TextEditingController _totalAmountController;
  late final TextEditingController _addressController;
  late String _selectedStatus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _totalAmountController = TextEditingController(
      text: widget.order.totalAmount.toStringAsFixed(2),
    );
    _addressController = TextEditingController(text: widget.order.address);

    // Normalize status to one of our standard values to avoid dropdown issues
    _selectedStatus = _normalizeStatus(widget.order.status);
  }

  // Helper method to normalize status values
  String _normalizeStatus(String status) {
    // Convert to lowercase for case-insensitive comparison
    final lowerStatus = status.toLowerCase();

    // Map all variations to our standard values
    if (lowerStatus == 'canceled' || lowerStatus == 'cancelled') {
      return 'cancelled';
    } else if (lowerStatus == 'completed') {
      return 'completed';
    } else {
      return 'pending'; // Default value
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateOrderStatus = ref.watch(updateOrderStatusNotifierProvider);
    final isLoading = updateOrderStatus is AsyncLoading;

    // Listen for errors in the update order notifier
    ref.listen(updateOrderStatusNotifierProvider, (previous, current) {
      if (current.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getFriendlyErrorMessage(current.error as Exception)),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order #${widget.order.id.substring(0, 8)}'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Order ID (non-editable)
            _buildInfoField('Order ID', widget.order.id),

            // User ID (non-editable)
            _buildInfoField('User ID', widget.order.userId),

            // Date & Time (non-editable)
            _buildInfoField(
              'Date & Time',
              DateFormat('MMM dd, yyyy • h:mm a').format(widget.order.dateTime),
            ),

            const SizedBox(height: 24),

            // Address (editable)
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a delivery address';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Total Amount (editable)
            TextFormField(
              controller: _totalAmountController,
              decoration: const InputDecoration(
                labelText: 'Total Amount',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the total amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Order Status (dropdown) - Fixed to avoid duplicate values
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Order Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),

            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: isLoading ? null : _updateOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                      : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }

  void _updateOrder() async {
    if (_formKey.currentState!.validate()) {
      // Create updated order object
      final updatedOrder = widget.order.copyWith(
        address: _addressController.text,
        totalAmount: double.parse(_totalAmountController.text),
        status: _selectedStatus,
      );

      await ref
          .read(updateOrderStatusNotifierProvider.notifier)
          .updateOrderDetails(
            updatedOrder,
            onSuccess: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
          );
    }
  }
}
