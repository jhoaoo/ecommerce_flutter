import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/app_role.dart';
import '../models/demo_data.dart';
import '../models/models.dart';
import '../repositories/ecommerce_repository.dart';

class AppController extends ChangeNotifier {
  AppController({required this.repository});

  final EcommerceRepository repository;

  AppUser? _currentUser;
  AppUser get currentUser => _currentUser ?? demoUsers.first;
  bool get isAuthenticated => _currentUser != null;

  List<Product> products = [];
  List<CategoryModel> categoryModels = [];
  List<AppUser> users = [];
  final List<CartItem> _cart = [];
  List<CustomerOrder> _orders = [];
  List<RoleRequest> _roleRequests = [];
  final List<NotificationItem> _notifications = [];

  String selectedCategory = 'Todos';
  String query = '';
  String language = 'Español';
  bool darkMode = false;
  bool isLoading = true;
  String? errorMessage;

  StreamSubscription<List<Product>>? _productsSub;
  StreamSubscription<List<CategoryModel>>? _categoriesSub;
  StreamSubscription<List<AppUser>>? _usersSub;
  StreamSubscription<List<CustomerOrder>>? _ordersSub;
  StreamSubscription<List<RoleRequest>>? _requestsSub;

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

  List<Product> get approvedProducts => products.where((product) => product.active && product.isApproved).toList();
  List<Product> get pendingProducts => products.where((product) => product.active && product.isPending).toList();
  List<Product> get sellerProducts => products.where((product) => product.sellerId == currentUser.id).toList();
  List<CustomerOrder> get visibleOrders {
    if (isAdmin) return orders;
    if (isSeller) return orders.where((order) => order.sellerIds.contains(currentUser.id)).toList();
    return orders.where((order) => order.userId == currentUser.id).toList();
  }

  int get sellerUnitsSold => visibleOrders.fold(0, (sum, order) {
        return sum + order.items.fold(0, (subtotal, item) => subtotal + item.quantity);
      });

  double get sellerRevenue => visibleOrders.fold(0, (sum, order) => sum + order.total);

  List<String> get categories => [
        'Todos',
        ...{for (final category in categoryModels) category.name},
        ...{for (final product in approvedProducts) product.category},
      ].toSet().toList();

