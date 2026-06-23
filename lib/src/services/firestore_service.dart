import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_collections.dart';
import '../core/firebase_bootstrapper.dart';

class FirestoreService {
  FirestoreService({required this.firebase});

  final FirebaseBootstrapper firebase;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) => _db.collection(path);

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> watchAll(String collectionPath) {
    if (!firebase.isConnected) return Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>.empty();
    return collection(collectionPath).snapshots().map((snapshot) => snapshot.docs);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAll(String collectionPath) async {
    if (!firebase.isConnected) return [];
    final snapshot = await collection(collectionPath).get();
    return snapshot.docs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument(String collectionPath, String id) async {
    if (!firebase.isConnected) return null;
    return collection(collectionPath).doc(id).get();
  }

  Future<void> setDocument(String collectionPath, String id, Map<String, dynamic> data) async {
    if (!firebase.isConnected) return;
    await collection(collectionPath).doc(id).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> addDocument(String collectionPath, Map<String, dynamic> data) async {
    if (!firebase.isConnected) return 'LOCAL-${DateTime.now().millisecondsSinceEpoch}';
    final doc = collection(collectionPath).doc();
    await doc.set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> deleteDocument(String collectionPath, String id) async {
    if (!firebase.isConnected) return;
    await collection(collectionPath).doc(id).delete();
  }

  Future<void> createOrderAndUpdateStock({
    required String orderId,
    required Map<String, dynamic> orderData,
    required Map<String, int> stockDeltaByProductId,
  }) async {
    if (!firebase.isConnected) return;
    final batch = _db.batch();
    batch.set(collection(AppCollections.orders).doc(orderId), {
      ...orderData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    stockDeltaByProductId.forEach((productId, quantity) {
      batch.update(collection(AppCollections.products).doc(productId), {
        'stock': FieldValue.increment(-quantity),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
    await batch.commit();
  }
}
