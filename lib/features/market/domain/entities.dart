// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  List<Object> get props {
    return [
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
  }

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
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    discountPrice: (json['discount_price'] as num?)?.toDouble() ?? 0.0,
    imageUrl: json['image_url'] as String,
    additionalImages:
        (json['additional_images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    stockQuantity: json['stock_quantity'] as int,
    category: Category.fromJson(json['category'] as Map<String, dynamic>),
    isFeatured: json['is_featured'] as bool? ?? false,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    reviewCount: json['review_count'] as int? ?? 0,
  );

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? imageUrl,
    List<String>? additionalImages,
    int? stockQuantity,
    Category? category,
    bool? isFeatured,
    List<String>? tags,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
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
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    imageUrl: json['image_url'] as String,
  );

  Category copyWith({String? id, String? name, String? description, String? imageUrl}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool get stringify => true;
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
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    phoneNumber: json['phone_number'] as String,
    addresses:
        (json['addresses'] as List<dynamic>?)
            ?.map((a) => Address.fromJson(a as Map<String, dynamic>))
            .toList() ??
        [],
    profilePictureUrl: json['profile_picture_url'] as String?,
  );

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    List<Address>? addresses,
    String? profilePictureUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addresses: addresses ?? this.addresses,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  @override
  bool get stringify => true;
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
    id: json['id'] as String,
    street: json['street'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    country: json['country'] as String,
    postalCode: json['postal_code'] as String,
    label: json['label'] as String?,
    isDefault: json['is_default'] as bool? ?? false,
  );

  Address copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? label,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool get stringify => true;
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
    id: json['id'] as String,
    userId: json['user_id'] as String,
    items:
        (json['items'] as List<dynamic>)
            .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
            .toList(),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool get stringify => true;
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
    id: json['id'] as String,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
  );

  CartItem copyWith({String? id, Product? product, int? quantity}) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool get stringify => true;
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
    id: json['id'] as String,
    userId: json['user_id'] as String,
    items:
        (json['items'] as List<dynamic>)
            .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
            .toList(),
    shippingAddress: Address.fromJson(json['shipping_address'] as Map<String, dynamic>),
    billingAddress: Address.fromJson(json['billing_address'] as Map<String, dynamic>),
    subtotal: (json['subtotal'] as num).toDouble(),
    tax: (json['tax'] as num).toDouble(),
    shippingCost: (json['shipping_cost'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
    paymentMethod: json['payment_method'] as String,
    status: OrderStatus.values.byName(json['status'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    shippedAt:
        json['shipped_at'] != null ? DateTime.parse(json['shipped_at'] as String) : null,
    deliveredAt:
        json['delivered_at'] != null ? DateTime.parse(json['delivered_at'] as String) : null,
  );

  @override
  bool get stringify => true;
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
    id: json['id'] as String,
    productId: json['product_id'] as String,
    userId: json['user_id'] as String,
    userName: json['user_name'] as String,
    rating: (json['rating'] as num).toDouble(),
    comment: json['comment'] as String,
    imageUrls: (json['image_urls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Review copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    double? rating,
    String? comment,
    List<String>? imageUrls,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
