# Technische Dokumentation 📚

## Projektübersicht 🎯

Polyglotte Translate ist eine Full-Stack-Mobile-App für Textübersetzungen, die Flutter (Dart) für das Frontend und ein Dart-basiertes Backend verwendet.

## Architektur 🏗️

### Frontend-Architektur

```
lib/
├── core/                    # Kern-Funktionalitäten
│   ├── config/             # Konfigurationen
│   │   └── app_config.dart # App-Einstellungen
│   ├── database/           # Lokale Datenbank
│   │   └── database_helper.dart # SQLite-Integration
│   ├── providers/          # State Management
│   │   ├── connectivity_provider.dart # Online/Offline-Status
│   │   └── online_status_provider.dart # Synchronisations-Status
│   ├── theme/             
│   │   └── app_theme.dart  # Design-System
│   └── widgets/            # Wiederverwendbare Widgets
│       ├── animated_icon_button.dart
│       ├── animated_translate_button.dart
│       └── glow_container.dart
├── features/               # Feature-Module
│   ├── auth/              # Authentifizierung
│   │   └── presentation/
│   └── translation/       # Übersetzungsfunktionen
│       ├── presentation/
│       ├── providers/
│       ├── repositories/
│       └── services/
└── main.dart              # App-Entry-Point
```

## Offline-Funktionalität 🔄

### Connectivity Management

```dart
// Online-Status Provider
final connectivityStatusProvider = StateNotifierProvider<ConnectivityNotifier, bool>

// Synchronisations-Status
enum SyncStatus {
  idle,
  syncing,
  error
}
```

### Datenfluss
1. Online → Offline
   - Aktionen werden in der Offline-Queue gespeichert
   - Übersetzungen werden im lokalen Cache gespeichert
   - UI zeigt Offline-Status an

2. Offline → Online
   - Automatische Erkennung der Verbindung
   - Synchronisation der Offline-Queue
   - Aktualisierung des UI-Status

### Datenbank-Schema 💾

#### Translations Tabelle
```sql
CREATE TABLE translations(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sourceText TEXT NOT NULL,
  targetText TEXT NOT NULL,
  sourceLanguage TEXT NOT NULL,
  targetLanguage TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  isFavorite INTEGER DEFAULT 0,
  isSync INTEGER DEFAULT 0
)
```

#### Offline Queue Tabelle
```sql
CREATE TABLE offline_queue(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action TEXT NOT NULL,
  data TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  retryCount INTEGER DEFAULT 0
)
```

#### Translation Cache Tabelle
```sql
CREATE TABLE translation_cache(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sourceText TEXT NOT NULL,
  targetText TEXT NOT NULL,
  sourceLanguage TEXT NOT NULL,
  targetLanguage TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  UNIQUE(sourceText, sourceLanguage, targetLanguage)
)
```

### Repository Pattern

```dart
class TranslationRepository {
  // Online/Offline-Handling
  Future<String> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  });

  // Offline-Synchronisation
  Future<void> syncOfflineData();
}
```

## State Management 🔄

### Provider-Hierarchie

```dart
// Connectivity
connectivityServiceProvider → connectivityStatusProvider → onlineStatusListenerProvider

// Synchronisation
syncStatusProvider → syncMessageProvider
```

### Daten-Flow

1. UI-Layer
   - Beobachtet Status-Provider
   - Zeigt entsprechende Meldungen
   - Passt Verhalten an Online-Status an

2. Repository-Layer
   - Verwaltet Offline-Queue
   - Handhabt Synchronisation
   - Cached Übersetzungen

3. Service-Layer
   - Kommuniziert mit APIs
   - Handhabt Netzwerk-Fehler
   - Implementiert Retry-Logik

## Performance-Optimierungen ⚡

### Caching-Strategien
- Lokales Caching von Übersetzungen
- Intelligente Cache-Invalidierung
- Batch-Operationen für Synchronisation

### Offline-Performance
- Effiziente SQLite-Queries
- Minimierte Schreiboperationen
- Optimierte Queue-Verwaltung

## Sicherheit 🔒

### Daten-Sicherheit
- Verschlüsselte Speicherung
- Sichere Queue-Verwaltung
- Validierung aller Daten

### Fehlerbehandlung
- Graceful Degradation
- Retry-Mechanismen
- Benutzerbenachrichtigungen

## Testing-Strategie 🧪

### Unit Tests
- Provider Tests
- Repository Tests
- Service Tests

### Integration Tests
- Offline → Online Synchronisation
- Datenbank-Migration
- Cache-Verhalten

## Nächste Schritte 📈

1. Implementierung der Auth-Integration
2. Erweiterung der Offline-Funktionalität
3. Performance-Optimierungen
4. UI/UX-Verbesserungen

## Ressourcen 📚

- [Flutter Dokumentation](https://flutter.dev/docs)
- [SQLite Dokumentation](https://www.sqlite.org/docs.html)
- [Riverpod Guide](https://riverpod.dev/docs)
- [Connectivity Plus Package](https://pub.dev/packages/connectivity_plus)

---

Letzte Aktualisierung: Januar 2024
