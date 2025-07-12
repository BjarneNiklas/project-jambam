import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_settings_service.dart';
import 'ai_cost_analytics_screen.dart';
import '../../b_asset_generation/offline_models_management.dart';
import '../application/ai_settings_controller.dart';

// Provider für AI Settings Service
final aiSettingsServiceProvider = FutureProvider<AISettingsService>((ref) async {
  return AISettingsService.create();
});

class AISettingsScreen extends ConsumerWidget {
  const AISettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettings = ref.watch(aiSettingsServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[400]!, Colors.teal[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 76),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'AI EINSTELLUNGEN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 51)),
            ),
            child: IconButton(
              icon: Icon(Icons.save, color: Colors.teal[300]),
              onPressed: () async {
                // Call the controller's save method (stateless)
                final controller = ref.read(aiSettingsControllerProvider.notifier);
                await controller.saveSettingsFromUI(ref);
              },
              tooltip: 'Einstellungen speichern',
            ),
          ),
        ],
      ),
      body: aiSettings.when(
        data: (service) => _AISettingsBody(service: service),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 16),
              Text(
                'Lade AI Einstellungen...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red[300], size: 64),
              const SizedBox(height: 16),
              const Text(
                'Fehler beim Laden',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(aiSettingsServiceProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AISettingsBody extends ConsumerStatefulWidget {
  final AISettingsService service;
  const _AISettingsBody({required this.service});

  @override
  ConsumerState<_AISettingsBody> createState() => _AISettingsBodyState();
}

class _AISettingsBodyState extends ConsumerState<_AISettingsBody> {
  final Map<String, TextEditingController> _apiKeyControllers = {};
  String? _selectedChatModel;
  String? _selectedConceptModel;
  String? _selectedResearchModel;
  String? _selectedCodeModel;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final service = widget.service;
    final apiKeys = service.userApiKeys;

    // Initialisiere Controller für alle Provider
    for (final model in service.availableModels.values) {
      final provider = model.provider.toLowerCase();
      _apiKeyControllers[provider]?.dispose();
      _apiKeyControllers[provider] = TextEditingController(
        text: apiKeys[provider] ?? '',
      );
    }

    // Lade aktuelle Modell-Einstellungen
    _selectedChatModel = service.getModelForCategory('chat');
    _selectedConceptModel = service.getModelForCategory('concept_generation');
    _selectedResearchModel = service.getModelForCategory('research');
    _selectedCodeModel = service.getModelForCategory('code_generation');
  }

  @override
  void dispose() {
    for (final controller in _apiKeyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  Future<void> _saveSettings() async {
    final service = widget.service;
    try {
      // Speichere API Keys
      for (final entry in _apiKeyControllers.entries) {
        final provider = entry.key;
        final apiKey = entry.value.text.trim();
        if (apiKey.isNotEmpty) {
          await service.setApiKey(provider, apiKey);
        } else {
          await service.removeApiKey(provider);
        }
      }
      
      // Speichere Modell-Einstellungen
      if (_selectedChatModel != null) {
        await service.setModelForCategory('chat', _selectedChatModel!);
      }
      if (_selectedConceptModel != null) {
        await service.setModelForCategory('concept_generation', _selectedConceptModel!);
      }
      if (_selectedResearchModel != null) {
        await service.setModelForCategory('research', _selectedResearchModel!);
      }
      if (_selectedCodeModel != null) {
        await service.setModelForCategory('code_generation', _selectedCodeModel!);
      }
      
      // Refresh the provider to show the latest saved state
      final _ = ref.refresh(aiSettingsServiceProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Einstellungen gespeichert!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-assign the onPressed handler for the save button
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[400]!, Colors.teal[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withValues(alpha: 76),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'AI EINSTELLUNGEN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 51)),
          ),
          child: IconButton(
            icon: Icon(Icons.save, color: Colors.teal[300]),
            onPressed: _saveSettings,
            tooltip: 'Einstellungen speichern',
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Übersicht und Statistiken
            _buildOverviewSection(widget.service),
            const SizedBox(height: 24),
            
            // API Keys Sektion
            _buildApiKeysSection(widget.service),
            const SizedBox(height: 24),
            
            // AI Kategorien Sektion
            _buildAICategoriesSection(widget.service),
            const SizedBox(height: 24),
            
            // Modell-Auswahl Sektion
            _buildModelSelectionSection(widget.service),
            const SizedBox(height: 24),
            
            // Verfügbare Modelle Sektion
            _buildAvailableModelsSection(widget.service),
            const SizedBox(height: 24),
            
            // Kosten-Analytics Link
            _buildCostAnalyticsSection(widget.service),
            const SizedBox(height: 24),
            
            // Offline-Modelle Link
            _buildOfflineModelsSection(widget.service),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(AISettingsService service) {
    final availableModels = service.availableModels.values;
    final configuredProviders = service.userApiKeys.keys.length;
    final totalModels = availableModels.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 25),
            Colors.blue.withValues(alpha: 25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withValues(alpha: 76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.teal[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'AI PLATFORM ÜBERSICHT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Konfigurierte Provider',
                    '$configuredProviders',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Verfügbare Modelle',
                    '$totalModels',
                    Icons.model_training,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 76)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeysSection(AISettingsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key, color: Colors.orange[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'API SCHLÜSSEL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Konfiguriere deine API-Schlüssel für verschiedene AI-Provider. Diese werden lokal gespeichert und sind nur für dich sichtbar.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ...service.availableModels.values
              .map((model) => model.provider)
              .toSet()
              .map((provider) => _buildApiKeyField(provider, service)),
        ],
      ),
    );
  }

  Widget _buildApiKeyField(String provider, AISettingsService service) {
    final controller = _apiKeyControllers[provider.toLowerCase()];
    final hasKey = service.hasApiKey(provider.toLowerCase());
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasKey 
            ? Colors.green.withValues(alpha: 25)
            : Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasKey 
              ? Colors.green.withValues(alpha: 76)
              : Colors.white.withValues(alpha: 51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasKey ? Icons.check_circle : Icons.circle_outlined,
                color: hasKey ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                provider.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (hasKey)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'KONFIGURIERT',
                    style: TextStyle(
                      color: Colors.green[300],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'API-Schlüssel eingeben...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 51)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 51)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                service.setApiKey(provider.toLowerCase(), value);
              } else {
                service.removeApiKey(provider.toLowerCase());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelectionSection(AISettingsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: Colors.purple[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'MODELL-AUSWAHL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Wähle die besten AI-Modelle für verschiedene Aufgaben. Jedes Modell ist für spezifische Anwendungsfälle optimiert.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          _buildModelDropdown(
            'Chat & Konversation',
            'chat',
            _selectedChatModel,
            (value) => setState(() => _selectedChatModel = value),
            service,
          ),
          const SizedBox(height: 16),
          _buildModelDropdown(
            'Konzept-Generierung',
            'concept_generation',
            _selectedConceptModel,
            (value) => setState(() => _selectedConceptModel = value),
            service,
          ),
          const SizedBox(height: 16),
          _buildModelDropdown(
            'Recherche & Analyse',
            'research',
            _selectedResearchModel,
            (value) => setState(() => _selectedResearchModel = value),
            service,
          ),
          const SizedBox(height: 16),
          _buildModelDropdown(
            'Code-Generierung',
            'code_generation',
            _selectedCodeModel,
            (value) => setState(() => _selectedCodeModel = value),
            service,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableModelsSection(AISettingsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.model_training, color: Colors.blue[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'VERFÜGBARE AI-MODELLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Alle verfügbaren AI-Modelle mit detaillierten Informationen zu Kosten, Geschwindigkeit und Anwendungsfällen.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ...service.availableModels.values.map((model) => _buildModelCard(model, service)),
        ],
      ),
    );
  }

  Widget _buildModelCard(AIModel model, AISettingsService service) {
    final hasApiKey = service.hasApiKey(model.provider.toLowerCase());
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasApiKey 
            ? Colors.green.withValues(alpha: 12)
            : Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasApiKey 
              ? Colors.green.withValues(alpha: 76)
              : Colors.white.withValues(alpha: 51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header mit Provider-Icon und Name
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getProviderIcon(model.provider),
                  color: _getProviderColor(model.provider),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.provider,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasApiKey)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'VERFÜGBAR',
                    style: TextStyle(
                      color: Colors.green[300],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Kosten und Geschwindigkeit
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    'Kosten',
                    model.cost,
                    model.costDetails,
                    Icons.euro,
                    _getCostColor(model.cost),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    'Geschwindigkeit',
                    model.speed,
                    model.speedDetails,
                    Icons.speed,
                    _getSpeedColor(model.speed),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    'Qualität',
                    model.quality,
                    model.qualityDetails,
                    Icons.star,
                    _getQualityColor(model.quality),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Beschreibung
          Text(
            model.description,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          
          // Anwendungsfälle
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: model.useCases.map((useCase) => 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  useCase,
                  style: TextStyle(
                    color: Colors.teal[300],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, String details, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 76)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            details,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCostAnalyticsSection(AISettingsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 25),
            Colors.indigo.withValues(alpha: 25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withValues(alpha: 76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.purple[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'KOSTEN-ANALYTICS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Überwache deine AI-Nutzung und Kosten in Echtzeit. Detaillierte Analysen und Export-Funktionen.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AICostAnalyticsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.analytics),
              label: const Text('Kosten-Analytics öffnen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper-Methoden für Icons und Farben
  IconData _getProviderIcon(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return Icons.g_mobiledata;
      case 'openai':
        return Icons.open_in_new;
      case 'anthropic':
        return Icons.auto_awesome;
      case 'groq':
        return Icons.flash_on;
      case 'mistral ai':
        return Icons.psychology;
      case 'meta':
        return Icons.facebook;
      case 'openrouter':
        return Icons.router;
      case 'mlc llm':
        return Icons.speed;
      default:
        return Icons.cloud;
    }
  }

  Color _getProviderColor(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return Colors.blue;
      case 'openai':
        return Colors.green;
      case 'anthropic':
        return Colors.orange;
      case 'groq':
        return Colors.purple;
      case 'mistral ai':
        return Colors.indigo;
      case 'meta':
        return Colors.blue[600]!;
      case 'openrouter':
        return Colors.teal;
      case 'mlc llm':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  Color _getCostColor(String cost) {
    if (cost.toLowerCase().contains('kostenlos')) {
      return Colors.green;
    } else if (cost.toLowerCase().contains('bezahlt')) {
      return Colors.orange;
    }
    return Colors.grey;
  }

  Color _getSpeedColor(String speed) {
    if (speed.toLowerCase().contains('extrem schnell')) {
      return Colors.green;
    } else if (speed.toLowerCase().contains('sehr schnell')) {
      return Colors.lightGreen;
    } else if (speed.toLowerCase().contains('schnell')) {
      return Colors.yellow;
    } else if (speed.toLowerCase().contains('mittel')) {
      return Colors.orange;
    }
    return Colors.red;
  }

  Color _getQualityColor(String quality) {
    if (quality.toLowerCase().contains('exzellent')) {
      return Colors.green;
    } else if (quality.toLowerCase().contains('sehr gut')) {
      return Colors.lightGreen;
    } else if (quality.toLowerCase().contains('gut')) {
      return Colors.yellow;
    }
    return Colors.orange;
  }

  Widget _buildAICategoriesSection(AISettingsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withValues(alpha: 25),
            Colors.purple.withValues(alpha: 25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: Colors.deepPurple[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'AI KATEGORIEN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Unsere AI-Integration ist in drei Kategorien organisiert für optimale Flexibilität und Performance.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          _buildCategoryCard(
            'Offline (MLC LLM)',
            'Lokale Modelle für Privatsphäre und Offline-Nutzung',
            Icons.speed,
            Colors.deepPurple,
            'Gemma 2B, Llama 2, Mistral 7B',
            'Kostenlos, Privat, Offline',
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            'Cloud (OpenRouter)',
            'Multi-Provider Zugang mit kostenlosen Optionen',
            Icons.cloud,
            Colors.teal,
            'Claude, GPT-4, Gemini, Llama 3',
            'Flexibel, Günstig, Vielfältig',
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            'Direct (Gemini)',
            'Direkte API-Integration für spezielle Use Cases',
            Icons.api,
            Colors.orange,
            'Gemini Pro, Gemini Flash',
            'Schnell, Zuverlässig, Direkt',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String models,
    String benefits,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.model_training, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    models,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    benefits,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineModelsSection(AISettingsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withValues(alpha: 25),
            Colors.purple.withValues(alpha: 25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withValues(alpha: 76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.download, color: Colors.indigo[300], size: 24),
              const SizedBox(width: 12),
              const Text(
                'OFFLINE MODELLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Lade AI-Modelle herunter, um sie offline zu nutzen. Lokale Modelle funktionieren ohne Internet und schützen deine Privatsphäre.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OfflineModelsManagement(),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Offline-Modelle verwalten'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelDropdown(
    String label,
    String category,
    String? selectedValue,
    Function(String?) onChanged,
    AISettingsService service,
  ) {
    try {
      final availableModels = service.getAvailableModelsForCategory(category);
      final selected = availableModels.any((m) => m.id == selectedValue) ? selectedValue : null;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 51)),
            ),
            child: DropdownButtonFormField<String>(
              value: selected,
              onChanged: availableModels.isNotEmpty ? onChanged : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              dropdownColor: const Color(0xFF1A1A1A),
              style: const TextStyle(color: Colors.white),
              items: availableModels.map((model) {
                return DropdownMenuItem(
                  value: model.id,
                  child: Row(
                    children: [
                      Icon(
                        service.isModelAvailable(model.id) ? Icons.check_circle : Icons.circle_outlined,
                        color: service.isModelAvailable(model.id) ? Colors.teal[300] : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              model.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${model.provider} • ${model.cost}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (availableModels.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 76)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[300], size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      'Keine API Keys verfügbar. Füge API Keys hinzu, um Modelle zu nutzen.',
                      style: TextStyle(color: Colors.orange[300], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 76)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[300], size: 16),
                const SizedBox(width: 8),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    'Fehler beim Laden der Modelle: $e',
                    style: TextStyle(color: Colors.red[300], fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

// Utility function for alpha manipulation (future-proof)
Color withAlpha(Color color, double opacity) {
  // Color.withValues expects alpha as double (0.0-1.0)
  return color.withValues(alpha: opacity);
}