import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglotte_translate/core/config/app_config.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // TODO: Hier Initialisierungslogik implementieren
    // z.B. Prüfen des Auth-Status, Laden von Konfigurationen, etc.
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // TODO: Navigation zur entsprechenden Seite implementieren
      // Beispiel:
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: App-Logo hier einfügen
              const Icon(
                Icons.translate,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                AppConfig.appName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
