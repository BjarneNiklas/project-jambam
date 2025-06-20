import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'concept_agent.dart';

final promptConfigProvider = StateProvider<PromptConfig>((ref) => const PromptConfig(
  context: 'Das Ziel ist ein innovatives, gemeinschaftsorientiertes Spiel für den europäischen Markt.',
  example: 'Eine schwebende Inselwelt, inspiriert von europäischen Märchen, mit wechselnden Jahreszeiten.',
  style: 'Inspirierend, prägnant, kreativ, aber professionell.',
)); 