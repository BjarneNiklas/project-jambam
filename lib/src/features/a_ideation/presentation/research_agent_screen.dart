import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/research_agent.dart';
import '../data/research_agent_config.dart' as config;

class ResearchAgentScreen extends ConsumerStatefulWidget {
  const ResearchAgentScreen({super.key});

  @override
  ConsumerState<ResearchAgentScreen> createState() => _ResearchAgentScreenState();
}

class _ResearchAgentScreenState extends ConsumerState<ResearchAgentScreen>
    with TickerProviderStateMixin {
  final TextEditingController _queryController = TextEditingController();
  final ResearchAgent _researchAgent = ResearchAgent();
  final config.ResearchAgentConfig _config = config.ResearchAgentConfig();

  // Store UI specific details for each source type
  final Map<config.ResearchSourceType, Map<String, dynamic>> _sourceUIDetails = {
    config.ResearchSourceType.arxiv: {
      'name': 'ArXiv',
      'icon': FontAwesomeIcons.archive,
      'colors': [Colors.red.shade400, Colors.orange.shade600],
      'url': 'https://arxiv.org/'
    },
    config.ResearchSourceType.pubmed: {
      'name': 'PubMed',
      'icon': FontAwesomeIcons.notesMedical,
      'colors': [Colors.blue.shade400, Colors.teal.shade600],
      'url': 'https://pubmed.ncbi.nlm.nih.gov/'
    },
    config.ResearchSourceType.doj: {
      'name': 'DOAJ',
      'icon': FontAwesomeIcons.bookOpen,
      'colors': [Colors.green.shade400, Colors.lightGreen.shade600],
      'url': 'https://doaj.org/'
    },
    config.ResearchSourceType.crossref: {
      'name': 'Crossref',
      'icon': FontAwesomeIcons.link,
      'colors': [Colors.purple.shade400, Colors.pink.shade600],
      'url': 'https://crossref.org/'
    },
    config.ResearchSourceType.semanticScholar: {
      'name': 'Semantic Scholar',
      'icon': FontAwesomeIcons.brain,
      'colors': [Colors.cyan.shade400, Colors.blue.shade700],
      'url': 'https://www.semanticscholar.org/'
    },
    config.ResearchSourceType.ieee: {
      'name': 'IEEE Xplore',
      'icon': FontAwesomeIcons.microchip,
      'colors': [Colors.indigo.shade400, Colors.blue.shade800],
      'url': 'https://ieeexplore.ieee.org/'
    },
    config.ResearchSourceType.acm: {
      'name': 'ACM Digital Library',
      'icon': FontAwesomeIcons.laptopCode,
      'colors': [Colors.lightBlue.shade400, Colors.cyan.shade700],
      'url': 'https://dl.acm.org/'
    },
    config.ResearchSourceType.openAlex: {
      'name': 'OpenAlex',
      'icon': FontAwesomeIcons.globe,
      'colors': [Colors.teal.shade300, Colors.green.shade600],
      'url': 'https://openalex.org/'
    },
    config.ResearchSourceType.dblp: {
      'name': 'DBLP',
      'icon': FontAwesomeIcons.database,
      'colors': [Colors.amber.shade400, Colors.orange.shade700],
      'url': 'https://dblp.org/'
    },
    config.ResearchSourceType.core: {
      'name': 'CORE',
      'icon': FontAwesomeIcons.atom,
      'colors': [Colors.pink.shade300, Colors.red.shade500],
      'url': 'https://core.ac.uk/'
    },
    config.ResearchSourceType.springer: {
      'name': 'SpringerLink',
      'icon': FontAwesomeIcons.book,
      'colors': [Colors.lime.shade400, Colors.green.shade700],
      'url': 'https://link.springer.com/'
    },
    config.ResearchSourceType.elsevier: {
      'name': 'ScienceDirect',
      'icon': FontAwesomeIcons.flask,
      'colors': [Colors.orange.shade300, Colors.deepOrange.shade500],
      'url': 'https://www.sciencedirect.com/'
    },
    config.ResearchSourceType.steam: {
      'name': 'Steam',
      'icon': FontAwesomeIcons.steamSymbol,
      'colors': [Colors.grey.shade700, Colors.blueGrey.shade900],
      'url': 'https://store.steampowered.com/'
    },
    config.ResearchSourceType.twitch: {
      'name': 'Twitch',
      'icon': FontAwesomeIcons.twitch,
      'colors': [Colors.purple.shade600, Colors.deepPurple.shade800],
      'url': 'https://twitch.tv/'
    },
    config.ResearchSourceType.reddit: {
      'name': 'Reddit',
      'icon': FontAwesomeIcons.redditAlien,
      'colors': [Colors.orange.shade700, Colors.red.shade900],
      'url': 'https://reddit.com/'
    },
    config.ResearchSourceType.youtube: {
      'name': 'YouTube',
      'icon': FontAwesomeIcons.youtube,
      'colors': [Colors.red.shade600, Colors.red.shade900],
      'url': 'https://youtube.com/'
    },
    config.ResearchSourceType.itchio: {
      'name': 'Itch.io',
      'icon': FontAwesomeIcons.gamepad,
      'colors': [Colors.pink.shade400, Colors.red.shade600],
      'url': 'https://itch.io/'
    },
    config.ResearchSourceType.gameDevBlogs: {
      'name': 'Game Dev Blogs',
      'icon': FontAwesomeIcons.blog,
      'colors': [Colors.brown.shade400, Colors.brown.shade700],
      'url': 'https://gamedeveloper.com/'
    },
  };
  
  late AnimationController _loadingController;
  late AnimationController _resultsController;
  
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
  }

  @override
  void dispose() {
    _queryController.dispose();
    _loadingController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  Future<void> _performResearch() async {
    if (_queryController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _currentResult = null;
    });

    _loadingController.repeat();

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

  Widget _buildSourceBadge(ResearchSource source) { // `source` is from `../data/research_agent.dart`
    // Convert the string source.source (e.g. "ArXiv") to ResearchSourceType enum
    config.ResearchSourceType? sourceEnumType;
    try {
      // Assuming source.source from ResearchAgent matches the enum names (case-insensitive)
      sourceEnumType = config.ResearchSourceType.values.firstWhere(
        (e) => e.name.toLowerCase() == source.source.toLowerCase(),
      );
    } catch (e) {
      // Handle if no match, or source.source is not a valid enum name
      sourceEnumType = null;
    }

    final sourceDetails = sourceEnumType != null ? _sourceUIDetails[sourceEnumType] : null;

    if (sourceDetails == null) {
      return Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${source.source} (Config missing)',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
      );
    }

    final String displayName = sourceDetails['name'] as String? ?? source.source;
    final IconData icon = sourceDetails['icon'] as IconData? ?? FontAwesomeIcons.questionCircle;
    final List<Color> colors = (sourceDetails['colors'] as List<Color>?) ?? [Colors.grey, Colors.blueGrey];
    // Use the specific paper's URL from ResearchSource, not the base URL from _sourceUIDetails for onTap
    final String launchableUrl = source.url.isNotEmpty ? source.url : (sourceDetails['url'] as String? ?? '#');


    return GestureDetector(
      onTap: () => _launchSourceUrl(launchableUrl), // Use actual paper URL
      child: Container(
        // ... rest of the styling using displayName, icon, colors ...
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.length >= 2 ? colors : [Colors.grey, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (colors.isNotEmpty ? colors[0] : Colors.grey).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              displayName, // Use displayName from UI details
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