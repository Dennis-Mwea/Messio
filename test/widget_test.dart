import 'package:flutter_test/flutter_test.dart';

import 'package:messio/main.dart';

void main() {
  testWidgets('Check if hello world shows up', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Messio());

    expect(find.text("Hello Dennis!"), findsOneWidget);
  });
}
