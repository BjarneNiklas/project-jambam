import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart'; // To get a temporary directory
import 'package:share_plus/share_plus.dart'; // To share the exported file/text
import 'package:permission_handler/permission_handler.dart'; // To request permissions
import '../application/prompt_config_provider.dart'; // For prompt settings
import 'package:shared_preferences/shared_preferences.dart'; // For avatar generation limits
import '../data/jamba_ai_chat_provider.dart'; // For chat history
import 'package:url_launcher/url_launcher.dart'; // For opening folder
import 'dart:io'; // For Directory operations

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExporting = false;
  double _exportProgress = 0.0;

  // Data for projects
  final List<_Project> _projects = [
    _Project(id: 'proj1', name: 'AI Adventure Quest', details: 'Unity • 450MB', color: Colors.blue, isInitiallySelected: true),
    _Project(id: 'proj2', name: 'Flutter RPG', details: 'Flutter • 280MB', color: Colors.indigo),
    _Project(id: 'proj3', name: 'Web Strategy Game', details: 'Web • 120MB', color: Colors.green, isInitiallySelected: true),
    _Project(id: 'proj4', name: '3D Platformer', details: 'Unity • 890MB', color: Colors.orange),
  ];
  Set<String> _selectedProjectIds = {};

  // Data for project export formats
  final List<_ExportFormat> _projectExportFormats = [
    _ExportFormat(id: 'fmtProj1', name: 'Unity Package', description: 'Complete Unity project with all assets', size: '450MB', color: Colors.blue, isInitiallySelected: true),
    _ExportFormat(id: 'fmtProj2', name: 'Flutter Package', description: 'Flutter project with dependencies', size: '280MB', color: Colors.indigo),
    _ExportFormat(id: 'fmtProj3', name: 'Web Build', description: 'HTML5 build for web deployment', size: '120MB', color: Colors.green, isInitiallySelected: true), // Assuming last selected wins if multiple are true
    _ExportFormat(id: 'fmtProj4', name: 'Source Code', description: 'Raw source code and assets', size: '890MB', color: Colors.orange),
    _ExportFormat(id: 'fmtProj5', name: 'Documentation', description: 'Project documentation and guides', size: '45MB', color: Colors.purple, isInitiallySelected: true),
  ];
  String? _selectedProjectExportFormatId;

  // State for export options
  bool _includeDependencies = true;
  bool _compressFiles = true;
  bool _includeDocumentation = false;
  bool _createBackup = true;

  // Data for asset categories
  final List<_AssetCategory> _assetCategories = [
    _AssetCategory(id: 'assetCat1', name: '3D Models', files: '156 files', size: '890MB', color: Colors.blue, isInitiallySelected: true),
    _AssetCategory(id: 'assetCat2', name: 'Textures', files: '234 files', size: '450MB', color: Colors.green, isInitiallySelected: true),
    _AssetCategory(id: 'assetCat3', name: 'Audio', files: '89 files', size: '280MB', color: Colors.orange, isInitiallySelected: true),
    _AssetCategory(id: 'assetCat4', name: 'Animations', files: '67 files', size: '180MB', color: Colors.purple, isInitiallySelected: true),
  ];
  Set<String> _selectedAssetCategoryIds = {};

  // Data for asset export formats
  final List<_AssetExportFormat> _assetExportFormats = [
    _AssetExportFormat(id: 'assetFmt1', name: 'FBX', typeDescription: '3D Models', color: Colors.blue, isInitiallySelected: true),
    _AssetExportFormat(id: 'assetFmt2', name: 'PNG', typeDescription: 'Textures', color: Colors.green, isInitiallySelected: true),
    _AssetExportFormat(id: 'assetFmt3', name: 'MP3', typeDescription: 'Audio', color: Colors.orange),
    _AssetExportFormat(id: 'assetFmt4', name: 'GIF', typeDescription: 'Animations', color: Colors.purple, isInitiallySelected: true), // Last one true wins for single select
    _AssetExportFormat(id: 'assetFmt5', name: 'ZIP', typeDescription: 'Compressed', color: Colors.grey),
  ];
  String? _selectedAssetExportFormatId;

  // State for asset export
  bool _isExportingAssets = false;
  double _assetExportProgress = 0.0;

  // Data for data types
  final List<_DataType> _dataTypes = [
    _DataType(id: 'data1', name: 'User Profile', description: 'Personal information', size: '2MB', color: Colors.blue, isInitiallySelected: true),
    _DataType(id: 'data2', name: 'Project History', description: 'All project data', size: '15MB', color: Colors.green, isInitiallySelected: true),
    _DataType(id: 'data3', name: 'Analytics', description: 'Performance metrics', size: '8MB', color: Colors.orange, isInitiallySelected: true),
    _DataType(id: 'data4', name: 'Achievements', description: 'Earned achievements', size: '5MB', color: Colors.purple, isInitiallySelected: true),
    _DataType(id: 'data5', name: 'Social Data', description: 'Connections and activity', size: '15MB', color: Colors.teal, isInitiallySelected: true),
  ];
  Set<String> _selectedDataTypeIds = {};

  @override
  void initState() {
    super.initState(); // Should be first
    _tabController = TabController(length: 3, vsync: this);
    // Initialize selected projects based on their isInitiallySelected property
    _selectedProjectIds = _projects
        .where((p) => p.isInitiallySelected)
        .map((p) => p.id)
        .toSet();

    // Initialize selected project export format
    final initiallySelectedFormat = _projectExportFormats.lastWhere(
      (f) => f.isInitiallySelected,
      orElse: () => _projectExportFormats.isNotEmpty ? _projectExportFormats.first : null,
    );
    if (initiallySelectedFormat != null) {
      _selectedProjectExportFormatId = initiallySelectedFormat.id;
    }

    // Initialize selected asset categories
    _selectedAssetCategoryIds = _assetCategories
        .where((c) => c.isInitiallySelected)
        .map((c) => c.id)
        .toSet();

    // Initialize selected asset export format
    final initiallySelectedAssetFormat = _assetExportFormats.lastWhere(
      (f) => f.isInitiallySelected,
      orElse: () => _assetExportFormats.isNotEmpty ? _assetExportFormats.first : null,
    );
    if (initiallySelectedAssetFormat != null) {
      _selectedAssetExportFormatId = initiallySelectedAssetFormat.id;
    }

    // Initialize selected data types
    _selectedDataTypeIds = _dataTypes
        .where((d) => d.isInitiallySelected)
        .map((d) => d.id)
        .toSet();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Future<void> _exportSettings() async {
    // Gather settings data
    final promptConfig = ref.read(promptConfigProvider);
    final prefs = await SharedPreferences.getInstance();

    // Accessing settings from _SettingsScreenState is tricky directly.
    // For now, I'll export what's easily accessible globally or via SharedPreferences.
    // Ideally, these settings (userName, avatarUrl, appLanguage, promptLanguage, theme)
    // would be in their own Riverpod provider.
    // I will create a placeholder for them for now.

    final settingsData = {
      'promptConfig': {
        'context': promptConfig.context,
        'example': promptConfig.example,
        'style': promptConfig.style,
      },
      'avatarGeneration': {
        'month': prefs.getString('avatar_gen_month'),
        'count': prefs.getInt('avatar_gen_count'),
      },
      // Placeholder for other settings - these would ideally come from a provider
      'userProfile': {
        'userName': 'Demo User', // Placeholder
        'avatarUrl': '', // Placeholder
      },
      'preferences': {
        'appLanguage': 'Deutsch', // Placeholder
        'promptLanguage': 'Deutsch', // Placeholder
        'theme': 'System', // Placeholder
      }
    };

    final jsonString = jsonEncode(settingsData);

    try {
      // Use share_plus to share the JSON string. User can then save it as a file.
      await Share.share(jsonString, subject: 'ProjectJambam_Settings_Export.json');
       if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings ready to be shared/saved!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting settings: $e')),
      );
    }
  }

  Future<void> _exportHistory() async {
    final chatState = ref.read(jambaAIChatProvider);
    final messages = chatState.messages.map((msg) => {
      'id': msg.id,
      'content': msg.content,
      'isUser': msg.isUser,
      'timestamp': msg.timestamp.toIso8601String(),
      'agentName': msg.agentName,
    }).toList();

    final historyData = {
      'chatHistory': messages,
      // TODO: Potentially include JamKit history here if available
    };

    final jsonString = jsonEncode(historyData);

    try {
      await Share.share(jsonString, subject: 'ProjectJambam_History_Export.json');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('History ready to be shared/saved!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting history: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _exportHistory, // Updated
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _exportSettings, // Updated
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'PROJECTS'),
            Tab(text: 'ASSETS'),
            Tab(text: 'DATA'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProjectsTab(),
          _buildAssetsTab(),
          _buildDataTab(),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExportHeader(),
          const SizedBox(height: 16),
          _buildProjectSelectionCard(),
          const SizedBox(height: 16),
          _buildExportFormatsCard(),
          const SizedBox(height: 16),
          _buildExportOptionsCard(),
          const SizedBox(height: 16),
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildExportHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.teal[400]!, Colors.cyan[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.file_download, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Export',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Export your projects in various formats',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildExportStat('Projects', '12', Colors.white),
                _buildExportStat('Total Size', '2.4GB', Colors.white),
                _buildExportStat('Formats', '8', Colors.white),
                _buildExportStat('Last Export', '2d ago', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSelectionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Projects',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Dynamically build project items
            for (final project in _projects)
              _buildProjectItem(project), // Pass the whole project object

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectAllProjects,
                    child: const Text('Select All'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearProjectSelection,
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectAllProjects() {
    setState(() {
      _selectedProjectIds = _projects.map((p) => p.id).toSet();
    });
  }

  void _clearProjectSelection() {
    setState(() {
      _selectedProjectIds.clear();
    });
  }

  Widget _buildProjectItem(_Project project) { // Updated to take _Project object
    final isSelected = _selectedProjectIds.contains(project.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedProjectIds.add(project.id);
                } else {
                  _selectedProjectIds.remove(project.id);
                }
              });
            },
            activeColor: project.color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  project.details,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? project.color : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildExportFormatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Formats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Dynamically build format items
            for (final format in _projectExportFormats)
              _buildFormatItem(format),

          ],
        ),
      ),
    );
  }

  Widget _buildFormatItem(_ExportFormat format) { // Updated to take _ExportFormat object
    final isSelected = _selectedProjectExportFormatId == format.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Checkbox( // Using Checkbox but acting like Radio
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedProjectExportFormatId = format.id;
                }
                // If value is false, it means user is unchecking.
                // For radio-button like behavior, we don't allow unchecking to 'no selection'
                // unless explicitly designed. Current setup: clicking another makes it active.
                // So, if a checkbox is unchecked, it's because another was checked.
              });
            },
            activeColor: format.color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  format.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  format.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            format.size,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOptionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Include Dependencies'),
              subtitle: const Text('Include all project dependencies'),
              value: _includeDependencies,
              onChanged: (value) {
                setState(() {
                  _includeDependencies = value;
                });
              },
              secondary: const Icon(Icons.link),
            ),
            SwitchListTile(
              title: const Text('Compress Files'),
              subtitle: const Text('Reduce file size with compression'),
              value: _compressFiles,
              onChanged: (value) {
                setState(() {
                  _compressFiles = value;
                });
              },
              secondary: const Icon(Icons.compress),
            ),
            SwitchListTile(
              title: const Text('Include Documentation'),
              subtitle: const Text('Add README and setup guides'),
              value: _includeDocumentation,
              onChanged: (value) {
                setState(() {
                  _includeDocumentation = value;
                });
              },
              secondary: const Icon(Icons.description),
            ),
            SwitchListTile(
              title: const Text('Create Backup'),
              subtitle: const Text('Create backup before export'),
              value: _createBackup,
              onChanged: (value) {
                setState(() {
                  _createBackup = value;
                });
              },
              secondary: const Icon(Icons.backup),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isExporting) ...[
              const Text(
                'Exporting...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _exportProgress,
                backgroundColor: Colors.grey.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${(_exportProgress * 100).toInt()}% complete',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              const Text(
                'Ready to Export',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total size: 1.2GB',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _startExport();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Start Export',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _startExport() {
    setState(() {
      _isExporting = true;
      _exportProgress = 0.0;
    });

    // Simulate export progress
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _exportProgress = 0.2;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _exportProgress = 0.5;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _exportProgress = 0.8;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _exportProgress = 1.0;
          _isExporting = false;
        });
        _showExportCompleteDialog();
      }
    });
  }

  void _showExportCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Complete'),
        content: const Text(
          'Your projects have been successfully exported!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openExportFolder(); // Call the new method
            },
            child: const Text('Open Folder'),
          ),
        ],
      ),
    );
  }

  Future<void> _openExportFolder() async {
    try {
      Directory? exportDir;
      if (Platform.isAndroid || Platform.isIOS) {
        // On mobile, getApplicationDocumentsDirectory is a good private place.
        // For a more "user-accessible" folder, Downloads might be an option,
        // but requires more setup (permissions, platform channels for specific paths).
        // Let's use app documents for simplicity and reliability.
        exportDir = await getApplicationDocumentsDirectory();
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        // For desktop, Downloads directory is usually preferred.
        exportDir = await getDownloadsDirectory();
      }

      if (exportDir == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not determine export directory for this platform.')),
        );
        return;
      }

      final jambamExportsPath = '${exportDir.path}${Platform.pathSeparator}ProjectJambamExports';
      final jambamExportsDir = Directory(jambamExportsPath);

      if (!await jambamExportsDir.exists()) {
        await jambamExportsDir.create(recursive: true);
      }

      final uri = Uri.file(jambamExportsDir.path);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open folder: ${jambamExportsDir.path}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening export folder: $e')),
      );
    }
  }

  Widget _buildAssetsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAssetsHeader(),
        const SizedBox(height: 16),
        _buildAssetCategoriesCard(),
        const SizedBox(height: 16),
        _buildAssetFormatsCard(),
        const SizedBox(height: 16),
        _buildAssetExportButton(),
      ],
    );
  }

  Widget _buildAssetsHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.image, color: Colors.teal, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Asset Export',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '1.8GB total',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCategoriesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asset Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (final category in _assetCategories)
              _buildAssetCategoryItem(category),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCategoryItem(_AssetCategory category) { // Updated parameter
    final isSelected = _selectedAssetCategoryIds.contains(category.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.folder, color: category.color, size: 20), // Use category.color
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name, // Use category.name
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${category.files} • ${category.size}', // Use category.files and category.size
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedAssetCategoryIds.add(category.id);
                } else {
                  _selectedAssetCategoryIds.remove(category.id);
                }
              });
            },
            activeColor: category.color, // Use category.color
          ),
        ],
      ),
    );
  }

  Widget _buildAssetFormatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Formats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (final format in _assetExportFormats)
              _buildAssetFormatItem(format),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetFormatItem(_AssetExportFormat format) { // Renamed parameter, using new class
    final isSelected = _selectedAssetExportFormatId == format.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Checkbox( // Using Checkbox but acting like Radio
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedAssetExportFormatId = format.id;
                }
                // For radio-button like behavior
              });
            },
            activeColor: format.color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  format.name, // Use format.name
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  format.typeDescription, // Use format.typeDescription
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetExportButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isExportingAssets) ...[
              const Text(
                'Exporting Assets...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _assetExportProgress,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${(_assetExportProgress * 100).toInt()}% complete',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              const Text(
                'Ready to Export Assets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedAssetCategoryIds.isEmpty
                    ? 'No asset categories selected'
                    : 'Selected: ${_selectedAssetCategoryIds.length} categor${_selectedAssetCategoryIds.length == 1 ? 'y' : 'ies'}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isExportingAssets ? null : _exportAssets,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Export Assets',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _exportAssets() async {
    if (_selectedAssetCategoryIds.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select asset categories to export.')),
      );
      return;
    }
    if (_selectedAssetExportFormatId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an export format for assets.')),
      );
      return;
    }

    setState(() {
      _isExportingAssets = true;
      _assetExportProgress = 0.0;
    });

    // Simulate export progress
    // In a real app, this would involve actual file operations.
    final totalSteps = _selectedAssetCategoryIds.length;
    for (int i = 0; i < totalSteps; i++) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate work for each category
      if (mounted) {
        setState(() {
          _assetExportProgress = (i + 1) / totalSteps;
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 300)); // Finalizing

    if (mounted) {
      setState(() {
        _isExportingAssets = false;
      });
      _showAssetExportCompleteDialog();
    }
  }

  void _showAssetExportCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asset Export Complete'),
        content: const Text(
          'Your selected assets have been successfully exported (simulated)!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openExportFolder(); // Re-use the existing open folder logic
            },
            child: const Text('Open Folder'),
          ),
        ],
      ),
    );
  }


  Widget _buildDataTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDataHeader(),
        const SizedBox(height: 16),
        _buildDataTypesCard(),
        const SizedBox(height: 16),
        _buildDataFormatsCard(),
        const SizedBox(height: 16),
        _buildDataExportButton(),
      ],
    );
  }

  Widget _buildDataHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.data_usage, color: Colors.teal, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Data Export',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '45MB total',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTypesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Types',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (final dataType in _dataTypes)
              _buildDataTypeItem(dataType),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTypeItem(_DataType dataType) { // Updated parameter
    final isSelected = _selectedDataTypeIds.contains(dataType.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.storage, color: dataType.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataType.name, // Use dataType.name
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  dataType.description, // Use dataType.description
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            dataType.size, // Use dataType.size
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedDataTypeIds.add(dataType.id);
                } else {
                  _selectedDataTypeIds.remove(dataType.id);
                }
              });
            },
            activeColor: dataType.color,
          ),
        ],
      ),
    );
  }

  Widget _buildDataFormatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Formats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDataFormatItem('JSON', 'Structured data format', true, Colors.blue),
            _buildDataFormatItem('CSV', 'Spreadsheet format', false, Colors.green),
            _buildDataFormatItem('XML', 'Markup format', false, Colors.orange),
            _buildDataFormatItem('PDF', 'Document format', true, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildDataFormatItem(String format, String description, bool isSelected, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              // TODO: Update format selection
            },
            activeColor: color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  format,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataExportButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Export Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: 45MB',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Export data
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Export Data',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple data class for Project
class _Project {
  final String id;
  final String name;
  final String details;
  final Color color;
  final bool isInitiallySelected;

  _Project({
    required this.id,
    required this.name,
    required this.details,
    required this.color,
    this.isInitiallySelected = false,
  });
}

// Simple data class for Asset Export Format
class _AssetExportFormat {
  final String id;
  final String name;
  final String typeDescription; // e.g., "3D Models", "Textures"
  final Color color;
  final bool isInitiallySelected;

  _AssetExportFormat({
    required this.id,
    required this.name,
    required this.typeDescription,
    required this.color,
    this.isInitiallySelected = false,
  });
}

// Simple data class for Asset Category
class _AssetCategory {
  final String id;
  final String name;
  final String files;
  final String size;
  final Color color;
  final bool isInitiallySelected;

  _AssetCategory({
    required this.id,
    required this.name,
    required this.files,
    required this.size,
    required this.color,
    this.isInitiallySelected = false,
  });
}

// Simple data class for Data Type
class _DataType {
  final String id;
  final String name;
  final String description;
  final String size;
  final Color color;
  final bool isInitiallySelected;

  _DataType({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    required this.color,
    this.isInitiallySelected = false,
  });
}

// Simple data class for Export Format
class _ExportFormat {
  final String id;
  final String name;
  final String description;
  final String size;
  final Color color;
  final bool isInitiallySelected;

  _ExportFormat({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    required this.color,
    this.isInitiallySelected = false,
  });
}