import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglotte_translate/core/config/app_config.dart';
import 'package:polyglotte_translate/core/theme/app_theme.dart';
import 'package:polyglotte_translate/core/widgets/animated_icon_button.dart';
import 'package:polyglotte_translate/core/widgets/animated_translate_button.dart';
import 'package:polyglotte_translate/core/widgets/glow_container.dart';
import 'package:polyglotte_translate/features/translation/services/mistral_translation_service.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final MistralTranslationService _translationService = MistralTranslationService();
  
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  
  String _sourceLanguage = AppConfig.defaultSourceLanguage;
  String _targetLanguage = AppConfig.defaultTargetLanguage;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _translateText() async {
    final text = _sourceController.text;
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String fromLanguage = _sourceLanguage;
      
      if (_sourceLanguage == 'auto' && text.length > 3) {
        fromLanguage = await _translationService.detectLanguage(text);
      }

      final translation = await _translationService.translateText(
        text: text,
        fromLanguage: fromLanguage,
        toLanguage: _targetLanguage,
      );

      setState(() {
        _targetController.text = translation;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _swapLanguages() {
    if (_sourceLanguage == 'auto') return;
    
    setState(() {
      final tempLang = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = tempLang;

      final tempText = _sourceController.text;
      _sourceController.text = _targetController.text;
      _targetController.text = tempText;
    });
  }

  Widget _buildLanguageDropdown(
    bool isSource,
    String value,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Colors.black.withOpacity(0.9),
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppTheme.darkTheme.colorScheme.primary,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          items: [
            if (isSource)
              DropdownMenuItem(
                value: 'auto',
                child: Text(_getLocalizedText('autoDetect')),
              ),
            ...AppConfig.priorityLanguages
                .where((lang) => lang != 'auto')
                .map((String lang) {
                  String flagEmoji = '';
                  switch (lang) {
                    case 'de':
                      flagEmoji = '🇩🇪 ';
                      break;
                    case 'ru':
                      flagEmoji = '🇷🇺 ';
                      break;
                    case 'uk':
                      flagEmoji = '🇺🇦 ';
                      break;
                    case 'en':
                      flagEmoji = '🇬🇧 ';
                      break;
                  }
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(flagEmoji + (AppConfig.languageNames[lang] ?? lang)),
                  );
                }),
            const DropdownMenuItem(
              enabled: false,
              child: Divider(color: Colors.white30),
            ),
            ...AppConfig.supportedLanguages
                .where((lang) => !AppConfig.priorityLanguages.contains(lang))
                .map((String lang) => DropdownMenuItem<String>(
                      value: lang,
                      child: Text(AppConfig.languageNames[lang] ?? lang),
                    )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _getLocalizedText(String key) {
    final Map<String, Map<String, String>> localizedTexts = {
      'de': {
        'enterText': 'Text eingeben...',
        'translation': 'Übersetzung',
        'copied': 'In Zwischenablage kopiert',
        'autoDetect': '🔄 Automatisch erkennen',
        'translate': 'Übersetzen',
        'clear': 'Löschen',
      },
      'ru': {
        'enterText': 'Введите текст...',
        'translation': 'Перевод',
        'copied': 'Скопировано в буфер обмена',
        'autoDetect': '🔄 Автоматическое определение',
        'translate': 'Перевести',
        'clear': 'Очистить',
      },
      'uk': {
        'enterText': 'Введіть текст...',
        'translation': 'Переклад',
        'copied': 'Скопійовано в буфер обміну',
        'autoDetect': '🔄 Автоматичне визначення',
        'translate': 'Перекласти',
        'clear': 'Очистити',
      },
      'en': {
        'enterText': 'Enter text...',
        'translation': 'Translation',
        'copied': 'Copied to clipboard',
        'autoDetect': '🔄 Auto detect',
        'translate': 'Translate',
        'clear': 'Clear',
      },
    };

    final texts = localizedTexts[_targetLanguage] ?? localizedTexts['en']!;
    return texts[key] ?? localizedTexts['en']![key]!;
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
              const Color(0xFF1A1A1A),  // Sehr dunkles Grau
              const Color(0xFF2D1F3D),  // Dunkles Violett
              const Color(0xFF1F2D3D),  // Dunkles Blau-Grau
              const Color(0xFF1A1A1A),  // Sehr dunkles Grau
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Polyglotte Translate',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GlowContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildLanguageDropdown(
                          true,
                          _sourceLanguage,
                          (String? newValue) {
                            if (newValue != null) {
                              setState(() => _sourceLanguage = newValue);
                            }
                          },
                        ),
                      ),
                      AnimatedIconButton(
                        icon: Icons.swap_horiz,
                        onPressed: _sourceLanguage == 'auto' ? null : _swapLanguages,
                        color: AppTheme.darkTheme.colorScheme.primary,
                      ),
                      Expanded(
                        child: _buildLanguageDropdown(
                          false,
                          _targetLanguage,
                          (String? newValue) {
                            if (newValue != null) {
                              setState(() => _targetLanguage = newValue);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: GlowContainer(
                    child: Column(
                      children: [
                        TextField(
                          controller: _sourceController,
                          maxLines: 5,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: _getLocalizedText('enterText'),
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppTheme.darkTheme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            suffixIcon: AnimatedIconButton(
                              icon: Icons.clear,
                              onPressed: () {
                                _sourceController.clear();
                                _targetController.clear();
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        GlowContainer(
                          child: AnimatedTranslateButton(
                            onPressed: _translateText,
                            isLoading: _isLoading,
                            text: _getLocalizedText('translate'),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        TextField(
                          controller: _targetController,
                          maxLines: 5,
                          readOnly: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: _getLocalizedText('translation'),
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppTheme.darkTheme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            suffixIcon: AnimatedIconButton(
                              icon: Icons.copy,
                              onPressed: () {
                                if (_targetController.text.isNotEmpty) {
                                  Clipboard.setData(
                                    ClipboardData(text: _targetController.text),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_getLocalizedText('copied')),
                                      backgroundColor: AppTheme.darkTheme.colorScheme.primary,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: AppTheme.darkTheme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
