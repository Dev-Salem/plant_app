import 'package:flutter/material.dart';
import 'package:plant_app/src/features/admin/presentation/widgets/product_form.dart';
import 'package:plant_app/src/features/market/domain/entities.dart';

class ProductFormScreen extends StatelessWidget {
  final Product? product; // If null, we're adding a new product

  const ProductFormScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final isEditing = product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ProductForm(
        product: product,
        onSuccess: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
