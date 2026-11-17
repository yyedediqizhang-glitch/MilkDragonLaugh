import 'package:flutter_test/flutter_test.dart';

import 'package:edu_snap/main.dart';

void main() {
  testWidgets('landing page shows the app name and opens the home page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EduSnapApp());

    expect(find.text('EDU SNAP'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Ricardo'), findsOneWidget);
    expect(find.text('Add snap'), findsOneWidget);
  });
}
