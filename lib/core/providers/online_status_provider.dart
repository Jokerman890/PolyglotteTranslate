import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglotte_translate/core/providers/connectivity_provider.dart';
import 'package:polyglotte_translate/features/translation/repositories/translation_repository.dart';

// Provider für die Synchronisation des Online-Status mit dem Repository
final onlineStatusListenerProvider = Provider<void>((ref) {
  ref.listen<bool>(connectivityStatusProvider, (previous, next) {
    // Aktualisiere den Online-Status im Repository
    ref.read(translationRepositoryProvider).isOnline = next;

    // Zeige eine Statusmeldung an, wenn sich der Online-Status ändert
    if (next && previous == false) {
      // Online gegangen - Starte Synchronisation
      ref.read(translationRepositoryProvider).syncOfflineData();
    }
  });

  return;
});

// Provider für den aktuellen Synchronisationsstatus
final syncStatusProvider = StateProvider<SyncStatus>((ref) => SyncStatus.idle);

// Enum für den Synchronisationsstatus
enum SyncStatus {
  idle,
  syncing,
  error;

  String get message {
    switch (this) {
      case SyncStatus.idle:
        return '';
      case SyncStatus.syncing:
        return 'Synchronisiere Offline-Daten...';
      case SyncStatus.error:
        return 'Fehler bei der Synchronisation';
    }
  }
}

// Provider für die Synchronisationsmeldung
final syncMessageProvider = Provider<String>((ref) {
  final syncStatus = ref.watch(syncStatusProvider);
  final isOnline = ref.watch(connectivityStatusProvider);

  if (!isOnline) {
    return ref.watch(offlineMessageProvider);
  }

  return syncStatus.message;
});
