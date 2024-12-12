import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglotte_translate/core/providers/connectivity_provider.dart';
import 'package:polyglotte_translate/core/providers/online_status_provider.dart';
import 'package:polyglotte_translate/core/theme/app_theme.dart';
import 'package:polyglotte_translate/features/translation/presentation/screens/translation_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialisiere den Online-Status-Listener
    ref.watch(onlineStatusListenerProvider);

    // Beobachte den Synchronisationsstatus
    final syncMessage = ref.watch(syncMessageProvider);

    return MaterialApp(
      title: 'Polyglotte Translate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Stack(
        children: [
          const TranslationScreen(),
          // Zeige Synchronisationsmeldung an
          if (syncMessage.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black87,
                  child: Text(
                    syncMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      builder: (context, child) {
        // Globales Error Handling
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Material(
            child: Container(
              color: Colors.red.shade900,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ein Fehler ist aufgetreten',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details.exception.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        };

        return child!;
      },
    );
  }
}
