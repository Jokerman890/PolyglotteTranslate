import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglotte_translate/core/database/database_helper.dart';
import 'package:polyglotte_translate/core/providers/online_status_provider.dart';
import 'package:polyglotte_translate/features/translation/services/mistral_translation_service.dart';

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return TranslationRepository(
    DatabaseHelper(),
    MistralTranslationService(),
    ref,
  );
});

class TranslationRepository {
  final DatabaseHelper _databaseHelper;
  final MistralTranslationService _translationService;
  final ProviderRef _ref;
  bool _isOnline = true;

  TranslationRepository(this._databaseHelper, this._translationService, this._ref);

  set isOnline(bool value) {
    _isOnline = value;
    if (_isOnline) {
      syncOfflineData();
    }
  }

  Future<String> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    try {
      // Prüfe zuerst den Cache
      final cachedTranslation = await _databaseHelper.getCachedTranslation(
        sourceText: text,
        sourceLanguage: fromLanguage,
        targetLanguage: toLanguage,
      );

      if (cachedTranslation != null) {
        return cachedTranslation;
      }

      if (!_isOnline) {
        // Füge zur Offline-Queue hinzu
        await _databaseHelper.addToOfflineQueue(
          action: 'translate',
          data: {
            'sourceText': text,
            'sourceLanguage': fromLanguage,
            'targetLanguage': toLanguage,
          },
        );
        throw Exception('Offline: Übersetzung wird synchronisiert, sobald online');
      }

      // Online Übersetzung
      final translation = await _translationService.translateText(
        text: text,
        fromLanguage: fromLanguage,
        toLanguage: toLanguage,
      );

      // Cache die Übersetzung
      await _databaseHelper.cacheTranslation(
        sourceText: text,
        targetText: translation,
        sourceLanguage: fromLanguage,
        targetLanguage: toLanguage,
      );

      // Speichere in der Historie
      await _databaseHelper.insertTranslation(
        sourceText: text,
        targetText: translation,
        sourceLanguage: fromLanguage,
        targetLanguage: toLanguage,
      );

      return translation;
    } catch (e) {
      throw Exception('Übersetzung fehlgeschlagen: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getTranslationHistory() async {
    return await _databaseHelper.getTranslations();
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    return await _databaseHelper.getFavorites();
  }

  Future<void> toggleFavorite(int translationId, bool isFavorite) async {
    final translation = (await _databaseHelper.getTranslations())
        .firstWhere((t) => t['id'] == translationId);
    
    translation['isFavorite'] = isFavorite ? 1 : 0;
    
    if (_isOnline) {
      await _databaseHelper.updateTranslation(translation);
    } else {
      await _databaseHelper.addToOfflineQueue(
        action: 'toggleFavorite',
        data: translation,
      );
    }
  }

  Future<void> deleteTranslation(int translationId) async {
    if (_isOnline) {
      await _databaseHelper.deleteTranslation(translationId);
    } else {
      await _databaseHelper.addToOfflineQueue(
        action: 'deleteTranslation',
        data: {'id': translationId},
      );
    }
  }

  Future<void> syncOfflineData() async {
    try {
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.syncing;
      
      final queue = await _databaseHelper.getOfflineQueue();
      
      for (final item in queue) {
        try {
          switch (item['action']) {
            case 'translate':
              final data = Map<String, dynamic>.from(item['data']);
              final translation = await _translationService.translateText(
                text: data['sourceText'],
                fromLanguage: data['sourceLanguage'],
                toLanguage: data['targetLanguage'],
              );
              
              await _databaseHelper.cacheTranslation(
                sourceText: data['sourceText'],
                targetText: translation,
                sourceLanguage: data['sourceLanguage'],
                targetLanguage: data['targetLanguage'],
              );
              break;
              
            case 'toggleFavorite':
              final data = Map<String, dynamic>.from(item['data']);
              await _databaseHelper.updateTranslation(data);
              break;
              
            case 'deleteTranslation':
              final data = Map<String, dynamic>.from(item['data']);
              await _databaseHelper.deleteTranslation(data['id']);
              break;
          }
        } catch (e) {
          print('Fehler bei der Synchronisation eines Items: ${e.toString()}');
          continue;
        }
      }
      
      // Lösche die erfolgreichen Items aus der Queue
      await _databaseHelper.clearOfflineQueue();
      
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.idle;
    } catch (e) {
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.error;
      print('Fehler bei der Synchronisation: ${e.toString()}');
    }
  }
}
