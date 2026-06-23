import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static const ownerEmails = {'jhoaoollerena@gmail.com'};

  final FirebaseBootstrapper firebase;
  final AuthService authService;
  final FirestoreService firestoreService;
  final StorageService storageService;
  final MessagingService messagingService;
  final RoleAccessService roleAccessService;

  bool get isConnected => firebase.isConnected;
  User? get currentFirebaseUser => authService.currentFirebaseUser;

  Future<AppUser?> restoreSession() async {
    final user = currentFirebaseUser;
    if (user == null) return null;
    return _ensureUserProfile(user);
  }

  Future<AppUser> signInDemo(AppRole role) async => authService.demoUserForRole(role);

  Future<AppUser> signInWithEmail(String email, String password) async {
    final credential = await authService.signInWithEmail(email, password);
    if (credential?.user == null) return authService.demoUserForRole(AppRole.customer);
    return _ensureUserProfile(credential!.user!);
  }

  Future<AppUser> registerWithEmail(String email, String password, String fullName) async {
    final credential = await authService.registerWithEmail(email, password, fullName);
    if (credential?.user == null) return authService.demoUserForRole(AppRole.customer).copyWith(email: email, fullName: fullName);
    return _ensureUserProfile(credential!.user!, fallbackName: fullName);
  }

  Future<AppUser> signInWithGoogle() async {
    final credential = await authService.signInWithGoogle();
    if (credential?.user == null) return authService.demoUserForRole(AppRole.customer);
    return _ensureUserProfile(credential!.user!);
  }

  Future<void> signOut() => authService.signOut();
  Future<void> resetPassword(String email) => authService.sendPasswordReset(email);

  Stream<List<CategoryModel>> watchCategories() {
    if (!isConnected) return Stream.value(demoCategories);
    return firestoreService.watchAll(AppCollections.categories).map((docs) => docs.map(CategoryModel.fromFirestore).where((category) => category.active).toList());
  }

  Stream<List<Product>> watchProducts() {
    if (!isConnected) return Stream.value(demoProducts);
    return firestoreService.watchAll(AppCollections.products).map((docs) => docs.map(Product.fromFirestore).where((product) => product.active).toList());
  }

  Stream<List<AppUser>> watchUsers() {
    if (!isConnected) return Stream.value(demoUsers);
    return firestoreService.watchAll(AppCollections.users).map((docs) => docs.map(AppUser.fromFirestore).toList());
  }

  Stream<List<RoleRequest>> watchRoleRequests() {
    if (!isConnected) return const Stream<List<RoleRequest>>.empty();
    return firestoreService.watchAll(AppCollections.roleRequests).map((docs) => docs.map(RoleRequest.fromFirestore).toList());
  }

  Stream<List<CustomerOrder>> watchOrdersFor(AppUser user) {
    if (!isConnected) return const Stream<List<CustomerOrder>>.empty();
    Query<Map<String, dynamic>> query = firestoreService.collection(AppCollections.orders);
    if (user.role == AppRole.admin) {
      query = firestoreService.collection(AppCollections.orders);
    } else if (user.role == AppRole.seller) {
      query = query.where('sellerIds', arrayContains: user.id);
    } else {
      query = query.where('userId', isEqualTo: user.id);
    }
    return query.snapshots().map((snapshot) => snapshot.docs.map(CustomerOrder.fromFirestore).toList());
  }

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

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await firestoreService.getDocument(AppCollections.users, uid);
    if (doc == null || !doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<void> saveUser(AppUser user) => firestoreService.setDocument(AppCollections.users, user.id, user.toFirestore());
  Future<void> saveCategory(CategoryModel category) => firestoreService.setDocument(AppCollections.categories, category.id, category.toFirestore());
  Future<void> deleteCategory(String categoryId) => firestoreService.deleteDocument(AppCollections.categories, categoryId);
  Future<void> saveProduct(Product product) => firestoreService.setDocument(AppCollections.products, product.id, product.toFirestore());
  Future<void> deleteProduct(String productId) => firestoreService.deleteDocument(AppCollections.products, productId);

  Future<CustomerOrder> createOrder({required AppUser user, required List<CartItem> items, required CartTotals totals}) async {
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
        'items': items.map((item) => {
          'productId': item.product.id,
          'sellerId': item.product.sellerId,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
          'subtotal': item.subtotal,
          'discount': item.discount,
          'tax': item.tax,
          'total': item.total,
        }).toList(),
      },
      stockDeltaByProductId: {for (final item in items) item.product.id: item.quantity},
    );
    return order;
  }

  Future<RoleRequest> requestRole(AppUser user, AppRole role, String reason) => roleAccessService.requestRole(user: user, requestedRole: role, reason: reason);
  Future<String?> registerDeviceForNotifications(String uid) => messagingService.registerDevice(uid);

  Future<void> seedDemoData() async {
    for (final category in demoCategories) {
      await saveCategory(category);
    }
    for (final product in demoProducts) {
      await saveProduct(product.copyWith(approvalStatus: 'approved', active: true));
    }
  }

  Future<AppUser> _ensureUserProfile(User user, {String? fallbackName}) async {
    final existing = await getUserProfile(user.uid);
    if (existing != null) return existing;
    final email = user.email?.toLowerCase().trim() ?? '';
    final appUser = AppUser(
      id: user.uid,
      email: email,
      fullName: user.displayName?.trim().isNotEmpty == true ? user.displayName!.trim() : (fallbackName?.trim().isNotEmpty == true ? fallbackName!.trim() : 'Usuario NovaMarket'),
      role: ownerEmails.contains(email) ? AppRole.admin : AppRole.customer,
      phone: '',
      address: '',
      photoUrl: user.photoURL?.toString() ?? '',
      paymentMethods: const [],
      notifications: NotificationPreferences.defaults(),
      createdAt: DateTime.now(),
      demo: false,
      language: 'Español',
      darkMode: false,
    );
    await saveUser(appUser);
    return appUser;
  }
}
