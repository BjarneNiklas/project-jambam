import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/prompt_optimizer_agent.dart';
import '../domain/ideation_methods.dart';
import '../domain/accessibility_system.dart';

class PromptOptimizerScreen extends ConsumerStatefulWidget {
  const PromptOptimizerScreen({super.key});

  @override
  ConsumerState<PromptOptimizerScreen> createState() => _PromptOptimizerScreenState();
}

class _PromptOptimizerScreenState extends ConsumerState<PromptOptimizerScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  
  OptimizedPrompt? _optimizedPrompt;
  bool _isOptimizing = false;
  String _selectedMethod = 'crazy-8s';
  String _selectedOptimizationLevel = 'standard';

  final PromptOptimizerAgent _optimizerAgent = PromptOptimizerAgent(
    id: 'prompt-optimizer-screen',
    name: 'Prompt Optimizer Agent',
    expertise: PromptOptimizationExpertise.advanced,
  );

  @override
  void initState() {
    super.initState();
    _keywordsController.text = 'puzzle, gravity, space, minimalist';
  }

  @override
  void dispose() {
    _promptController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _optimizePrompt() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt to optimize')),
      );
      return;
    }

    setState(() {
      _isOptimizing = true;
    });

    try {
      // Create a mock ideation method
      final mockMethod = IdeationMethod(
        id: _selectedMethod,
        name: 'Selected Method',
        description: 'Method for prompt optimization',
        category: IdeationCategory.brainstorming,
        duration: Duration(minutes: 10),
        participants: ParticipantRange.small,
        complexity: Complexity.simple,
        steps: [],
        tags: ['optimization', 'prompt'],
        aiSupport: true,
      );

      // Create accessibility profile and context
      final accessibilityProfile = AccessibilityProfile(
        id: 'default-profile',
        name: 'Default User',
        description: 'Default accessibility profile',
        skillLevel: SkillLevel.beginner,
        learningStyle: LearningStyle.visual,
      );

      final ideationContext = IdeationContext(
        teamSize: 1,
        timeRemaining: Duration(hours: 2),
      );

      final optimizedPrompt = _optimizerAgent.optimizePrompt(
        originalPrompt: _promptController.text.trim(),
        method: mockMethod,
        userProfile: accessibilityProfile,
        context: ideationContext,
      );

      setState(() {
        _optimizedPrompt = optimizedPrompt;
        _isOptimizing = false;
      });
    } catch (e) {
      setState(() {
        _isOptimizing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Optimization failed: $e')),
        );
      }
    }
  }

  Future<void> _testWithKeywords() async {
    final keywords = _keywordsController.text.split(',').map((k) => k.trim()).toList();
    
    setState(() {
      _isOptimizing = true;
    });

    try {
      // Create a mock ideation method for testing
      final mockMethod = IdeationMethod(
        id: 'test-method',
        name: 'Test Method',
        description: 'Method for testing prompt optimization',
        category: IdeationCategory.brainstorming,
        duration: Duration(minutes: 5),
        participants: ParticipantRange.solo,
        complexity: Complexity.simple,
        steps: [],
        tags: ['test', 'optimization'],
        aiSupport: true,
      );

      // Create accessibility profile and context
      final accessibilityProfile = AccessibilityProfile(
        id: 'test-profile',
        name: 'Test User',
        description: 'Test accessibility profile',
        skillLevel: SkillLevel.intermediate,
        learningStyle: LearningStyle.visual,
      );

      final ideationContext = IdeationContext(
        teamSize: 1,
        timeRemaining: Duration(hours: 1),
      );

      final result = _optimizerAgent.optimizePrompt(
        originalPrompt: keywords.join(' '),
        method: mockMethod,
        userProfile: accessibilityProfile,
        context: ideationContext,
      );

      setState(() {
        _isOptimizing = false;
      });

      // Show results in a dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Prompt Optimization Results'),
            content: SingleChildScrollView(
              child: Text(result.prompt),
            ),
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
      setState(() {
        _isOptimizing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Optimizer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Prompt Optimizer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Optimize your prompts for better AI generation results. The optimizer analyzes clarity, specificity, accessibility, creativity, and contextuality.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Optimization Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Method selection
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Ideation Method',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedMethod,
                      items: const [
                        DropdownMenuItem(value: 'crazy-8s', child: Text('Crazy 8s')),
                        DropdownMenuItem(value: 'mind-mapping', child: Text('Mind Mapping')),
                        DropdownMenuItem(value: 'random-stimulation', child: Text('Random Stimulation')),
                        DropdownMenuItem(value: 'constraint-based', child: Text('Constraint Based')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value!;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Optimization level
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Optimization Level',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedOptimizationLevel,
                      items: const [
                        DropdownMenuItem(value: 'minimal', child: Text('Minimal')),
                        DropdownMenuItem(value: 'standard', child: Text('Standard')),
                        DropdownMenuItem(value: 'aggressive', child: Text('Aggressive')),
                        DropdownMenuItem(value: 'adaptive', child: Text('Adaptive')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedOptimizationLevel = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Prompt input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Your Prompt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _promptController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Prompt to optimize',
                        hintText: 'Enter your AI prompt here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isOptimizing ? null : _optimizePrompt,
                        icon: _isOptimizing 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_fix_high),
                        label: Text(_isOptimizing ? 'Optimizing...' : 'Optimize Prompt'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Keywords test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test with Keywords',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Test the optimizer with game concept keywords',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _keywordsController,
                      decoration: const InputDecoration(
                        labelText: 'Keywords (comma-separated)',
                        hintText: 'puzzle, gravity, space, minimalist',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isOptimizing ? null : _testWithKeywords,
                        icon: const Icon(Icons.science),
                        label: const Text('Test Optimization'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results
            if (_optimizedPrompt != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Optimization Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Confidence and improvement
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              'Confidence',
                              '${(_optimizedPrompt!.confidence * 100).toStringAsFixed(1)}%',
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetricCard(
                              'Expected Improvement',
                              '${(_optimizedPrompt!.expectedImprovement * 100).toStringAsFixed(1)}%',
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Analysis scores
                      const Text(
                        'Analysis Scores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      _buildAnalysisScore('Clarity', _optimizedPrompt!.optimization.analysis.clarity),
                      _buildAnalysisScore('Specificity', _optimizedPrompt!.optimization.analysis.specificity),
                      _buildAnalysisScore('Accessibility', _optimizedPrompt!.optimization.analysis.accessibility),
                      _buildAnalysisScore('Creativity', _optimizedPrompt!.optimization.analysis.creativity),
                      _buildAnalysisScore('Contextuality', _optimizedPrompt!.optimization.analysis.contextuality),
                      
                      const SizedBox(height: 16),
                      
                      // Applied strategies
                      const Text(
                        'Applied Strategies',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      ..._optimizedPrompt!.optimization.strategies.map((strategy) => 
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.auto_fix_high, color: Colors.orange),
                            title: Text(strategy.description),
                            subtitle: Text(strategy.modifications.join(', ')),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Optimized prompt
                      const Text(
                        'Optimized Prompt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          _optimizedPrompt!.prompt,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisScore(String label, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                score > 0.7 ? Colors.green : score > 0.4 ? Colors.orange : Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${(score * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock ConceptGenerationInput for testing
class ConceptGenerationInput {
  ConceptGenerationInput({required this.keywords});
  final List<String> keywords;
} 