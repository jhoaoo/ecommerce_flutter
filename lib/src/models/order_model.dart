import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';
import 'product.dart';

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.customerName,
    required this.customerEmail,
    required this.createdAt,
    required this.status,
    this.userId = 'demo-customer',
    this.sellerIds = const [],
    this.subtotal = 0,
    this.discount = 0,
    this.tax = 0,
    this.shipping = 0,
  });

  final String id;
  final List<CartItem> items;
  final double total;
  final String customerName;
  final String customerEmail;
  final DateTime createdAt;
  final String status;
  final String userId;
  final List<String> sellerIds;
  final double subtotal;
  final double discount;
  final double tax;
  final double shipping;

  factory CustomerOrder.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawItems = data['items'] as List<dynamic>? ?? [];
    final items = rawItems.whereType<Map>().map((entry) {
      final item = Map<String, dynamic>.from(entry);
      final price = _readDouble(item['price']);
      final quantity = _readInt(item['quantity'], fallback: 1);
      final product = Product(
        id: item['productId']?.toString() ?? '',
        name: item['name']?.toString() ?? 'Producto',
        description: '',
        category: '',
        price: price,
        stock: quantity,
        imageUrl: '',
        rating: 0,
        isFeatured: false,
        sellerId: item['sellerId']?.toString() ?? '',
      );
      return CartItem(product: product, quantity: quantity);
    }).toList();

    return CustomerOrder(
      id: doc.id,
      items: items,
      total: _readDouble(data['total']),
      customerName: data['customerName']?.toString() ?? '',
      customerEmail: data['customerEmail']?.toString() ?? '',
      createdAt: _readDate(data['createdAt']),
      status: data['status']?.toString() ?? 'pending',
      userId: data['userId']?.toString() ?? '',
      sellerIds: (data['sellerIds'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(),
      subtotal: _readDouble(data['subtotal']),
      discount: _readDouble(data['discount']),
      tax: _readDouble(data['tax']),
      shipping: _readDouble(data['shipping']),
    );
  }

  CustomerOrder copyWith({String? status}) {
    return CustomerOrder(
      id: id,
      items: items,
      total: total,
      customerName: customerName,
      customerEmail: customerEmail,
      createdAt: createdAt,
      status: status ?? this.status,
      userId: userId,
      sellerIds: sellerIds,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      shipping: shipping,
    );
  }

  static DateTime _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  static double _readDouble(Object? value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
