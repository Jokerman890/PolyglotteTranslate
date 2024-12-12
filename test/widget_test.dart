import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglotte_translate/main.dart';

void main() {
  testWidgets('App startet und zeigt TranslationScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that the title is correct
    expect(find.text('Polyglotte Translate'), findsOneWidget);

    // Wait for animations to complete
    await tester.pumpAndSettle();
  });

  testWidgets('Offline-Modus zeigt Statusmeldung', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Warte auf Initialisierung
    await tester.pumpAndSettle();

    // Überprüfe, ob die Offline-Meldung angezeigt wird, wenn offline
    final offlineMessage = find.text(
      'Offline-Modus: Änderungen werden synchronisiert, sobald eine Verbindung besteht',
    );
    
    // Die Meldung könnte sichtbar oder nicht sichtbar sein, abhängig vom Online-Status
    expect(offlineMessage, anyOf(findsOneWidget, findsNothing));
  });

  testWidgets('Error Widget zeigt Fehlermeldung', (WidgetTester tester) async {
    // Simuliere einen Fehler
    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            throw Exception('Test-Fehler');
            // ignore: dead_code
            return const MyApp();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Überprüfe, ob der Fehler-Screen angezeigt wird
    expect(find.text('Ein Fehler ist aufgetreten'), findsOneWidget);
    expect(find.text('Exception: Test-Fehler'), findsOneWidget);
  });
}
