import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider für den Connectivity-Service
final connectivityServiceProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

// Provider für den Online-Status
final connectivityStatusProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier(ref.watch(connectivityServiceProvider));
});

class ConnectivityNotifier extends StateNotifier<bool> {
  final Connectivity _connectivity;

  ConnectivityNotifier(this._connectivity) : super(true) {
    _initConnectivity();
    _setupConnectivityStream();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      state = result != ConnectivityResult.none;
    } catch (e) {
      state = false;
    }
  }

  void _setupConnectivityStream() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      state = result != ConnectivityResult.none;
    });
  }

  bool get isOnline => state;
}

// Provider für den aktuellen Online-Status als Stream
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return connectivity.onConnectivityChanged.map((result) => result != ConnectivityResult.none);
});

// Provider für Offline-Status-Meldungen
final offlineMessageProvider = Provider<String>((ref) {
  final isOnline = ref.watch(connectivityStatusProvider);
  return isOnline 
      ? ''
      : 'Offline-Modus: Änderungen werden synchronisiert, sobald eine Verbindung besteht';
});

// Extension für einfacheren Zugriff auf den Online-Status
extension ConnectivityX on WidgetRef {
  bool get isOnline => watch(connectivityStatusProvider);
  
  String get offlineMessage => watch(offlineMessageProvider);
  
  Stream<bool> get connectivityStream => watch(connectivityStreamProvider.stream);
}
