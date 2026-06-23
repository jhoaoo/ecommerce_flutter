import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/main.dart' as app;

void main() {
  testWidgets('app starts without crashing', (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.text('Ecommerce Flutter'), findsOneWidget);
  });
}
