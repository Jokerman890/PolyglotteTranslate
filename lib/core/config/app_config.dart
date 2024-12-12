class AppConfig {
  // Supabase Konfiguration
  static const String supabaseUrl = 'IHRE_SUPABASE_URL';
  static const String supabaseAnonKey = 'IHR_SUPABASE_ANON_KEY';

  // API Konfiguration
  static const String mistralApiKey = '2zib0SLs0NdJLFgWzignSRjQaksSFPAl';
  static const String mistralApiEndpoint = 'https://api.mistral.ai/v1';

  // App Konfiguration
  static const String appName = 'Polyglotte Translate';
  static const String appVersion = '1.0.0';
  
  // Cache Konfiguration
  static const int maxCacheAge = 7; // Tage
  static const int maxCacheSize = 100; // MB

  // Timeouts
  static const int connectionTimeout = 30000; // Millisekunden
  static const int receiveTimeout = 30000; // Millisekunden

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableVoiceInput = false;
  static const bool enableAutoDetectLanguage = true;

  // Prioritäts-Sprachen (werden in der UI hervorgehoben)
  static const List<String> priorityLanguages = [
    'auto', // Automatische Erkennung
    'de',   // Deutsch
    'ru',   // Russisch
    'uk',   // Ukrainisch
    'en',   // Englisch
  ];

  // Alle unterstützten Sprachen
  static const List<String> supportedLanguages = [
    // Prioritäts-Sprachen
    'auto', // Automatische Erkennung
    'de',   // Deutsch
    'ru',   // Russisch
    'uk',   // Ukrainisch
    'en',   // Englisch
    // Weitere Sprachen
    'fr',   // Französisch
    'es',   // Spanisch
    'it',   // Italienisch
    'nl',   // Niederländisch
    'pl',   // Polnisch
    'tr',   // Türkisch
    'ar',   // Arabisch
    'ja',   // Japanisch
    'ko',   // Koreanisch
    'zh',   // Chinesisch
  ];

  // Sprach-Namen Mapping
  static const Map<String, String> languageNames = {
    // Spezielle Optionen
    'auto': 'Automatisch erkennen',
    // Prioritäts-Sprachen
    'de': 'Deutsch',
    'ru': 'Русский',
    'uk': 'Українська',
    'en': 'English',
    // Weitere Sprachen
    'fr': 'Français',
    'es': 'Español',
    'it': 'Italiano',
    'nl': 'Nederlands',
    'pl': 'Polski',
    'tr': 'Türkçe',
    'ar': 'العربية',
    'ja': '日本語',
    'ko': '한국어',
    'zh': '中文',
  };

  // Standard-Sprachen
  static const String defaultSourceLanguage = 'auto';  // Automatische Erkennung als Standard
  static const String defaultTargetLanguage = 'ru';    // Russisch als Standard-Zielsprache
}
