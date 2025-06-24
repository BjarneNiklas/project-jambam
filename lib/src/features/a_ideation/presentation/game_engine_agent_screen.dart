import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/game_engine_agent_service.dart';

class GameEngineAgentScreen extends ConsumerStatefulWidget {
  const GameEngineAgentScreen({super.key});

  @override
  ConsumerState<GameEngineAgentScreen> createState() => _GameEngineAgentScreenState();
}

class _GameEngineAgentScreenState extends ConsumerState<GameEngineAgentScreen> {
  String _selectedEngine = 'Godot';
  String _selectedGenre = 'Platformer';

  static const genres = [
    'Platformer',
    'RPG',
    'Puzzle',
    'Shooter',
    'Simulation',
    'Adventure',
    'Strategy',
    'Racing',
    'Sandbox',
  ];

  late final GameEngineAgentService _engineService;

  @override
  void initState() {
    super.initState();
    _engineService = GameEngineAgentService();
  }

  @override
  Widget build(BuildContext context) {
    final engines = _engineService.getSupportedEngines();
    final features = _engineService.getEngineFeatures(_selectedEngine);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Engine Agent'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Engine auswählen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: engines.map((engine) => ChoiceChip(
                label: Text(engine),
                selected: _selectedEngine == engine,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedEngine = engine);
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            Text('Genre auswählen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: genres.map((genre) => ChoiceChip(
                label: Text(genre),
                selected: _selectedGenre == genre,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedGenre = genre);
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            Text('Engine-Features', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: features.map((feature) => Chip(
                label: Text(feature),
                backgroundColor: Colors.blue.shade50,
              )).toList(),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.build),
                  label: const Text('Build'),
                  onPressed: () => _showStubSnackbar('Build'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Export'),
                  onPressed: () => _showStubSnackbar('Export'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Run'),
                  onPressed: () => _showStubSnackbar('Run'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.yellow.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Die Engine-Integration ist noch nicht aktiv. Diese Oberfläche dient als Vorschau für die Multi-Engine-Architektur.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStubSnackbar(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action für $_selectedEngine ($_selectedGenre) ist noch nicht implementiert.')),
    );
  }
} 