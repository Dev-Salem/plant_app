import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/admin/data/appwrite_admin_repository.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:plant_app/features/market/presentation/controllers/market_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_controllers.g.dart';

@riverpod
Future<List<Order>> adminOrders(Ref ref) async {
  final repository = ref.watch(adminRepositoryProvider);
  return await repository.getAllOrders();
}

@riverpod
Future<Order> adminOrderDetails(Ref ref, String orderId) async {
  final repository = ref.watch(adminRepositoryProvider);
  return await repository.getOrderDetails(orderId);
}

@riverpod
Future<List<OrderItem>> adminOrderItems(Ref ref, String orderId) async {
  final repository = ref.watch(adminRepositoryProvider);
  return await repository.getOrderItems(orderId);
}

// Notifiers for mutation operations

// Product Management Notifier
@riverpod
class AddProductNotifier extends _$AddProductNotifier {
  @override
  Future<void> build() async {
    // Empty initial build
    return;
  }

  Future<void> addProduct(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      await repository.addProduct(product);
      // Invalidate the products list to trigger a refresh
      ref.invalidate(productsProvider);
    });
  }
}

@riverpod
class UpdateProductNotifier extends _$UpdateProductNotifier {
  @override
  Future<void> build() async {
    // Empty initial build
    return;
  }

  Future<void> updateProduct(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      await repository.updateProduct(product);
      // Invalidate the products list to trigger a refresh
      ref.invalidate(productsProvider);
    });
  }
}

@riverpod
class DeleteProductNotifier extends _$DeleteProductNotifier {
  @override
  Future<void> build() async {
    // Empty initial build
    return;
  }

  Future<void> deleteProduct(String productId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      await repository.deleteProduct(productId);
      // Invalidate the products list to trigger a refresh
      ref.invalidate(productsProvider);
    });
  }
}

// Order Management Notifier
@riverpod
class UpdateOrderStatusNotifier extends _$UpdateOrderStatusNotifier {
  @override
  Future<void> build() async {
    // Empty initial build
    return;
  }

  Future<void> updateOrder(String orderId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      await repository.updateOrder(orderId);
      // Invalidate orders to refresh the list
      ref.invalidate(adminOrdersProvider);
      // Invalidate specific order details if it's being viewed
      ref.invalidate(adminOrderDetailsProvider(orderId));
    });
  }

    Future<void> deleteOrder(String orderId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminRepositoryProvider);
      await repository.deleteOrder(orderId);
      // Invalidate orders to refresh the list
      ref.invalidate(adminOrdersProvider);
      // Invalidate specific order details if it's being viewed
      ref.invalidate(adminOrderDetailsProvider(orderId));
    });
  }
}
