import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JamSeedScreen extends ConsumerStatefulWidget {
  const JamSeedScreen({super.key});

  @override
  ConsumerState<JamSeedScreen> createState() => _JamSeedScreenState();
}

class _JamSeedScreenState extends ConsumerState<JamSeedScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 Jam Seeds'),
        backgroundColor: Colors.green.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Seed-Metapher
            _buildSeedMetaphorHeader(),
            const SizedBox(height: 24),
            
            // Seed-Kategorien
            _buildSeedCategories(),
            const SizedBox(height: 24),
            
            // Aktuelle Seeds
            _buildCurrentSeeds(),
            const SizedBox(height: 24),
            
            // Forest Overview
            _buildForestOverview(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSeedDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Neuen Seed pflanzen'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSeedMetaphorHeader() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Seed Animation Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.eco,
                size: 40,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Der Keim einer Idee',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            Text(
              'Ein Seed ist der Anfangswert, aus dem sich eine vollständige Spielidee entwickeln kann. '
              'Wie ein echter Samen enthält er das Potenzial für etwas Großes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Aus vielen Seeds entstehen wunderschöne Wälder voller kreativer Spiele! 🌳🎮',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Seed Evolution Path
            _buildSeedEvolutionPath(),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedEvolutionPath() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildEvolutionStep('🌱', 'Seed', 'Idee pflanzen'),
        _buildEvolutionArrow(),
        _buildEvolutionStep('🌿', 'Keimling', 'Community-Feedback'),
        _buildEvolutionArrow(),
        _buildEvolutionStep('🌳', 'Baum', 'Prototyp entwickeln'),
        _buildEvolutionArrow(),
        _buildEvolutionStep('🏢', 'Studio', 'Vollständiges Spiel'),
      ],
    );
  }

  Widget _buildEvolutionStep(String icon, String title, String description) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEvolutionArrow() {
    return const Icon(
      Icons.arrow_forward,
      color: Colors.green,
      size: 20,
    );
  }

  Widget _buildSeedCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seed-Kategorien',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCategoryChip('🎮 Mechanik-Seeds', 'Neue Spielmechaniken testen'),
            _buildCategoryChip('🎨 Art-Seeds', 'Visuelle Stile erkunden'),
            _buildCategoryChip('📖 Story-Seeds', 'Narrative Konzepte entwickeln'),
            _buildCategoryChip('🔬 Tech-Seeds', 'Technische Innovationen'),
            _buildCategoryChip('🌍 World-Seeds', 'Weltbau-Experimente'),
            _buildCategoryChip('🎵 Audio-Seeds', 'Sound-Design-Konzepte'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, String description) {
    return ActionChip(
      label: Text(label),
      onPressed: () => _showCategorySeeds(label),
      backgroundColor: Colors.green.shade50,
      side: BorderSide(color: Colors.green.shade200),
    );
  }

  Widget _buildCurrentSeeds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktuelle Seeds',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Mock Seeds
        _buildSeedCard(
          'Procedural Narrative',
          'AI-generierte Geschichten, die sich an Spielerentscheidungen anpassen',
          'Narrative-Seed',
          42,
          Colors.purple,
        ),
        _buildSeedCard(
          'Accessibility-First Design',
          'Spiele, die von Anfang an für alle Spieler zugänglich sind',
          'Design-Seed',
          28,
          Colors.blue,
        ),
        _buildSeedCard(
          'Emergent Gameplay',
          'Einfache Regeln, die komplexe, unerwartete Spielerlebnisse schaffen',
          'Mechanik-Seed',
          35,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSeedCard(String title, String description, String category, int votes, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.thumb_up, color: color, size: 20),
                    Text(
                      '$votes',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showSeedDetails(title),
                    icon: const Icon(Icons.visibility),
                    label: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _evolveSeed(title),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Evolvieren'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSeedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌱 Neuen Seed pflanzen'),
        content: const Text('Hier können Sie eine neue Spielidee als Seed pflanzen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Seed pflanzen'),
          ),
        ],
      ),
    );
  }

  void _showCategorySeeds(String category) {
    // Implementation for showing category seeds
  }

  void _showSeedDetails(String title) {
    // Implementation for showing seed details
  }

  void _evolveSeed(String title) {
    // Implementation for evolving seed to Jam Kit
  }

  Widget _buildForestOverview() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.forest,
                  color: Colors.green.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  '🌳 Unser Kreativer Wald',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Forest Stats
            Row(
              children: [
                Expanded(
                  child: _buildForestStat(
                    '🌱 Seeds',
                    '156',
                    'Aktive Ideen',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildForestStat(
                    '🌿 Keimlinge',
                    '89',
                    'In Entwicklung',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildForestStat(
                    '🌳 Bäume',
                    '34',
                    'Prototypen',
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildForestStat(
                    '🏢 Studios',
                    '12',
                    'Vollständige Spiele',
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Forest Growth Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    '🎮 Jeder Seed trägt zu unserem wachsenden Ökosystem bei!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gemeinsam erschaffen wir eine vielfältige Landschaft voller innovativer Spiele. '
                    'Jede Idee, jeder Beitrag, jeder Seed macht unseren kreativen Wald reicher und lebendiger.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Community Contribution
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateSeedDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Seed pflanzen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _exploreForest(),
                    icon: const Icon(Icons.explore),
                    label: const Text('Wald erkunden'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForestStat(String icon, String count, String label, Color color) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _exploreForest() {
    // Implementation for exploring the creative forest
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌳 Wald erkunden'),
        content: const Text('Entdecke die vielfältige Landschaft kreativer Spiele in unserer Community!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
} 