import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglotte_translate/core/theme/app_theme.dart';
import 'package:polyglotte_translate/features/translation/presentation/screens/translation_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PolyglotteApp(),
    ),
  );
}

class PolyglotteApp extends ConsumerWidget {
  const PolyglotteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Polyglotte Translate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const TranslationScreen(),
    );
  }
}
