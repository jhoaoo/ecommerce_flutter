import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/src/controllers/app_controller.dart';
import 'package:ecommerce/src/core/app_role.dart';
import 'package:ecommerce/src/core/firebase_bootstrapper.dart';
import 'package:ecommerce/src/repositories/ecommerce_repository.dart';
import 'package:ecommerce/src/services/auth_service.dart';
import 'package:ecommerce/src/services/firestore_service.dart';
import 'package:ecommerce/src/services/messaging_service.dart';
import 'package:ecommerce/src/services/role_access_service.dart';
import 'package:ecommerce/src/services/storage_service.dart';

void main() {
  test('cart, role simulation and checkout logic work', () async {
    final firebase = FirebaseBootstrapper();
    final firestore = FirestoreService(firebase: firebase);
    final controller = AppController(
      repository: EcommerceRepository(
        firebase: firebase,
        authService: AuthService(firebase: firebase),
        firestoreService: firestore,
        storageService: StorageService(firebase: firebase),
        messagingService: MessagingService(firebase: firebase),
        roleAccessService: RoleAccessService(firestoreService: firestore),
      ),
    );

    await controller.bootstrap();
    expect(controller.products, isNotEmpty);

    await controller.switchDemoRole(AppRole.seller);
    expect(controller.currentUser.role, AppRole.seller);

    final product = controller.products.first;
    controller.addToCart(product);
    controller.addToCart(product);

    expect(controller.cartCount, 2);
    expect(controller.totals.total, greaterThan(0));

    final order = await controller.checkout();
    expect(order.total, greaterThan(0));
    expect(controller.cart, isEmpty);
    expect(controller.orders.length, 1);
  });
}
