# Polyglotte Translate

Eine moderne Full-Stack-Übersetzungs-App entwickelt mit Flutter.

## Projektübersicht

Polyglotte Translate ist eine leistungsstarke Übersetzungs-App, die Funktionen wie Echtzeit-Übersetzung, Offline-Unterstützung und Benutzerverwaltung bietet.

### Technologie-Stack

- **Frontend**: Flutter/Dart
- **Backend**: Dart (Shelf/Supabase Edge Functions)
- **Übersetzungs-API**: Mistral AI
- **Datenbank**: SQLite (lokal), Supabase (Cloud)
- **State Management**: Riverpod
- **Code Generation**: Freezed
- **Authentication**: Supabase Auth

### Projektstruktur

```
lib/
├── core/
│   ├── constants/           # App-weite Konstanten
│   ├── errors/             # Fehlerbehandlung
│   ├── theme/              # App-Theme
│   └── utils/              # Hilfsfunktionen
├── features/
│   ├── auth/               # Authentifizierung
│   ├── translation/        # Übersetzungsfunktionalität
│   ├── favorites/          # Favoritenverwaltung
│   └── settings/           # App-Einstellungen
├── models/                 # Datenmodelle
├── repositories/           # Datenzugriffsschicht
├── services/              # Geschäftslogik
└── widgets/               # Wiederverwendbare Widgets

test/
├── unit/                  # Unit-Tests
├── widget/               # Widget-Tests
└── integration/          # Integrationstests
```

### Hauptfunktionen

- Echtzeit-Textübersetzung
- Offline-Unterstützung
- Spracherkennung
- Benutzerkonten und Synchronisation
- Übersetzungsverlauf
- Favoriten-Management
- Dark/Light Mode

### Technische Anforderungen

- Flutter SDK
- Android Studio / Xcode
- VSCode mit Flutter/Dart Extensions
- Git

### Entwicklungsrichtlinien

1. **Code-Stil**
   - Verwendung von `flutter_lints`
   - Strikte Typisierung (kein `dynamic` oder `var`)
   - Dokumentation aller öffentlichen APIs

2. **Architektur**
   - MVVM-Architektur
   - Dependency Injection mit Riverpod
   - Repository Pattern für Datenzugriff

3. **Testing**
   - Mindestens 80% Testabdeckung
   - Unit-Tests für alle Services/Repositories
   - Widget-Tests für UI-Komponenten
   - Integration-Tests für kritische Flows

4. **Performance**
   - Lazy Loading für Listen
   - Effizientes Caching
   - Optimierte Asset-Verwaltung

### Sicherheit

- Sichere API-Schlüssel-Verwaltung
- Verschlüsselte lokale Datenspeicherung
- Sicheres Session-Management
- HTTPS-Kommunikation

### CI/CD

- Automatisierte Tests
- Code-Qualitätsprüfung
- Build-Automatisierung
- Versionierung nach Semantic Versioning

## Installation

1. Flutter SDK installieren
2. Repository klonen
3. Abhängigkeiten installieren:
   ```bash
   flutter pub get
   ```
4. Umgebungsvariablen konfigurieren
5. App starten:
   ```bash
   flutter run
   ```

## Entwicklung

1. Feature-Branch erstellen
2. Code entwickeln und testen
3. Pull Request erstellen
4. Code Review
5. Merge nach erfolgreichem Review

## Lizenz

MIT License
