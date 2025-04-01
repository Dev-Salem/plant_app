import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final List<String> additionalImages;
  final int stockQuantity;
  final Category category;
  final bool isFeatured;
  final List<String> tags;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice = 0.0,
    required this.imageUrl,
    this.additionalImages = const [],
    required this.stockQuantity,
    required this.category,
    this.isFeatured = false,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  bool get isOnSale => discountPrice > 0 && discountPrice < price;
  bool get isInStock => stockQuantity > 0;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    discountPrice,
    imageUrl,
    additionalImages,
    stockQuantity,
    category,
    isFeatured,
    tags,
    rating,
    reviewCount,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'discount_price': discountPrice,
    'image_url': imageUrl,
    'additional_images': additionalImages,
    'stock_quantity': stockQuantity,
    'category': category.toJson(),
    'is_featured': isFeatured,
    'tags': tags,
    'rating': rating,
    'review_count': reviewCount,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    discountPrice: json['discount_price'] ?? 0.0,
    imageUrl: json['image_url'],
    additionalImages: List<String>.from(json['additional_images'] ?? []),
    stockQuantity: json['stock_quantity'],
    category: Category.fromJson(json['category']),
    isFeatured: json['is_featured'] ?? false,
    tags: List<String>.from(json['tags'] ?? []),
    rating: json['rating'] ?? 0.0,
    reviewCount: json['review_count'] ?? 0,
  );
}

/// Category entity for classifying products
class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image_url': imageUrl,
  };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['image_url'],
  );
}

/// User entity for customer information
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final List<Address> addresses;
  final String? profilePictureUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.addresses = const [],
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, addresses, profilePictureUrl];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'addresses': addresses.map((a) => a.toJson()).toList(),
    'profile_picture_url': profilePictureUrl,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    addresses: (json['addresses'] as List?)?.map((a) => Address.fromJson(a)).toList() ?? [],
    profilePictureUrl: json['profile_picture_url'],
  );
}

/// Address entity for shipping and billing
class Address extends Equatable {
  final String id;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String? label;
  final bool isDefault;

  const Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.label,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, street, city, state, country, postalCode, label, isDefault];

  Map<String, dynamic> toJson() => {
    'id': id,
    'street': street,
    'city': city,
    'state': state,
    'country': country,
    'postal_code': postalCode,
    'label': label,
    'is_default': isDefault,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    street: json['street'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
    postalCode: json['postal_code'],
    label: json['label'],
    isDefault: json['is_default'] ?? false,
  );
}

/// Cart entity to hold items before purchase
class Cart extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  double get subtotal => items.fold(
    0,
    (sum, item) =>
        sum +
        (item.product.isOnSale
            ? item.product.discountPrice * item.quantity
            : item.product.price * item.quantity),
  );

  @override
  List<Object?> get props => [id, userId, items, createdAt, updatedAt];

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'items': items.map((i) => i.toJson()).toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json['id'],
    userId: json['user_id'],
    items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

/// CartItem entity representing a product in the cart
class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;

  const CartItem({required this.id, required this.product, required this.quantity});

  double get totalPrice =>
      product.isOnSale ? product.discountPrice * quantity : product.price * quantity;

  @override
  List<Object?> get props => [id, product, quantity];

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    product: Product.fromJson(json['product']),
    quantity: json['quantity'],
  );
}

/// Order entity for completed purchases
class Order extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final Address shippingAddress;
  final Address billingAddress;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.billingAddress,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.shippedAt,
    this.deliveredAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    shippingAddress,
    billingAddress,
    subtotal,
    tax,
    shippingCost,
    total,
    paymentMethod,
    status,
    createdAt,
    shippedAt,
    deliveredAt,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'items': items.map((i) => i.toJson()).toList(),
    'shipping_address': shippingAddress.toJson(),
    'billing_address': billingAddress.toJson(),
    'subtotal': subtotal,
    'tax': tax,
    'shipping_cost': shippingCost,
    'total': total,
    'payment_method': paymentMethod,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    'shipped_at': shippedAt?.toIso8601String(),
    'delivered_at': deliveredAt?.toIso8601String(),
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['user_id'],
    items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
    shippingAddress: Address.fromJson(json['shipping_address']),
    billingAddress: Address.fromJson(json['billing_address']),
    subtotal: json['subtotal'],
    tax: json['tax'],
    shippingCost: json['shipping_cost'],
    total: json['total'],
    paymentMethod: json['payment_method'],
    status: OrderStatus.values.byName(json['status']),
    createdAt: DateTime.parse(json['created_at']),
    shippedAt: json['shipped_at'] != null ? DateTime.parse(json['shipped_at']) : null,
    deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at']) : null,
  );
}

/// Order status enum
enum OrderStatus { pending, processing, shipped, delivered, cancelled, refunded }

/// Review entity for product reviews
class Review extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final List<String> imageUrls;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.imageUrls = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    userId,
    userName,
    rating,
    comment,
    imageUrls,
    createdAt,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'user_id': userId,
    'user_name': userName,
    'rating': rating,
    'comment': comment,
    'image_urls': imageUrls,
    'created_at': createdAt.toIso8601String(),
  };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    productId: json['product_id'],
    userId: json['user_id'],
    userName: json['user_name'],
    rating: json['rating'],
    comment: json['comment'],
    imageUrls: List<String>.from(json['image_urls'] ?? []),
    createdAt: DateTime.parse(json['created_at']),
  );
}
