import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:edu_snap/main.dart';
import 'package:edu_snap/util/journal_repository.dart';

void main() {
  setUp(() {
    // The repository is a singleton, so each test starts from the demo data.
    JournalRepository.instance.reset();
  });

  testWidgets('home page shows the journal list', (WidgetTester tester) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    expect(find.text('EDU SNAP'), findsOneWidget);
    expect(find.text('Welcome to EDU SNAP'), findsOneWidget);
    expect(find.text('Session 1 recap'), findsOneWidget);
    expect(find.text('New entry'), findsOneWidget);
  });

  testWidgets('empty title shows an error instead of creating an entry',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New entry').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title before saving.'), findsOneWidget);
    expect(find.text('Title is required'), findsOneWidget);
  });

  testWidgets('adding an entry makes it appear on the home page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New entry').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Zebra notes');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Sorted by title descending, so "Zebra notes" comes first.
    expect(find.text('Zebra notes'), findsOneWidget);
  });

  testWidgets('editing an entry from the detail page updates it',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Session 1 recap'));
    await tester.pumpAndSettle();
    expect(find.text('Entry'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Session 1 recap (edited)');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Session 1 recap (edited)'), findsOneWidget);
  });
}
