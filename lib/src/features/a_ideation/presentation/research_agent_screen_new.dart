import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/research_agent.dart';
import '../data/research_agent_config.dart' as config;

class ResearchAgentScreenNew extends ConsumerStatefulWidget {
  const ResearchAgentScreenNew({super.key});

  @override
  ConsumerState<ResearchAgentScreenNew> createState() => _ResearchAgentScreenNewState();
}

class _ResearchAgentScreenNewState extends ConsumerState<ResearchAgentScreenNew>
    with TickerProviderStateMixin {
  final TextEditingController _queryController = TextEditingController();
  final ResearchAgent _researchAgent = ResearchAgent();
  final config.ResearchAgentConfig _config = config.ResearchAgentConfig();
  
  late AnimationController _loadingController;
  late AnimationController _resultsController;
  late AnimationController _fadeController;
  
  ResearchResult? _currentResult;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedSource = 'all';
  
  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _resultsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _loadingController.dispose();
    _resultsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _performResearch() async {
    if (_queryController.text.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    _loadingController.repeat();
    _fadeController.forward();
    
    try {
      final result = await _researchAgent.research(_queryController.text.trim());
      
      setState(() {
        _currentResult = result;
        _isLoading = false;
      });
      
      _resultsController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Recherche: $e')),
        );
      }
    } finally {
      _loadingController.stop();
    }
  }

  Future<void> _launchSourceUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Konnte Link nicht öffnen: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSourceBadge(ResearchSource source) {
    final sourceName = source.source.toLowerCase();
    final sourceInfo = _getSourceConfig()[sourceName];
    
    return GestureDetector(
      onTap: () => _launchSourceUrl(sourceInfo['url']),
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: sourceInfo['colors'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: sourceInfo['colors'][0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              sourceInfo['icon'],
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              sourceInfo['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const FaIcon(
              FontAwesomeIcons.externalLinkAlt,
              size: 10,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getSourceConfig() {
    return {
      'arxiv': _config.getSourceConfig(config.ResearchSourceType.arxiv)?.toJson(),
      'pubmed': _config.getSourceConfig(config.ResearchSourceType.pubmed)?.toJson(),
      'doj': _config.getSourceConfig(config.ResearchSourceType.doj)?.toJson(),
      'crossref': _config.getSourceConfig(config.ResearchSourceType.crossref)?.toJson(),
      'semanticScholar': _config.getSourceConfig(config.ResearchSourceType.semanticScholar)?.toJson(),
      'ieee': _config.getSourceConfig(config.ResearchSourceType.ieee)?.toJson(),
      'acm': _config.getSourceConfig(config.ResearchSourceType.acm)?.toJson(),
      'openAlex': _config.getSourceConfig(config.ResearchSourceType.openAlex)?.toJson(),
      'dblp': _config.getSourceConfig(config.ResearchSourceType.dblp)?.toJson(),
      'core': _config.getSourceConfig(config.ResearchSourceType.core)?.toJson(),
      'springer': _config.getSourceConfig(config.ResearchSourceType.springer)?.toJson(),
      'elsevier': _config.getSourceConfig(config.ResearchSourceType.elsevier)?.toJson(),
      'steam': _config.getSourceConfig(config.ResearchSourceType.steam)?.toJson(),
      'twitch': _config.getSourceConfig(config.ResearchSourceType.twitch)?.toJson(),
      'reddit': _config.getSourceConfig(config.ResearchSourceType.reddit)?.toJson(),
      'youtube': _config.getSourceConfig(config.ResearchSourceType.youtube)?.toJson(),
      'itchio': _config.getSourceConfig(config.ResearchSourceType.itchio)?.toJson(),
      'gameDevBlogs': _config.getSourceConfig(config.ResearchSourceType.gameDevBlogs)?.toJson(),
    };
  }

  Widget _buildResearchResult(ResearchResult result) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            result.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Summary
          Text(
            result.summary,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          // Key Insights
          if (result.keyInsights.isNotEmpty) ...[
            Text(
              'Key Insights',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...result.keyInsights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      insight,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
          ],
          
          // Sources
          Text(
            'Sources',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            children: result.sources.map((source) => _buildSourceBadge(source)).toList(),
          ),
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Export to PDF
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF Export - Coming Soon!')),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.filePdf),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Export to Markdown
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Markdown Export - Coming Soon!')),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.code),
                  label: const Text('Export Markdown'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Research Agent'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.questionCircle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Research Agent Hilfe'),
                  content: const Text(
                    'Der Research Agent durchsucht 18 verschiedene Quellen für Game Design Forschung:\n\n'
                    '• 12 wissenschaftliche APIs (ArXiv, PubMed, IEEE, etc.)\n'
                    '• 6 praktische APIs (Steam, Twitch, Reddit, etc.)\n\n'
                    'Klicke auf die Source-Badges um direkt zu den Original-Quellen zu springen!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Verstanden'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Forschungsfrage eingeben... (z.B. "procedural generation games")',
                    prefixIcon: const FaIcon(FontAwesomeIcons.search),
                    suffixIcon: _isLoading
                        ? AnimatedBuilder(
                            animation: _loadingController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _loadingController.value * 2 * 3.14159,
                                child: const FaIcon(FontAwesomeIcons.spinner),
                              );
                            },
                          )
                        : IconButton(
                            icon: const FaIcon(FontAwesomeIcons.paperPlane),
                            onPressed: _performResearch,
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onSubmitted: (_) => _performResearch(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Durchsucht 18 Quellen: 12 wissenschaftliche + 6 praktische APIs',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results Section
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _loadingController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _loadingController.value * 2 * 3.14159,
                              child: const FaIcon(
                                FontAwesomeIcons.spinner,
                                size: 48,
                                color: Colors.blue,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Durchsuche 18 Quellen...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Wissenschaftliche + Praktische APIs',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.exclamationTriangle,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Fehler beim Research',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : _currentResult != null
                        ? SingleChildScrollView(
                            child: _buildResearchResult(_currentResult!),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.search,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Starte deine Game Design Forschung',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Gib eine Forschungsfrage ein und\nklicke auf die Source-Badges für Details',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
          ),
        ],
      ),
    );
  }
} 