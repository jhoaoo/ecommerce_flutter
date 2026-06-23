import 'package:flutter/foundation.dart';

import 'models.dart';
import 'repositories.dart';

class ShopController extends ChangeNotifier {
  ShopController({
    required ProductRepository productRepository,
    required OrderRepository orderRepository,
  })  : _productRepository = productRepository,
        _orderRepository = orderRepository;

  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;
  final List<CartItem> _cart = [];
  final List<CustomerOrder> _orders = [];

  List<Product> products = [];
  String selectedCategory = 'Todos';
  String query = '';
  bool isLoading = true;
  String? errorMessage;

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<CustomerOrder> get orders => List.unmodifiable(_orders);
  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.subtotal);
  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  List<String> get categories => [
        'Todos',
        ...{for (final product in products) product.category},
      ];

  List<Product> get filteredProducts {
    final normalizedQuery = query.trim().toLowerCase();
    return products.where((product) {
      final matchesCategory = selectedCategory == 'Todos' || product.category == selectedCategory;
      final matchesQuery = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await _productRepository.fetchProducts();
    } catch (_) {
      errorMessage = 'No se pudieron cargar los productos.';
      products = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> seedDemoProducts() async {
    await _productRepository.seedDemoProducts();
    await loadProducts();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void addToCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _cart.add(CartItem(product: product, quantity: 1));
    } else {
      final current = _cart[index];
      if (current.quantity < product.stock) {
        _cart[index] = current.copyWith(quantity: current.quantity + 1);
      }
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) return;

    final current = _cart[index];
    if (current.quantity <= 1) {
      _cart.removeAt(index);
    } else {
      _cart[index] = current.copyWith(quantity: current.quantity - 1);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  Future<CustomerOrder> checkout({
    required String customerName,
    required String customerEmail,
  }) async {
    if (_cart.isEmpty) throw StateError('El carrito está vacío.');

    final order = await _orderRepository.createOrder(
      items: List.unmodifiable(_cart),
      customerName: customerName,
      customerEmail: customerEmail,
    );
    _orders.insert(0, order);
    _cart.clear();
    notifyListeners();
    return order;
  }
}
