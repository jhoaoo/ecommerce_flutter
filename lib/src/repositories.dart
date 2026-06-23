import 'core/app_role.dart';
import 'models.dart';
import 'repositories/ecommerce_repository.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<void> seedDemoProducts();
  Future<void> saveProduct(Product product);
  Future<void> deleteProduct(String productId);
}

abstract class OrderRepository {
  Future<CustomerOrder> createOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerEmail,
  });
}

class FirebaseProductRepository implements ProductRepository {
  FirebaseProductRepository({required this.repository});

  final EcommerceRepository repository;

  @override
  Future<List<Product>> fetchProducts() => repository.fetchProducts();

  @override
  Future<void> seedDemoProducts() => repository.seedDemoData();

  @override
  Future<void> saveProduct(Product product) => repository.saveProduct(product);

  @override
  Future<void> deleteProduct(String productId) => repository.deleteProduct(productId);
}

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository({required this.repository});

  final EcommerceRepository repository;

  @override
  Future<CustomerOrder> createOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerEmail,
  }) async {
    final user = repository.authService.demoUserForRole(AppRole.customer).copyWith(
          fullName: customerName,
          email: customerEmail,
        );
    return repository.createOrder(user: user, items: items, totals: CartTotals.fromItems(items));
  }
}
