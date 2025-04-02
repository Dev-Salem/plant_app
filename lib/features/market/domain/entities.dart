import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // Simple string instead of reference
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = 'Other',
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  factory Product.fromDoc(Document doc) {
    return Product(
      id: doc.$id,
      name: doc.data['name'],
      description: doc.data['description'],
      price: doc.data['price'].toDouble(),
      imageUrl: doc.data['imageUrl'],
      category: doc.data['category'],
      isAvailable: doc.data['isAvailable'],
    );
  }

  @override
  List<Object> get props {
    return [id, name, description, price, imageUrl, category, isAvailable];
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class CartItem extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromDoc(Document doc) {
    return CartItem(
      id: doc.$id,
      userId: doc.data['userId'],
      productId: doc.data['productId'],
      productName: doc.data['productName'],
      price: doc.data['price'].toDouble(),
      quantity: doc.data['quantity'],
      imageUrl: doc.data['imageUrl'],
    );
  }

  @override
  List<Object> get props {
    return [id, userId, productId, productName, price, quantity, imageUrl];
  }

  CartItem copyWith({
    String? id,
    String? userId,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class Order extends Equatable {
  final String id;
  final String userId;
  final double totalAmount;
  final DateTime dateTime;
  final String status; // "pending" or "completed"
  final String? address;

  const Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.dateTime,
    required this.status,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'address': address,
    };
  }

  factory Order.fromDoc(Document doc) {
    return Order(
      id: doc.$id,
      userId: doc.data['userId'],
      totalAmount: doc.data['totalAmount'].toDouble(),
      dateTime: DateTime.parse(doc.data['dateTime']),
      status: doc.data['status'],
      address: doc.data['address'],
    );
  }

  @override
  List<Object> get props {
    return [id, userId, totalAmount, dateTime, status];
  }

  Order copyWith({
    String? id,
    String? userId,
    double? totalAmount,
    DateTime? dateTime,
    String? status,
    String? address,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      address: address ?? this.address,
    );
  }
}

class OrderItem extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromDoc(Document doc) {
    return OrderItem(
      id: doc.$id,
      orderId: doc.data['orderId'],
      productId: doc.data['productId'],
      productName: doc.data['productName'],
      price: doc.data['price'].toDouble(),
      quantity: doc.data['quantity'],
    );
  }

  @override
  List<Object> get props {
    return [id, orderId, productId, productName, price, quantity];
  }

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
