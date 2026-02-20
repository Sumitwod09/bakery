import 'package:flutter_test/flutter_test.dart';
import 'package:bakery_web/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BakeryApp());
    expect(find.byType(BakeryApp), findsOneWidget);
  });
}
