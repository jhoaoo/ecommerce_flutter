import 'package:flutter/foundation.dart';

import '../core/app_role.dart';
import '../models/demo_data.dart';
import '../models/models.dart';
import '../repositories/ecommerce_repository.dart';

class AppController extends ChangeNotifier {
  AppController({required this.repository});

  final EcommerceRepository repository;

  AppUser currentUser = demoUsers.first;
  AppRole previewRole = AppRole.customer;

  List<Product> products = [];
  List<CategoryModel> categoryModels = [];
  List<AppUser> users = [];
  final List<CartItem> _cart = [];
  final List<CustomerOrder> _orders = [];
  final List<RoleRequest> _roleRequests = [];
  final List<NotificationItem> _notifications = [];

  String selectedCategory = 'Todos';
  String query = '';
  bool isLoading = true;
  String? errorMessage;

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<CustomerOrder> get orders => List.unmodifiable(_orders);
  List<RoleRequest> get roleRequests => List.unmodifiable(_roleRequests);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  CartTotals get totals => CartTotals.fromItems(_cart);
  double get cartTotal => totals.total;
  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  bool get isAdmin => currentUser.role == AppRole.admin;
  bool get isSeller => currentUser.role == AppRole.seller;
  bool get canManageProducts => currentUser.role.canManageProducts;

  List<String> get categories => [
        'Todos',
        ...{for (final category in categoryModels) category.name},
        ...{for (final product in products) product.category},
      ].toSet().toList();

  List<Product> get filteredProducts {
    final normalizedQuery = query.trim().toLowerCase();
    return products.where((product) {
      final matchesCategory = selectedCategory == 'Todos' || product.category == selectedCategory;
      final matchesQuery = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);
      return product.active && matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> bootstrap() async {
    isLoading = true;
    notifyListeners();
    try {
      currentUser = await repository.signInDemo(AppRole.customer);
      await _loadAll();
      _notifications.add(
        NotificationItem(
          id: 'welcome',
          title: 'Sistema listo',
          message: 'Puedes probar como usuario, vendedor o admin en cloud simulation.',
          type: 'system',
          createdAt: DateTime.now(),
        ),
      );
    } catch (error) {
      errorMessage = 'No se pudo iniciar el ecommerce: $error';
      products = demoProducts;
      categoryModels = demoCategories;
      users = demoUsers;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAll() async {
    categoryModels = await repository.fetchCategories();
    products = await repository.fetchProducts();
    users = await repository.fetchUsers();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();
    await _loadAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> switchDemoRole(AppRole role) async {
    previewRole = role;
    currentUser = await repository.signInDemo(role);
    _notifications.insert(
      0,
      NotificationItem(
        id: 'role-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Rol activo: ${role.label}',
        message: 'Modo cloud simulation para probar paneles y permisos.',
        type: 'role',
        targetRole: role,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> signInWithGoogleSimulation() async {
    currentUser = await repository.signInWithGoogle();
    _notifications.insert(
      0,
      NotificationItem(
        id: 'google-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Sesión iniciada',
        message: 'Google Sign-In real si Firebase está configurado; fallback demo si no.',
        type: 'auth',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> requestRole(AppRole role, String reason) async {
    final request = await repository.requestRole(currentUser, role, reason);
    _roleRequests.insert(0, request);
    _notifications.insert(
      0,
      NotificationItem(
        id: 'request-${request.id}',
        title: 'Solicitud enviada',
        message: 'Se solicitó acceso como ${role.label}.',
        type: 'role_request',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void approveRoleRequest(RoleRequest request) {
    final index = _roleRequests.indexWhere((item) => item.id == request.id);
    if (index != -1) _roleRequests[index] = request.copyWith(status: 'approved');
    final userIndex = users.indexWhere((user) => user.id == request.userId);
    if (userIndex != -1) users[userIndex] = users[userIndex].copyWith(role: request.requestedRole);
    notifyListeners();
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

  Future<CustomerOrder> checkout() async {
    if (_cart.isEmpty) throw StateError('El carrito está vacío.');
    final order = await repository.createOrder(
      user: currentUser,
      items: List.unmodifiable(_cart),
      totals: totals,
    );
    _orders.insert(0, order);
    _cart.clear();
    _notifications.insert(
      0,
      NotificationItem(
        id: 'order-${order.id}',
        title: 'Pedido creado',
        message: 'Pedido ${order.id} creado por S/ ${order.total.toStringAsFixed(2)}.',
        type: 'order',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return order;
  }

  Future<void> saveProduct(Product product) async {
    await repository.saveProduct(product);
    final index = products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      products.insert(0, product);
    } else {
      products[index] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    await repository.deleteProduct(product.id);
    products.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  Future<void> saveCategory(CategoryModel category) async {
    await repository.saveCategory(category);
    final index = categoryModels.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      categoryModels.add(category);
    } else {
      categoryModels[index] = category;
    }
    notifyListeners();
  }

  Future<void> seedDemoData() async {
    await repository.seedDemoData();
    await refresh();
  }

  void updateProfile({
    required String fullName,
    required String phone,
    required String address,
    required NotificationPreferences notifications,
  }) {
    currentUser = currentUser.copyWith(
      fullName: fullName,
      phone: phone,
      address: address,
      notifications: notifications,
    );
    notifyListeners();
  }
}
