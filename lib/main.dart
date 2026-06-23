import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/firebase_bootstrapper.dart';
import 'src/repositories.dart';
import 'src/shop_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebase = FirebaseBootstrapper();
  await firebase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ShopController(
        repository: FirebaseEcommerceRepository(firebase: firebase),
      )..bootstrap(),
      child: EcommerceApp(firebaseStatus: firebase.status),
    ),
  );
}
