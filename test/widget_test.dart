import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edu_snap/main.dart';
import 'package:edu_snap/pages/setting_page/setting_page_controller.dart';
import 'package:edu_snap/util/journal_repository.dart';
import 'package:edu_snap/util/locale_controller.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  setUp(() async {
    // Fresh storage for every test, then the demo entries are written back.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await JournalRepository.instance.reset();
    await LocaleController.instance.setLocale(const Locale('en'));
  });

  testWidgets('home page shows the stored journal list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    expect(find.text('EDU SNAP'), findsOneWidget);
    expect(find.text('Welcome to EDU SNAP'), findsOneWidget);
    expect(find.text('Session 3 notes'), findsOneWidget);
    expect(find.text('New entry'), findsOneWidget);
  });

  testWidgets('empty title shows an error instead of creating an entry', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New entry').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title before saving.'), findsOneWidget);
    expect(find.text('Title is required'), findsOneWidget);
  });

  testWidgets('adding an entry makes it appear on the home page', (
    WidgetTester tester,
  ) async {
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

  testWidgets('editing an entry from the detail page updates it', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Session 3 notes'));
    await tester.pumpAndSettle();
    expect(find.text('Entry'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).first,
      'Session 3 notes (edited)',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Session 3 notes (edited)'), findsOneWidget);
  });

  testWidgets('switching the language updates the UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await LocaleController.instance.setLocale(const Locale('zh'));
    await tester.pumpAndSettle();

    expect(find.text('新增日記'), findsOneWidget);
  });

  testWidgets('settings page reports the storage size and clears the data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Storage used'), findsOneWidget);
    expect(find.text('Clear all data'), findsOneWidget);

    await tester.tap(find.text('Clear all data'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Clear'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Clear'));
    await tester.pumpAndSettle();

    expect(find.text('All data has been cleared.'), findsOneWidget);

    final SettingPageController controller = SettingPageController();
    await controller.load();
    expect(JournalRepository.instance.entries, isEmpty);
    expect(controller.bytes, lessThan(200));
  });
}
