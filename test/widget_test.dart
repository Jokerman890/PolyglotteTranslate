import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglotte_translate/main.dart';

void main() {
  testWidgets('App startet und zeigt Übersetzungsbildschirm', (WidgetTester tester) async {
    await tester.pumpWidget(const PolyglotteApp());

    expect(find.text('Polyglotte Translate'), findsOneWidget);
  });
}
