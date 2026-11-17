import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edu_snap/main.dart';
import 'package:edu_snap/models/journal_entry.dart';
import 'package:edu_snap/util/duo_layout_service.dart';
import 'package:edu_snap/util/journal_repository.dart';
import 'package:edu_snap/util/local_storage.dart';
import 'package:edu_snap/util/locale_controller.dart';

/// A 1x1 transparent PNG, used to prove that photo data travels with an entry.
const String _tinyPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    PackageInfo.setMockInitialValues(
      appName: 'EDU SNAP',
      packageName: 'edu_snap',
      version: '1.1.0',
      buildNumber: '2',
      buildSignature: '',
      installerStore: null,
    );
    await JournalRepository.instance.reset();
    await LocaleController.instance.setLocale(const Locale('en'));
  });

  group('CRUD', () {
    testWidgets('read: list and detail show the stored entry', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const EduSnapApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Session 3 notes'));
      await tester.pumpAndSettle();

      expect(find.text('Entry'), findsOneWidget);
      expect(find.text('Session 3 notes'), findsOneWidget);
      expect(find.textContaining('Created'), findsOneWidget);
    });

    testWidgets('delete: swipe left, confirm, entry disappears', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const EduSnapApp());
      await tester.pumpAndSettle();

      await tester.drag(find.text('Session 3 notes'), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(find.text('Delete entry?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Session 3 notes'), findsNothing);
      expect(JournalRepository.instance.entries.length, 1);
    });

    testWidgets('sort: new entries are ordered by title, descending', (
      WidgetTester tester,
    ) async {
      JournalRepository.instance.add(title: 'Apple', notes: 'a');
      JournalRepository.instance.add(title: 'Zebra', notes: 'z');

      await tester.pumpWidget(const EduSnapApp());
      await tester.pumpAndSettle();

      final double zebra = tester.getTopLeft(find.text('Zebra')).dy;
      final double apple = tester.getTopLeft(find.text('Apple')).dy;
      final double welcome = tester.getTopLeft(
        find.text('Welcome to EDU SNAP'),
      ).dy;

      // Z > W > S > A  (S = "Session 3 notes")
      expect(zebra, lessThan(welcome));
      expect(welcome, lessThan(apple));
    });

    testWidgets('empty state appears when there are no entries', (
      WidgetTester tester,
    ) async {
      await JournalRepository.instance.clearAll();

      await tester.pumpWidget(const EduSnapApp());
      await tester.pumpAndSettle();

      expect(find.text('Your journal is empty'), findsOneWidget);
      expect(find.text('New entry'), findsWidgets);
    });
  });

  group('photos', () {
    testWidgets('an entry with photo data renders an image in list and detail', (
      WidgetTester tester,
    ) async {
      JournalRepository.instance.add(
        title: 'With photo',
        notes: 'has an image',
        imageBase64: _tinyPng,
      );

      await tester.pumpWidget(const EduSnapApp());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.text('With photo'));
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });

    test('photo bytes count towards the stored size', () async {
      final int before = await LocalStorage.instance.storageSizeBytes();
      JournalRepository.instance.add(
        title: 'Photo size',
        notes: '',
        imageBase64: _tinyPng,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final int after = await LocalStorage.instance.storageSizeBytes();
      expect(after, greaterThan(before + 80));
    });
  });

  group('storage', () {
    test('entries survive a reload from local storage', () async {
      JournalRepository.instance.add(title: 'Persisted', notes: 'round trip');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await JournalRepository.instance.load();

      final bool found = JournalRepository.instance.entries.any(
        (JournalEntry entry) => entry.title == 'Persisted',
      );
      expect(found, isTrue);
    });

    test('clearAll removes entries, size and language preference', () async {
      await JournalRepository.instance.clearAll();

      expect(JournalRepository.instance.entries, isEmpty);
      expect(await LocalStorage.instance.storageSizeBytes(), 0);
      expect(await LocalStorage.instance.loadLanguageCode(), isNull);
    });
  });

  group('layout', () {
    test('two-pane layout only on wide windows / open Duo', () {
      final DuoLayoutService duo = DuoLayoutService.instance;

      expect(duo.wantsTwoPanes(const Size(430, 900)), isFalse);
      expect(duo.wantsTwoPanes(const Size(1200, 800)), isTrue);
    });
  });
}
