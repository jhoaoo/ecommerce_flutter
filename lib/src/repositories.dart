import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_bootstrapper.dart';
import 'models.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<void> seedDemoProducts();
}

abstract class OrderRepository {
  Future<CustomerOrder> createOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerEmail,
  });
}

class FirebaseProductRepository implements ProductRepository {
  FirebaseProductRepository({required this.firebase});

  final FirebaseBootstrapper firebase;

  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('products');

  @override
  Future<List<Product>> fetchProducts() async {
    if (!firebase.isConnected) return demoProducts;

    try {
      final snapshot = await _collection.orderBy('name').get();
      final products = snapshot.docs.map(Product.fromFirestore).toList();
      return products.isEmpty ? demoProducts : products;
    } catch (_) {
      return demoProducts;
    }
  }

  @override
  Future<void> seedDemoProducts() async {
    if (!firebase.isConnected) return;

    final batch = FirebaseFirestore.instance.batch();
    for (final product in demoProducts) {
      batch.set(
        _collection.doc(product.id),
        product.toFirestore(),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }
}

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository({required this.firebase});

  final FirebaseBootstrapper firebase;

  @override
  Future<CustomerOrder> createOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerEmail,
  }) async {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    final now = DateTime.now();

    if (!firebase.isConnected) {
      return CustomerOrder(
        id: 'LOCAL-${now.millisecondsSinceEpoch}',
        items: List.unmodifiable(items),
        total: total,
        customerName: customerName,
        customerEmail: customerEmail,
        createdAt: now,
        status: 'demo',
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    final payload = {
      'userId': user?.uid,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'status': 'pending',
      'paymentMethod': 'demo_checkout',
      'total': total,
      'items': items
          .map(
            (item) => {
              'productId': item.product.id,
              'name': item.product.name,
              'price': item.product.price,
              'quantity': item.quantity,
              'subtotal': item.subtotal,
            },
          )
          .toList(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    final doc = await FirebaseFirestore.instance.collection('orders').add(payload);
    return CustomerOrder(
      id: doc.id,
      items: List.unmodifiable(items),
      total: total,
      customerName: customerName,
      customerEmail: customerEmail,
      createdAt: now,
      status: 'pending',
    );
  }
}
