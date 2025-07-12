import 'package:flutter/material.dart';
import '../data/ai_settings_service.dart';

/// AI Onboarding Wizard
/// Schritt-für-Schritt Anleitung für AI API Key Setup
class AIOnboardingWizard extends StatefulWidget {
  const AIOnboardingWizard({super.key});

  @override
  State<AIOnboardingWizard> createState() => _AIOnboardingWizardState();
}

class _AIOnboardingWizardState extends State<AIOnboardingWizard>
    with TickerProviderStateMixin {
  late final AISettingsService _aiSettings;
  bool _isSettingsServiceInitialized = false;
  final PageController _pageController = PageController();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentStep = 0;
  final int _totalSteps = 4;
  
  final Map<String, TextEditingController> _apiKeyControllers = {};
  String? _selectedProvider;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeControllers();
    _initializeAiSettings();
  }

  Future<void> _initializeAiSettings() async {
    _aiSettings = await AISettingsService.create();
    if (mounted) {
      setState(() {
        _isSettingsServiceInitialized = true;
      });
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _initializeControllers() {
    _apiKeyControllers['google'] = TextEditingController();
    _apiKeyControllers['openai'] = TextEditingController();
    _apiKeyControllers['anthropic'] = TextEditingController();
    _apiKeyControllers['groq'] = TextEditingController();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    for (final controller in _apiKeyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                  _fadeController.reset();
                  _slideController.reset();
                  _fadeController.forward();
                  _slideController.forward();
                },
                children: [
                  _buildWelcomeStep(),
                  _buildProviderSelectionStep(),
                  _buildApiKeyStep(),
                  _buildCompletionStep(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;
              
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? Colors.teal 
                        : isActive 
                            ? Colors.teal.withValues(alpha: 0.5)
                            : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Schritt ${_currentStep + 1} von $_totalSteps',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.teal.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  Icons.psychology,
                  size: 64,
                  color: Colors.teal[300],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Willkommen bei JambaM AI!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Lass uns deine AI-Erfahrung einrichten. Du kannst zwischen verschiedenen AI-Providern wählen und deine eigenen API Keys verwenden.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.green[300]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Alle API Keys werden lokal gespeichert und nie an Server gesendet.',
                        style: TextStyle(
                          color: Colors.green[300],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderSelectionStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wähle deine AI-Provider',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Du kannst mehrere Provider gleichzeitig verwenden:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildProviderCard(
                      'Google',
                      'Gemini',
                      Icons.cloud,
                      Colors.blue,
                      'Kostenlos verfügbar',
                    ),
                    _buildProviderCard(
                      'OpenAI',
                      'GPT-4 & GPT-3.5',
                      Icons.psychology,
                      Colors.green,
                      'Höchste Qualität',
                    ),
                    _buildProviderCard(
                      'Anthropic',
                      'Claude',
                      Icons.smart_toy,
                      Colors.orange,
                      'Sehr gute Qualität',
                    ),
                    _buildProviderCard(
                      'Groq',
                      'Llama & Mixtral',
                      Icons.rocket,
                      Colors.purple,
                      'Extrem schnell',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderCard(
    String name,
    String description,
    IconData icon,
    Color color,
    String benefit,
  ) {
    final isSelected = _selectedProvider == name.toLowerCase();
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = isSelected ? null : name.toLowerCase();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? color.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : icon,
              color: isSelected ? color : Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                benefit,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyStep() {
    if (_selectedProvider == null) {
      return _buildProviderRequiredStep();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API Key für ${_selectedProvider!.toUpperCase()}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'So bekommst du deinen API Key:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 24),
              _buildApiKeyInstructions(),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _apiKeyControllers[_selectedProvider],
                      decoration: InputDecoration(
                        labelText: 'API Key eingeben',
                        hintText: 'sk-... oder AIza...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ElevatedButton.icon(
                            onPressed: _testApiKey,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Testen'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          fit: FlexFit.loose,
                          child: OutlinedButton.icon(
                            onPressed: _skipProvider,
                            icon: const Icon(Icons.skip_next),
                            label: const Text('Überspringen'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal[300],
                              side: BorderSide(color: Colors.teal[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApiKeyInstructions() {
    final instructions = _getApiKeyInstructions();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[300], size: 20),
              const SizedBox(width: 8),
              Text(
                'Schritt-für-Schritt Anleitung',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...instructions.map((instruction) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    instruction,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<String> _getApiKeyInstructions() {
    switch (_selectedProvider) {
      case 'google':
        return [
          'Gehe zu https://makersuite.google.com/app/apikey',
          'Klicke auf "Create API Key"',
          'Kopiere den generierten Key',
          'Füge ihn oben ein und teste'
        ];
      case 'openai':
        return [
          'Gehe zu https://platform.openai.com/api-keys',
          'Klicke auf "Create new secret key"',
          'Kopiere den generierten Key (beginnt mit sk-)',
          'Füge ihn oben ein und teste'
        ];
      case 'anthropic':
        return [
          'Gehe zu https://console.anthropic.com/',
          'Klicke auf "Create Key"',
          'Kopiere den generierten Key',
          'Füge ihn oben ein und teste'
        ];
      case 'groq':
        return [
          'Gehe zu https://console.groq.com/keys',
          'Klicke auf "Create API Key"',
          'Kopiere den generierten Key',
          'Füge ihn oben ein und teste'
        ];
      default:
        return ['API Key Anleitung wird geladen...'];
    }
  }

  Widget _buildProviderRequiredStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Bitte wähle einen Provider',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Gehe zurück und wähle mindestens einen AI-Provider aus.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green[300],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Setup abgeschlossen!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Du kannst jetzt AI-Features in JambaM nutzen. Alle Einstellungen können später in den AI-Einstellungen angepasst werden.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.teal.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.teal[300]),
                        const SizedBox(width: 12),
                        Text(
                          'Kosten-Tracking aktiviert',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Alle AI-Nutzung wird lokal getrackt und du kannst deine Kosten in den Analytics einsehen.',
                      style: TextStyle(
                        color: Colors.teal[300],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal[300],
                  side: BorderSide(color: Colors.teal[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Zurück'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == _totalSteps - 1 ? _finishOnboarding : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_currentStep == _totalSteps - 1 ? 'Fertig' : 'Weiter'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _testApiKey() async {
    if (!_isSettingsServiceInitialized) {
      _showSnackBar('Einstellungen werden noch geladen...', Colors.orange);
      return;
    }
    final apiKey = _apiKeyControllers[_selectedProvider]?.text.trim();
    if (apiKey == null || apiKey.isEmpty) {
      _showSnackBar('Bitte gib einen API Key ein', Colors.red);
      return;
    }

    try {
      await _aiSettings.setApiKey(_selectedProvider!, apiKey);
      _showSnackBar('API Key erfolgreich getestet!', Colors.green);
      _nextStep();
    } catch (e) {
      _showSnackBar('Fehler beim Testen: $e', Colors.red);
    }
  }

  void _skipProvider() {
    setState(() {
      _selectedProvider = null;
    });
    _nextStep();
  }

  void _finishOnboarding() {
    Navigator.of(context).pop(true);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
} 