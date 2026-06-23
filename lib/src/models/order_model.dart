import 'cart_item.dart';

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
}
