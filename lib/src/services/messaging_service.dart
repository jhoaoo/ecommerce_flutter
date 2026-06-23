import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../core/app_collections.dart';
import '../core/firebase_bootstrapper.dart';
import '../models/models.dart';

class MessagingService {
  MessagingService({required this.firebase});

  final FirebaseBootstrapper firebase;

  Future<String?> registerDevice(String uid) async {
    if (!firebase.isConnected) return 'local-preview-token';
    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return null;
    await FirebaseFirestore.instance
        .collection(AppCollections.users)
        .doc(uid)
        .collection(AppCollections.fcmTokens)
        .doc(token)
        .set({
      'token': token,
      'platform': 'flutter',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return token;
  }

  NotificationItem simulated({
    required String title,
    required String message,
    required String type,
  }) {
    return NotificationItem(
      id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
    );
  }
}
