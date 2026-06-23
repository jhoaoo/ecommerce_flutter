
import '../core/app_collections.dart';
import '../core/app_role.dart';
import '../core/firebase_bootstrapper.dart';
import '../models/demo_data.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/messaging_service.dart';
import '../services/role_access_service.dart';
import '../services/storage_service.dart';

class EcommerceRepository {
  EcommerceRepository({
    required this.firebase,
    required this.authService,
    required this.firestoreService,
    required this.storageService,
    required this.messagingService,
    required this.roleAccessService,
  });

  final FirebaseBootstrapper firebase;
  final AuthService authService;
  final FirestoreService firestoreService;
  final StorageService storageService;
  final MessagingService messagingService;
  final RoleAccessService roleAccessService;

  Future<AppUser> signInDemo(AppRole role) async => authService.demoUserForRole(role);

  Future<AppUser> signInWithEmail(String email, String password) async {
    final credential = await authService.signInWithEmail(email, password);
    if (credential?.user == null) return authService.demoUserForRole(AppRole.customer);
    return _profileFromAuthUser(credential!.user!);
  }

  Future<AppUser> registerWithEmail(String email, String password, String fullName) async {
    final credential = await authService.registerWithEmail(email, password, fullName);
    if (credential?.user == null) {
      return authService.demoUserForRole(AppRole.customer).copyWith(email: email, fullName: fullName);
    }
    final user = _profileFromAuthUser(credential!.user!);
    await saveUser(user);
    return user;
  }

  Future<AppUser> signInWithGoogle() async {
    final credential = await authService.signInWithGoogle();
    if (credential?.user == null) return authService.demoUserForRole(AppRole.customer);
    final user = _profileFromAuthUser(credential!.user!);
    await saveUser(user);
    return user;
  }

  Future<void> signOut() => authService.signOut();
  Future<void> resetPassword(String email) => authService.sendPasswordReset(email);

  Future<List<CategoryModel>> fetchCategories() async {
    final docs = await firestoreService.getAll(AppCollections.categories);
    if (docs.isEmpty) return demoCategories;
    return docs.map(CategoryModel.fromFirestore).toList();
  }

  Future<List<Product>> fetchProducts() async {
    final docs = await firestoreService.getAll(AppCollections.products);
    if (docs.isEmpty) return demoProducts;
    return docs.map(Product.fromFirestore).where((product) => product.active).toList();
  }

  Future<List<AppUser>> fetchUsers() async {
    final docs = await firestoreService.getAll(AppCollections.users);
    if (docs.isEmpty) return demoUsers;
    return docs.map(AppUser.fromFirestore).toList();
  }

  Future<void> saveUser(AppUser user) => firestoreService.setDocument(AppCollections.users, user.id, user.toFirestore());

  Future<void> saveCategory(CategoryModel category) {
    return firestoreService.setDocument(AppCollections.categories, category.id, category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) => firestoreService.deleteDocument(AppCollections.categories, categoryId);

  Future<void> saveProduct(Product product) {
    return firestoreService.setDocument(AppCollections.products, product.id, product.toFirestore());
  }

  Future<void> deleteProduct(String productId) => firestoreService.deleteDocument(AppCollections.products, productId);

  Future<CustomerOrder> createOrder({
    required AppUser user,
    required List<CartItem> items,
    required CartTotals totals,
  }) async {
    final id = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final sellerIds = items.map((item) => item.product.sellerId).toSet().toList();

    final order = CustomerOrder(
      id: id,
      userId: user.id,
      sellerIds: sellerIds,
      items: List.unmodifiable(items),
      subtotal: totals.subtotal,
      discount: totals.discount,
      tax: totals.tax,
      shipping: totals.shipping,
      total: totals.total,
      customerName: user.fullName,
      customerEmail: user.email,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    await firestoreService.createOrderAndUpdateStock(
      orderId: id,
      orderData: {
        'userId': user.id,
        'customerName': user.fullName,
        'customerEmail': user.email,
        'sellerIds': sellerIds,
        'status': 'pending',
        ...totals.toMap(),
        'items': items
            .map((item) => {
                  'productId': item.product.id,
                  'name': item.product.name,
                  'price': item.product.price,
                  'quantity': item.quantity,
                  'subtotal': item.subtotal,
                  'discount': item.discount,
                  'tax': item.tax,
                  'total': item.total,
                })
            .toList(),
      },
      stockDeltaByProductId: {for (final item in items) item.product.id: item.quantity},
    );

    return order;
  }

  Future<RoleRequest> requestRole(AppUser user, AppRole role, String reason) {
    return roleAccessService.requestRole(user: user, requestedRole: role, reason: reason);
  }

  Future<String?> registerDeviceForNotifications(String uid) => messagingService.registerDevice(uid);

  Future<void> seedDemoData() async {
    for (final category in demoCategories) {
      await saveCategory(category);
    }
    for (final product in demoProducts) {
      await saveProduct(product);
    }
    for (final user in demoUsers) {
      await saveUser(user);
    }
  }

  AppUser _profileFromAuthUser(dynamic user) {
    return AppUser(
      id: user.uid.toString(),
      email: user.email?.toString() ?? '',
      fullName: user.displayName?.toString() ?? 'Usuario ecommerce',
      role: AppRole.customer,
      phone: '',
      address: '',
      photoUrl: user.photoURL?.toString() ?? '',
      paymentMethods: const [],
      notifications: NotificationPreferences.defaults(),
      createdAt: DateTime.now(),
      demo: false,
    );
  }
}

