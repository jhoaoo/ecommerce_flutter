import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/controllers/app_controller.dart';
import 'src/core/firebase_bootstrapper.dart';
import 'src/repositories/ecommerce_repository.dart';
import 'src/services/auth_service.dart';
import 'src/services/firestore_service.dart';
import 'src/services/messaging_service.dart';
import 'src/services/role_access_service.dart';
import 'src/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebase = FirebaseBootstrapper();
  await firebase.initialize();

  final firestore = FirestoreService(firebase: firebase);
  final repository = EcommerceRepository(
    firebase: firebase,
    authService: AuthService(firebase: firebase),
    firestoreService: firestore,
    storageService: StorageService(firebase: firebase),
    messagingService: MessagingService(firebase: firebase),
    roleAccessService: RoleAccessService(firestoreService: firestore),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppController(repository: repository)..bootstrap(),
      child: EcommerceApp(firebaseStatus: firebase.status),
    ),
  );
}