  List<Product> get filteredProducts {
    final normalizedQuery = query.trim().toLowerCase();
    return approvedProducts.where((product) {
      final matchesCategory = selectedCategory == 'Todos' || product.category == selectedCategory;
      final matchesQuery = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> bootstrap() async {
    isLoading = true;
    notifyListeners();

    if (!repository.isConnected) {
      _currentUser = demoUsers.first;
      language = currentUser.language;
      darkMode = currentUser.darkMode;
      products = demoProducts;
      categoryModels = demoCategories;
      users = demoUsers;
      _notifications.add(NotificationItem(id: 'local', title: 'Modo local', message: 'La tienda se abrió con datos locales para pruebas de interfaz.', type: 'system', createdAt: DateTime.now()));
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final session = await repository.restoreSession();
      if (session != null) {
        _setCurrentUser(session);
        _bindRealtime();
      }
      errorMessage = null;
    } catch (_) {
      errorMessage = 'No se pudo cargar tu sesión. Inicia sesión nuevamente.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _runAuth(() => repository.signInWithEmail(email.trim(), password));
  }

  Future<void> registerWithEmail(String name, String email, String password) async {
    await _runAuth(() => repository.registerWithEmail(email.trim(), password, name.trim()));
  }

  Future<void> signInWithGoogle() async {
    await _runAuth(repository.signInWithGoogle);
  }

  Future<void> resetPassword(String email) async {
    await repository.resetPassword(email.trim());
    _notifications.insert(0, NotificationItem(id: 'reset-${DateTime.now().millisecondsSinceEpoch}', title: 'Correo enviado', message: 'Revisa tu bandeja para recuperar tu contraseña.', type: 'auth', createdAt: DateTime.now()));
    notifyListeners();
  }

  Future<void> _runAuth(Future<AppUser> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await action();
      _setCurrentUser(user);
      _bindRealtime();
      _notifications.insert(0, NotificationItem(id: 'signin-${DateTime.now().millisecondsSinceEpoch}', title: 'Sesión iniciada', message: 'Bienvenido a NovaMarket.', type: 'auth', createdAt: DateTime.now()));
    } catch (error) {
      errorMessage = _friendlyAuthError(error.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    await _cancelRealtime();
    _currentUser = null;
    products = [];
    categoryModels = [];
    users = [];
    _orders = [];
    _roleRequests = [];
    _cart.clear();
    errorMessage = null;
    notifyListeners();
  }

  Future<void> _cancelRealtime() async {
    await _productsSub?.cancel();
    await _categoriesSub?.cancel();
    await _usersSub?.cancel();
    await _ordersSub?.cancel();
    await _requestsSub?.cancel();
    _productsSub = null;
    _categoriesSub = null;
    _usersSub = null;
    _ordersSub = null;
    _requestsSub = null;
  }

  void _bindRealtime() {
    _cancelRealtime();

    _categoriesSub = repository.watchCategories().listen((value) {
      categoryModels = value;
      notifyListeners();
    }, onError: _handleRealtimeError);

    _productsSub = repository.watchProducts().listen((value) {
      products = value;
      notifyListeners();
    }, onError: _handleRealtimeError);

    _usersSub = repository.watchUsers().listen((value) {
      users = value;
      final match = value.where((user) => user.id == currentUser.id);
      if (match.isNotEmpty) _setCurrentUser(match.first, notify: false);
      notifyListeners();
    }, onError: _handleRealtimeError);

    _ordersSub = repository.watchOrders().listen((value) {
      _orders = value;
      notifyListeners();
    }, onError: _handleRealtimeError);

    _requestsSub = repository.watchRoleRequests().listen((value) {
      _roleRequests = value;
      notifyListeners();
    }, onError: _handleRealtimeError);
  }

  void _handleRealtimeError(Object error) {
    errorMessage = 'No se pudo sincronizar la tienda. Revisa las reglas de acceso del proyecto.';
    notifyListeners();
  }

  void _setCurrentUser(AppUser user, {bool notify = true}) {
    _currentUser = user;
    language = user.language;
    darkMode = user.darkMode;
    if (notify) notifyListeners();
  }

  Future<void> refresh() async {
    if (!isAuthenticated) return;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> requestRole(AppRole role, String reason) async {
    final request = await repository.requestRole(currentUser, role, reason);
    _roleRequests.insert(0, request);
    _notifications.insert(0, NotificationItem(id: 'request-${request.id}', title: 'Solicitud enviada', message: 'Tu solicitud para acceder como ${role.label} fue enviada para revisión.', type: 'role_request', createdAt: DateTime.now()));
    notifyListeners();
  }

  Future<void> approveRoleRequest(RoleRequest request) async {
    if (!isAdmin) return;
    final index = _roleRequests.indexWhere((item) => item.id == request.id);
    if (index != -1) _roleRequests[index] = request.copyWith(status: 'approved');
    final userIndex = users.indexWhere((user) => user.id == request.userId);
    if (userIndex != -1) {
      final updated = users[userIndex].copyWith(role: request.requestedRole);
      users[userIndex] = updated;
      await repository.saveUser(updated);
    }
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

  void setLanguage(String value) {
    language = value;
    final updated = currentUser.copyWith(language: value);
    _setCurrentUser(updated, notify: false);
    repository.saveUser(updated);
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    final updated = currentUser.copyWith(darkMode: value);
    _setCurrentUser(updated, notify: false);
    repository.saveUser(updated);
    notifyListeners();
  }

  void addToCart(Product product) {
    if (!product.isApproved || !product.active) return;
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _cart.add(CartItem(product: product, quantity: 1));
    } else {
      final current = _cart[index];
      if (current.quantity < product.stock) _cart[index] = current.copyWith(quantity: current.quantity + 1);
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
    final order = await repository.createOrder(user: currentUser, items: List.unmodifiable(_cart), totals: totals);
    _orders.insert(0, order);
    _cart.clear();
    _notifications.insert(0, NotificationItem(id: 'order-${order.id}', title: 'Compra realizada', message: 'Tu pedido ${order.id} fue registrado por S/ ${order.total.toStringAsFixed(2)}.', type: 'order', createdAt: DateTime.now()));
    notifyListeners();
    return order;
  }

  Future<void> saveProduct(Product product) async {
    if (!canManageProducts) return;
    final productForReview = isAdmin
        ? product.copyWith(approvalStatus: 'approved', active: true, rejectionReason: '')
        : product.copyWith(sellerId: currentUser.id, approvalStatus: 'pending', active: true, rejectionReason: '');
    await repository.saveProduct(productForReview);
    _replaceProduct(productForReview);
    notifyListeners();
  }

  Future<void> approveProduct(Product product) async {
    if (!isAdmin) return;
    final approved = product.copyWith(approvalStatus: 'approved', active: true, rejectionReason: '');
    await repository.saveProduct(approved);
    _replaceProduct(approved);
    notifyListeners();
  }

  Future<void> rejectProduct(Product product, {String reason = 'No cumple los requisitos de publicación.'}) async {
    if (!isAdmin) return;
    final rejected = product.copyWith(approvalStatus: 'rejected', active: false, rejectionReason: reason);
    await repository.saveProduct(rejected);
    _replaceProduct(rejected);
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    if (!isAdmin && product.sellerId != currentUser.id) return;
    await repository.deleteProduct(product.id);
    products.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void _replaceProduct(Product product) {
    final index = products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      products.insert(0, product);
    } else {
      products[index] = product;
    }
  }

  Future<void> saveCategory(CategoryModel category) async {
    if (!isAdmin) return;
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
    if (!isAdmin) return;
    await repository.seedDemoData();
  }

  Future<void> updateProfile({required String fullName, required String phone, required String address, required NotificationPreferences notifications}) async {
    final updated = currentUser.copyWith(fullName: fullName, phone: phone, address: address, notifications: notifications, language: language, darkMode: darkMode);
    _setCurrentUser(updated, notify: false);
    await repository.saveUser(updated);
    notifyListeners();
  }

  Future<void> addPaymentMethod(PaymentMethodProfile method) async {
    final methods = [
      ...currentUser.paymentMethods.where((item) => item.id != method.id),
      method,
    ];
    final updated = currentUser.copyWith(paymentMethods: methods);
    _setCurrentUser(updated, notify: false);
    await repository.saveUser(updated);
    notifyListeners();
  }

  Future<void> deletePaymentMethod(PaymentMethodProfile method) async {
    final updated = currentUser.copyWith(paymentMethods: currentUser.paymentMethods.where((item) => item.id != method.id).toList());
    _setCurrentUser(updated, notify: false);
    await repository.saveUser(updated);
    notifyListeners();
  }

  String _friendlyAuthError(String error) {
    if (error.contains('wrong-password') || error.contains('invalid-credential')) return 'Credenciales incorrectas.';
    if (error.contains('user-not-found')) return 'No existe una cuenta con ese correo.';
    if (error.contains('email-already-in-use')) return 'Ese correo ya está registrado.';
    if (error.contains('weak-password')) return 'Usa una contraseña más segura.';
    if (error.contains('permission-denied')) return 'No tienes permisos suficientes. Revisa las reglas de acceso.';
    return 'No se pudo completar la operación. Intenta nuevamente.';
  }

  @override
  void dispose() {
    _cancelRealtime();
    super.dispose();
  }
}
