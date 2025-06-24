import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../data/agent_context_manager.dart';

/// Provider für AgentContextManager
final agentContextManagerProvider = Provider<AgentContextManager>((ref) {
  return AgentContextManager();
});

/// Provider für alle Agent Contexts
final agentContextsProvider = FutureProvider<Map<String, AgentContext>>((ref) async {
  final manager = ref.read(agentContextManagerProvider);
  return await manager.loadAllContexts();
});

/// Provider für die aktuelle Sprache
final currentLanguageProvider = StateProvider<String>((ref) {
  final manager = ref.read(agentContextManagerProvider);
  return manager.currentLanguage;
});

/// Agent Context Management Screen
/// Ermöglicht das Bearbeiten und Verwalten von Agent Contexts
class AgentContextManagementScreen extends ConsumerStatefulWidget {
  const AgentContextManagementScreen({super.key});

  @override
  ConsumerState<AgentContextManagementScreen> createState() => _AgentContextManagementScreenState();
}

class _AgentContextManagementScreenState extends ConsumerState<AgentContextManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systemPromptController = TextEditingController();
  final _userPromptController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void dispose() {
    _systemPromptController.dispose();
    _userPromptController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextsAsync = ref.watch(agentContextsProvider);
    final currentLanguage = ref.watch(currentLanguageProvider);
    final manager = ref.read(agentContextManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Contexts'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Sprach-Umschaltung
          PopupMenuButton<String>(
            icon: Icon(
              currentLanguage == 'de' ? Icons.language : Icons.translate,
              color: currentLanguage == 'de' ? Colors.blue : Colors.green,
            ),
            onSelected: (language) async {
              await manager.switchLanguage(language);
              ref.read(currentLanguageProvider.notifier).state = language;
              ref.invalidate(agentContextsProvider);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      language == 'de' 
                        ? 'Sprache auf Deutsch gewechselt' 
                        : 'Language switched to English',
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'de',
                child: Row(
                  children: [
                    Icon(Icons.language, color: currentLanguage == 'de' ? Colors.blue : null),
                    const SizedBox(width: 8),
                    const Text('Deutsch'),
                    if (currentLanguage == 'de') 
                      const Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Icon(Icons.translate, color: currentLanguage == 'en' ? Colors.green : null),
                    const SizedBox(width: 8),
                    const Text('English'),
                    if (currentLanguage == 'en') 
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
            ],
          ),
          // Export Button
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportContexts(manager),
          ),
          // Import Button
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => _importContexts(manager),
          ),
        ],
      ),
      body: contextsAsync.when(
        data: (contexts) => Column(
          children: [
            // Sprach-Info Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: currentLanguage == 'de' 
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.green.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(
                    currentLanguage == 'de' ? Icons.language : Icons.translate,
                    color: currentLanguage == 'de' ? Colors.blue : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentLanguage == 'de'
                        ? 'Deutsch: Bessere Benutzerfreundlichkeit für deutsche Nutzer'
                        : 'English: Better AI performance and accuracy',
                      style: TextStyle(
                        color: currentLanguage == 'de' ? Colors.blue : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Agent List
            Expanded(
              child: ListView.builder(
                itemCount: contexts.length,
                itemBuilder: (context, index) {
                  final agentId = contexts.keys.elementAt(index);
                  final agentContext = contexts[agentId]!;
                  
                  return _buildAgentCard(agentContext, manager);
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(agentContextsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateContextDialog(manager),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAgentCard(AgentContext agentContext, AgentContextManager manager) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agentContext.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    agentContext.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Modifiziert-Indikator
            FutureBuilder<bool>(
              future: manager.isContextModified(agentContext.agentId),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'MOD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System Prompt
                _buildPromptSection(
                  'System Prompt',
                  agentContext.systemPrompt,
                  (value) => _updateContext(agentContext.copyWith(systemPrompt: value), manager),
                ),
                
                const SizedBox(height: 16),
                
                // User Prompt
                _buildPromptSection(
                  'User Prompt',
                  agentContext.userPrompt,
                  (value) => _updateContext(agentContext.copyWith(userPrompt: value), manager),
                ),
                
                const SizedBox(height: 16),
                
                // Parameters
                _buildParametersSection(agentContext, manager),
                
                const SizedBox(height: 16),
                
                // Examples
                _buildExamplesSection(agentContext, manager),
                
                const SizedBox(height: 16),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _resetContext(agentContext.agentId, manager),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _duplicateContext(agentContext, manager),
                      icon: const Icon(Icons.copy),
                      label: const Text('Duplicate'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _exportSingleContext(agentContext, manager),
                      icon: const Icon(Icons.download),
                      label: const Text('Export'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSection(String title, String prompt, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: prompt,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter prompt...',
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildParametersSection(AgentContext agentContext, AgentContextManager manager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parameters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            agentContext.parameters.toString(),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  Widget _buildExamplesSection(AgentContext agentContext, AgentContextManager manager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Examples',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...agentContext.examples.map((example) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text('• $example'),
        )),
      ],
    );
  }

  void _updateContext(AgentContext agentContext, AgentContextManager manager) async {
    try {
      await manager.saveContext(agentContext);
      ref.invalidate(agentContextsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Context updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _resetContext(String agentId, AgentContextManager manager) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Context'),
        content: const Text('Are you sure you want to reset this context to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await manager.resetContext(agentId);
        ref.invalidate(agentContextsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Context reset to default')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  void _duplicateContext(AgentContext agentContext, AgentContextManager manager) async {
    final newContext = agentContext.copyWith(
      agentId: '${agentContext.agentId}_copy',
      name: '${agentContext.name} (Copy)',
    );
    
    try {
      await manager.saveContext(newContext);
      ref.invalidate(agentContextsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Context duplicated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _exportSingleContext(AgentContext agentContext, AgentContextManager manager) async {
    try {
      final exportData = {
        'contexts': {
          agentContext.agentId: agentContext.toJson(),
        },
      };
      
      final jsonString = jsonEncode(exportData);
      
      // Hier könnte man den Export-Dialog implementieren
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Context'),
            content: SelectableText(jsonString),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _exportContexts(AgentContextManager manager) async {
    try {
      final exportData = await manager.exportContexts();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export All Contexts'),
            content: SelectableText(exportData),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _importContexts(AgentContextManager manager) async {
    // Hier könnte man einen Import-Dialog implementieren
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import feature coming soon')),
      );
    }
  }

  void _showCreateContextDialog(AgentContextManager manager) {
    _nameController.clear();
    _descriptionController.clear();
    _systemPromptController.clear();
    _userPromptController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Context'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _systemPromptController,
                  decoration: const InputDecoration(labelText: 'System Prompt'),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _userPromptController,
                  decoration: const InputDecoration(labelText: 'User Prompt'),
                  maxLines: 2,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() == true) {
                try {
                  await manager.createContext(
                    agentId: _nameController.text.toLowerCase().replaceAll(' ', '_'),
                    name: _nameController.text,
                    description: _descriptionController.text,
                    systemPrompt: _systemPromptController.text,
                    userPrompt: _userPromptController.text,
                  );
                  
                  ref.invalidate(agentContextsProvider);
                  Navigator.of(context).pop();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Context created')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EDIT SCREEN
// ============================================================================

class AgentContextEditScreen extends StatefulWidget {
  final AgentContext agentContext;

  const AgentContextEditScreen({super.key, required this.agentContext});

  @override
  State<AgentContextEditScreen> createState() => _AgentContextEditScreenState();
}

class _AgentContextEditScreenState extends State<AgentContextEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _systemPromptController;
  late TextEditingController _userPromptController;
  late Map<String, dynamic> _parameters;
  late List<String> _examples;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agentContext.name);
    _descriptionController = TextEditingController(text: widget.agentContext.description);
    _systemPromptController = TextEditingController(text: widget.agentContext.systemPrompt);
    _userPromptController = TextEditingController(text: widget.agentContext.userPrompt);
    _parameters = Map.from(widget.agentContext.parameters);
    _examples = List.from(widget.agentContext.examples);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _systemPromptController.dispose();
    _userPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.agentContext.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveContext,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              icon: Icons.label,
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            
            // Prompts
            _buildPromptEditor(
              controller: _systemPromptController,
              label: 'System Prompt',
              icon: Icons.smart_toy,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            
            _buildPromptEditor(
              controller: _userPromptController,
              label: 'User Prompt',
              icon: Icons.person,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            
            // Parameters
            _buildParametersEditor(),
            const SizedBox(height: 24),
            
            // Examples
            _buildExamplesEditor(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildPromptEditor({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 8,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: color),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 2),
            ),
            hintText: 'Prompt hier eingeben...',
          ),
        ),
      ],
    );
  }

  Widget _buildParametersEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.tune, color: Colors.purple),
            const SizedBox(width: 8),
            Text(
              'Parameters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._parameters.entries.map((entry) => _buildParameterField(entry.key, entry.value)),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _addParameter,
          icon: const Icon(Icons.add),
          label: const Text('Parameter hinzufügen'),
        ),
      ],
    );
  }

  Widget _buildParameterField(String key, dynamic value) {
    final keyController = TextEditingController(text: key);
    final valueController = TextEditingController(text: value.toString());
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(),
              ),
              onChanged: (newKey) {
                if (newKey != key) {
                  _parameters.remove(key);
                  _parameters[newKey] = value;
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              onChanged: (newValue) {
                _parameters[key] = newValue;
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _parameters.remove(key);
              });
            },
          ),
        ],
      ),
    );
  }

  void _addParameter() {
    setState(() {
      _parameters['new_parameter'] = 'value';
    });
  }

  Widget _buildExamplesEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              'Examples',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._examples.asMap().entries.map((entry) => _buildExampleField(entry.key, entry.value)),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _addExample,
          icon: const Icon(Icons.add),
          label: const Text('Example hinzufügen'),
        ),
      ],
    );
  }

  Widget _buildExampleField(int index, String example) {
    final controller = TextEditingController(text: example);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Example ${index + 1}',
                border: const OutlineInputBorder(),
              ),
              onChanged: (newExample) {
                _examples[index] = newExample;
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _examples.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  void _addExample() {
    setState(() {
      _examples.add('New example');
    });
  }

  void _saveContext() async {
    try {
      final updatedContext = widget.agentContext.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        systemPrompt: _systemPromptController.text,
        userPrompt: _userPromptController.text,
        parameters: _parameters,
        examples: _examples,
        lastModified: DateTime.now(),
      );
      
      final manager = AgentContextManager();
      await manager.updateContext(updatedContext);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Context erfolgreich gespeichert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    }
  }
} 