import 'product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;
  double get discount => product.discountAmount * quantity;
  double get tax => product.taxAmount * quantity;
  double get total => product.finalPrice * quantity;

  CartItem copyWith({Product? product, int? quantity}) => CartItem(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );
}

class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.shipping,
    required this.total,
  });

  final double subtotal;
  final double discount;
  final double tax;
  final double shipping;
  final double total;

  factory CartTotals.fromItems(List<CartItem> items, {double shipping = 0}) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    final discount = items.fold<double>(0, (sum, item) => sum + item.discount);
    final tax = items.fold<double>(0, (sum, item) => sum + item.tax);
    return CartTotals(
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      shipping: shipping,
      total: subtotal - discount + tax + shipping,
    );
  }

  Map<String, dynamic> toMap() => {
        'subtotal': subtotal,
        'discount': discount,
        'tax': tax,
        'shipping': shipping,
        'total': total,
      };
}
