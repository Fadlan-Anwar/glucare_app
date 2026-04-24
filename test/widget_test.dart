import 'package:flutter_test/flutter_test.dart';
import 'package:glucare_app/main.dart'; 

void main() {
  testWidgets('Cek tampilan awal', (WidgetTester tester) async {
    await tester.pumpWidget(const GluCareApp());
    expect(find.text('GluCare'), findsWidgets);
  });
}