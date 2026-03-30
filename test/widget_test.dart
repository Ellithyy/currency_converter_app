import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter_app/app/app.dart';
import 'package:currency_converter_app/app/di/injection.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    setupDependencies();
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
