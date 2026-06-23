import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/src/models.dart';
import 'package:ecommerce/src/repositories.dart';
import 'package:ecommerce/src/shop_controller.dart';

class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> fetchProducts() async => demoProducts;

  @override
  Future<void> seedDemoProducts() async {}
}

class FakeOrderRepository implements OrderRepository {
  @override
  Future<CustomerOrder> createOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerEmail,
  }) async {
    final total = items.fold<double>(0, (value, item) => value + item.subtotal);
    return CustomerOrder(
      id: 'TEST-ORDER',
      items: items,
      total: total,
      customerName: customerName,
      customerEmail: customerEmail,
      createdAt: DateTime(2026),
      status: 'test',
    );
  }
}

void main() {
  test('cart and checkout logic works without Firebase', () async {
    final controller = ShopController(
      productRepository: FakeProductRepository(),
      orderRepository: FakeOrderRepository(),
    );

    await controller.loadProducts();
    final product = controller.products.first;
    controller.addToCart(product);
    controller.addToCart(product);

    expect(controller.cartCount, 2);
    expect(controller.cartTotal, product.price * 2);

    final order = await controller.checkout(
      customerName: 'Cliente Test',
      customerEmail: 'cliente@test.com',
    );

    expect(order.id, 'TEST-ORDER');
    expect(controller.cart, isEmpty);
    expect(controller.orders.length, 1);
  });
}
