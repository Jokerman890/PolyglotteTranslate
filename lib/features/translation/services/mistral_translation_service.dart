import 'package:dio/dio.dart';
import 'package:polyglotte_translate/core/config/app_config.dart';

class MistralTranslationService {
  final Dio _dio;

  MistralTranslationService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.mistralApiEndpoint,
            headers: {
              'Authorization': 'Bearer ${AppConfig.mistralApiKey}',
              'Content-Type': 'application/json',
            },
            connectTimeout: Duration(milliseconds: AppConfig.connectionTimeout),
            receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
          ),
        );

  String _getPromptForLanguage(String toLanguage) {
    switch (toLanguage) {
      case 'ru':
        return '''Ты профессиональный переводчик и лингвист. Переведи текст и предоставь подробное объяснение:
1. Основной перевод
2. Грамматическая форма (для глаголов: время, наклонение; для существительных: род, число)
3. Стилистический уровень (формальный, разговорный, сленг)
4. Примеры использования
5. Идиоматические выражения, если есть''';
      case 'uk':
        return '''Ти професійний перекладач та лінгвіст. Переклади текст та надай детальне пояснення:
1. Основний переклад
2. Граматична форма (для дієслів: час, спосіб; для іменників: рід, число)
3. Стилістичний рівень (формальний, розмовний, сленг)
4. Приклади використання
5. Ідіоматичні вирази, якщо є''';
      case 'de':
        return '''Du bist ein professioneller Übersetzer und Linguist. Übersetze den Text und gib eine detaillierte Erklärung:
1. Hauptübersetzung
2. Grammatische Form (bei Verben: Zeit, Modus; bei Substantiven: Genus, Numerus)
3. Stilebene (formell, umgangssprachlich, Slang)
4. Verwendungsbeispiele
5. Idiomatische Ausdrücke, falls vorhanden''';
      default:
        return '''You are a professional translator and linguist. Translate the text and provide a detailed explanation:
1. Main translation
2. Grammatical form (for verbs: tense, mood; for nouns: gender, number)
3. Style level (formal, colloquial, slang)
4. Usage examples
5. Idiomatic expressions if any''';
    }
  }

  Future<String> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'mistral-large-latest',
          'messages': [
            {
              'role': 'system',
              'content': _getPromptForLanguage(toLanguage),
            },
            {
              'role': 'user',
              'content': text,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 4000,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final translation = response.data['choices'][0]['message']['content'] as String;
        return translation.trim();
      } else {
        throw Exception(_getErrorMessage(toLanguage));
      }
    } catch (e) {
      throw Exception(_getErrorMessage(toLanguage));
    }
  }

  Future<String> detectLanguage(String text) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'mistral-large-latest',
          'messages': [
            {
              'role': 'system',
              'content': 'Gib nur den ISO 639-1 Sprachcode zurück (z.B. "de", "ru", "uk", "en").'
            },
            {
              'role': 'user',
              'content': text,
            }
          ],
          'temperature': 0.1,
          'max_tokens': 10,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final languageCode = response.data['choices'][0]['message']['content'] as String;
        return languageCode.trim().toLowerCase();
      } else {
        throw Exception('Spracherkennung fehlgeschlagen');
      }
    } catch (e) {
      throw Exception('Spracherkennung fehlgeschlagen');
    }
  }

  String _getErrorMessage(String targetLanguage) {
    Map<String, String> errorMessages = {
      'de': 'Übersetzung fehlgeschlagen',
      'ru': 'Ошибка перевода',
      'uk': 'Помилка перекладу',
      'en': 'Translation failed',
    };

    return errorMessages[targetLanguage] ?? errorMessages['en']!;
  }
}
