import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/a_ideation/application/prompt_config_provider.dart';
import '../features/a_ideation/application/concept_agent.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'chip_demo_screen.dart';
import 'package:project_jambam/src/features/b_authentication_invite/invite_code_screen.dart';
import 'package:project_jambam/src/features/b_authentication/data/auth_repository_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _contextController;
  late TextEditingController _exampleController;
  late TextEditingController _styleController;
  String _userName = '';
  String _avatarUrl = '';
  String _appLanguage = 'Deutsch';
  String _promptLanguage = 'Deutsch';
  String _theme = 'System';
  String _apiKey = '';
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(promptConfigProvider);
    _contextController = TextEditingController(text: config.context);
    _exampleController = TextEditingController(text: config.example);
    _styleController = TextEditingController(text: config.style);
    // Demo: Defaultwerte für User-Profil
    _userName = 'JamFam-Mitglied';
    _avatarUrl = '';
    _appLanguage = 'Deutsch';
    _promptLanguage = 'Deutsch';
    _theme = 'System';
    _apiKey = '';
    _isPremium = false;
  }

  @override
  void dispose() {
    _contextController.dispose();
    _exampleController.dispose();
    _styleController.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(promptConfigProvider.notifier).state = PromptConfig(
      context: _contextController.text,
      example: _exampleController.text,
      style: _styleController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Einstellungen gespeichert!')),
    );
  }

  void _reset() {
    ref.read(promptConfigProvider.notifier).state = const PromptConfig(
      context: 'Das Ziel ist ein innovatives, gemeinschaftsorientiertes Spiel für den europäischen Markt.',
      example: 'Eine schwebende Inselwelt, inspiriert von europäischen Märchen, mit wechselnden Jahreszeiten.',
      style: 'Inspirierend, prägnant, kreativ, aber professionell.',
    );
    _contextController.text = ref.read(promptConfigProvider).context;
    _exampleController.text = ref.read(promptConfigProvider).example;
    _styleController.text = ref.read(promptConfigProvider).style;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Einstellungen zurückgesetzt!')),
    );
  }

  void _openAvatarGenerator() async {
    final url = await showDialog<String>(
      context: context,
      builder: (context) => const _AvatarGeneratorDialog(),
    );
    if (url != null && url.isNotEmpty) {
      setState(() => _avatarUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text('User-Profil', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Dein Anzeigename',
              ),
              onChanged: (v) => setState(() => _userName = v),
              controller: TextEditingController(text: _userName),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Avatar-URL (optional)',
                      hintText: 'https://...'
                    ),
                    onChanged: (v) => setState(() => _avatarUrl = v),
                    controller: TextEditingController(text: _avatarUrl),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('KI-Avatar generieren'),
                  onPressed: _openAvatarGenerator,
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Sprache', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _appLanguage,
              items: const [DropdownMenuItem(value: 'Deutsch', child: Text('Deutsch')), DropdownMenuItem(value: 'Englisch', child: Text('Englisch'))],
              onChanged: (v) => setState(() => _appLanguage = v ?? 'Deutsch'),
              decoration: const InputDecoration(labelText: 'App-Sprache'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _promptLanguage,
              items: const [DropdownMenuItem(value: 'Deutsch', child: Text('Deutsch')), DropdownMenuItem(value: 'Englisch', child: Text('Englisch'))],
              onChanged: (v) => setState(() => _promptLanguage = v ?? 'Deutsch'),
              decoration: const InputDecoration(labelText: 'Prompt-Sprache'),
            ),
            const Divider(height: 32),
            Text('Theme', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _theme,
              items: const [
                DropdownMenuItem(value: 'System', child: Text('System (Automatisch)')),
                DropdownMenuItem(value: 'Hell', child: Text('Hell')),
                DropdownMenuItem(value: 'Dunkel', child: Text('Dunkel')),
              ],
              onChanged: (v) => setState(() => _theme = v ?? 'System'),
              decoration: const InputDecoration(labelText: 'Theme'),
            ),
            const Divider(height: 32),
            Text('API-Key-Management', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Gemini/OpenAI API-Key',
                hintText: 'Wird nur lokal gespeichert',
                suffixIcon: Icon(Icons.vpn_key),
              ),
              obscureText: true,
              onChanged: (v) => setState(() => _apiKey = v),
              controller: TextEditingController(text: _apiKey),
            ),
            const SizedBox(height: 4),
            Text('Dein API-Key wird nur lokal gespeichert und nie an Dritte weitergegeben.', style: Theme.of(context).textTheme.bodySmall),
            const Divider(height: 32),
            Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: SwitchListTile.adaptive(
                    value: _isPremium,
                    onChanged: (v) => setState(() => _isPremium = v),
                    title: const Text('Premium-Status (Demo)'),
                    subtitle: const Text('Premium-User können Avatare privat halten.'),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Prompt-Konfiguration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _contextController,
              decoration: const InputDecoration(
                labelText: 'Kontext',
                hintText: 'Projektziel, Zielgruppe, etc.',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _exampleController,
              decoration: const InputDecoration(
                labelText: 'Beispielantwort',
                hintText: 'Beispiel für eine gute Antwort',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _styleController,
              decoration: const InputDecoration(
                labelText: 'Stilvorgabe',
                hintText: 'z.B. inspirierend, prägnant, kreativ',
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _save,
              label: const Text('Speichern'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              label: const Text('Zurücksetzen'),
            ),
            const Divider(height: 32),
            Text('Einladungscode', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.vpn_key),
              label: const Text('Einladungscode eingeben/prüfen'),
              onPressed: () {
                final userAsync = ref.read(currentUserProvider);
                userAsync.maybeWhen(
                  data: (user) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const InviteCodeScreen(),
                    ),
                  ),
                  orElse: () => null,
                );
              },
            ),
            const Divider(height: 32),
            Text('Entwicklung & Tests', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text('Enhanced Chips Demo'),
              subtitle: const Text('Teste die neuen farbigen Chip-Komponenten'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChipDemoScreen()),
                );
              },
            ),
            const Divider(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AvatarGeneratorDialog extends StatefulWidget {
  const _AvatarGeneratorDialog();

  @override
  State<_AvatarGeneratorDialog> createState() => _AvatarGeneratorDialogState();
}

class _AvatarGeneratorDialogState extends State<_AvatarGeneratorDialog> {
  static const defaultPrompts = [
    'Futuristischer Cartoon-Charakter, freundlich, bunt, leicht stilisiert, mit europäischem Flair, als Avatar, weißer Hintergrund',
    '3D Low-Poly Abenteurer, inspiriert von europäischen Märchen, mit leuchtenden Farben und freundlichem Gesicht, als Avatar, weißer Hintergrund',
    'Pixel-Art Held, modern interpretiert, mit einzigartigem Accessoire, als Avatar, weißer Hintergrund',
    'Comic-Stil, diverse Charaktere, inspirierend und inklusiv, mit leichtem Glanz-Effekt, als Avatar, weißer Hintergrund',
  ];
  String selectedPrompt = defaultPrompts[0];
  String model = 'Stable Diffusion (Hugging Face)';
  String? generatedUrl;
  bool isLoading = false;
  final promptController = TextEditingController(text: defaultPrompts[0]);
  bool? _savePrivate; // null = noch nicht gewählt
  List<String> generatedUrls = [];
  bool multiSampling = true;
  static const int freeLimit = 9;
  int freeGenerationsUsed = 0;
  DateTime? lastGenerationMonth;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadGenerationCounter();
    isPremium = context.findAncestorStateOfType<_SettingsScreenState>()?._isPremium ?? false;
  }

  Future<void> _loadGenerationCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final storedMonth = prefs.getString('avatar_gen_month');
    final storedCount = prefs.getInt('avatar_gen_count') ?? 0;
    final currentMonth = '${now.year}-${now.month}';
    if (storedMonth != currentMonth) {
      // Reset for new month
      await prefs.setString('avatar_gen_month', currentMonth);
      await prefs.setInt('avatar_gen_count', 0);
      setState(() {
        freeGenerationsUsed = 0;
        lastGenerationMonth = now;
      });
    } else {
      setState(() {
        freeGenerationsUsed = storedCount;
        lastGenerationMonth = now;
      });
    }
  }

  Future<void> _incrementGenerationCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month}';
    await prefs.setString('avatar_gen_month', currentMonth);
    await prefs.setInt('avatar_gen_count', freeGenerationsUsed + 1);
    setState(() {
      freeGenerationsUsed++;
    });
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (!isPremium && freeGenerationsUsed >= freeLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Du hast dein kostenloses Kontingent für diesen Monat erreicht. Upgrade auf Premium für mehr!')),
      );
      return;
    }
    setState(() { isLoading = true; generatedUrls = []; generatedUrl = null; });
    final prompt = promptController.text;
    final sampleCount = multiSampling ? 4 : 1;
    List<String> urls = [];
    if (model == 'Stable Diffusion (Hugging Face)') {
      urls = await _generateWithHuggingFace(prompt, sampleCount);
    } else {
      urls = await _generateWithGemini(prompt, sampleCount);
    }
    setState(() { isLoading = false; generatedUrls = urls; });
    if (!isPremium) await _incrementGenerationCounter();
  }

  Future<List<String>> _generateWithHuggingFace(String prompt, int samples) async {
    const endpoint = 'https://stablediffusionapi.com/api/v3/text2img';
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'negative_prompt': 'blurry, low quality, watermark, text, nsfw',
        'width': 512,
        'height': 512,
        'samples': samples,
        'num_inference_steps': 30,
        'guidance_scale': 7.5,
        'seed': null,
        'webhook': null,
        'track_id': null,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['output'] != null && data['output'] is List && data['output'].isNotEmpty) {
        return List<String>.from(data['output'].take(samples));
      }
    }
    // Fallback: Demo-URLs
    return List.generate(samples, (i) => 'https://placehold.co/256x256/png?text=Avatar+${i+1}');
  }

  Future<List<String>> _generateWithGemini(String prompt, int samples) async {
    final apiKey = (context.findAncestorStateOfType<_SettingsScreenState>()?._apiKey ?? '').trim();
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte API-Key in den Einstellungen eintragen!')),
      );
      return [];
    }
    final endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$apiKey';
    final body = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    };
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'] is List && data['candidates'].isNotEmpty) {
        final candidate = data['candidates'][0];
        if (candidate['content'] != null && candidate['content']['parts'] != null) {
          final parts = candidate['content']['parts'];
          final urls = <String>[];
          for (final part in parts) {
            if (part['inlineData'] != null && part['inlineData']['mimeType'] == 'image/png') {
              final base64 = part['inlineData']['data'];
              urls.add('data:image/png;base64,$base64');
            }
            if (part['text'] != null && part['text'].toString().startsWith('http')) {
              urls.add(part['text']);
            }
          }
          if (urls.isNotEmpty) return urls.take(samples).toList();
        }
      }
    }
    // Fallback: Demo-URLs
    return List.generate(samples, (i) => 'https://placehold.co/256x256/png?text=Gemini+${i+1}');
  }

  Future<void> _showSaveDialog(String url) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avatar speichern'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: url,
              width: 96,
              height: 96,
              placeholder: (context, url) => const SizedBox(
                width: 96,
                height: 96,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error, size: 48),
            ),
            const SizedBox(height: 12),
            if (isPremium) ...[
              RadioListTile<bool>(
                value: true,
                groupValue: _savePrivate,
                onChanged: (v) => setState(() => _savePrivate = v),
                title: const Text('Privat speichern'),
                subtitle: const Text('Nur du kannst diesen Avatar nutzen.'),
              ),
            ],
            RadioListTile<bool>(
              value: false,
              groupValue: _savePrivate,
              onChanged: (v) => setState(() => _savePrivate = v),
              title: const Text('Im Marktplatz freigeben'),
              subtitle: const Text('Andere Nutzer können diesen Avatar sehen und verwenden.'),
            ),
            const SizedBox(height: 8),
            Text(
              isPremium
                ? 'Premium-User können Avatare privat halten. Kostenlose Nutzer geben sie automatisch für die Community frei.'
                : 'Als kostenloser Nutzer werden deine generierten Avatare automatisch im Marktplatz/Community geteilt.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Speichern'),
            onPressed: _savePrivate != null ? () => Navigator.of(context).pop(_savePrivate) : null,
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (result != null) {
      // Demo: Avatar wird lokal gespeichert, Backend folgt
      Navigator.of(context).pop(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('KI-Avatar generieren'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Stable Diffusion (Hugging Face) ist kostenlos, aber öffentlich (Prompts/Bilder können in der Community sichtbar sein).\nGoogle Gemini ist privat, benötigt aber einen API-Key aus den Einstellungen.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (!isPremium) ...[
              Text('Kostenlose Generierungen diesen Monat: $freeGenerationsUsed / $freeLimit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
              ),
              if (freeGenerationsUsed >= freeLimit)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Limit erreicht! Upgrade auf Premium für mehr.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 8),
            ],
            DropdownButtonFormField<String>(
              value: selectedPrompt,
              items: defaultPrompts.map((p) => DropdownMenuItem(value: p, child: Text(p, maxLines: 2, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    selectedPrompt = v;
                    promptController.text = v;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Stil-Vorschlag'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: promptController,
              decoration: const InputDecoration(labelText: 'Prompt (bearbeitbar)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: model,
              items: const [
                DropdownMenuItem(value: 'Stable Diffusion (Hugging Face)', child: Text('Stable Diffusion (Hugging Face, kostenlos)')),
                DropdownMenuItem(value: 'Gemini', child: Text('Google Gemini (API-Key)')),
              ],
              onChanged: (v) => setState(() => model = v ?? 'Stable Diffusion (Hugging Face)'),
              decoration: const InputDecoration(labelText: 'Modell'),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: multiSampling,
              onChanged: (v) => setState(() => multiSampling = v),
              title: const Text('Mehrere Vorschläge generieren (Multi-Sampling)'),
              subtitle: const Text('Bis zu 4 verschiedene Avatare pro Durchgang'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generieren'),
              onPressed: isLoading ? null : _generate,
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (generatedUrls.isNotEmpty) ...[
              if (multiSampling) ...[
                const Text('Wähle deinen Favoriten:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final url in generatedUrls)
                      GestureDetector(
                        onTap: () => _showSaveDialog(url),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              width: 96,
                              height: 96,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error, size: 48),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Tippe auf ein Bild, um es zu speichern.'), // const
              ] else ...[
                const Text('Vorschau:'), // const
                const SizedBox(height: 8),
                CachedNetworkImage(
                  imageUrl: generatedUrls.first,
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    width: 128,
                    height: 128,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error, size: 64),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save), // const
                  label: const Text('Speichern'),
                  onPressed: () => _showSaveDialog(generatedUrls.first),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }
} 