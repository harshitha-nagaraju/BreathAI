import 'package:flutter_test/flutter_test.dart';
import 'package:breatheai_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {

    await tester.pumpWidget(const BreatheAIApp());

    expect(find.text('BreatheAI'), findsWidgets);

  });
}