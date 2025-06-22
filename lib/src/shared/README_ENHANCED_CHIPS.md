# Enhanced Chips - Verbesserte Chip-Komponenten

## Übersicht

Die Enhanced Chips sind eine Sammlung verbesserter Chip-Widgets, die eine deutlich sichtbare farbige Hervorhebung für ausgewählte Zustände bieten. Sie sind besonders nützlich für Multi-Select-Funktionalitäten und bieten eine bessere Benutzererfahrung.

## Features

### 🎨 Visuelle Verbesserungen
- **Farbige Hervorhebung**: Ausgewählte Chips werden deutlich farbig hervorgehoben
- **Animierte Übergänge**: Smooth Animationen beim Auswählen/Abwählen
- **Schatten-Effekte**: Ausgewählte Chips erhalten einen subtilen Schatten
- **Dynamische Farben**: Automatische Anpassung an das Theme
- **Checkmark-Indikatoren**: Visuelle Bestätigung der Auswahl

### 🔧 Flexibilität
- **Icons**: Unterstützung für normale und ausgewählte Icons
- **Custom Colors**: Individuelle Farben für verschiedene Kategorien
- **Multi-Select**: Optimiert für mehrere Auswahlen
- **Single-Select**: Perfekt für exklusive Auswahlen
- **Action Chips**: Für Aktionen ohne Auswahlzustand

## Komponenten

### EnhancedChip
Die Basis-Komponente für alle Enhanced Chips.

```dart
EnhancedChip(
  label: 'Mein Chip',
  isSelected: true,
  onSelected: (selected) => print('Ausgewählt: $selected'),
  icon: Icons.star,
  selectedIcon: Icons.star_filled,
  selectedColor: Colors.blue,
  isMultiSelect: true,
)
```

### EnhancedFilterChip
Für Multi-Select-Funktionalität (mehrere Auswahlen möglich).

```dart
EnhancedFilterChip(
  label: 'Animation',
  selected: _selectedAnimations.contains('idle'),
  onSelected: (selected) {
    setState(() {
      if (selected) {
        _selectedAnimations.add('idle');
      } else {
        _selectedAnimations.remove('idle');
      }
    });
  },
  icon: Icons.add,
  selectedIcon: Icons.check,
  selectedColor: Colors.primary,
)
```

### EnhancedChoiceChip
Für Single-Select-Funktionalität (nur eine Auswahl möglich).

```dart
EnhancedChoiceChip(
  label: 'Creative',
  selected: _selectedMode == 'creative',
  onSelected: (selected) {
    if (selected) {
      setState(() => _selectedMode = 'creative');
    }
  },
  icon: Icons.brush,
  selectedIcon: Icons.auto_awesome,
  selectedColor: Colors.purple,
)
```

### EnhancedActionChip
Für Aktionen ohne Auswahlzustand.

```dart
EnhancedActionChip(
  label: 'AI Supported',
  onPressed: () => _handleAIAction(),
  icon: Icons.psychology,
  color: Colors.secondary,
  backgroundColor: Colors.secondaryContainer,
)
```

## Verwendung in verschiedenen Screens

### Asset Generation Screen
```dart
// Animation-Auswahl mit Multi-Select
EnhancedFilterChip(
  label: animation,
  selected: _selectedAnimations.contains(animation),
  onSelected: (selected) {
    setState(() {
      if (selected) {
        _selectedAnimations.add(animation);
      } else {
        _selectedAnimations.remove(animation);
      }
    });
  },
  icon: Icons.add,
  selectedIcon: Icons.check,
  selectedColor: Theme.of(context).colorScheme.primary,
)
```

### Ideation Methods Screen
```dart
// Kategorie-Filter mit farbiger Hervorhebung
EnhancedFilterChip(
  label: _getCategoryName(category),
  selected: _selectedCategory == category,
  onSelected: (selected) {
    setState(() {
      _selectedCategory = category;
    });
  },
  selectedColor: _getCategoryColor(category),
  backgroundColor: colorScheme.surfaceContainerHighest,
)
```

### Jam Kit Generation Screen
```dart
// Inspiration Mode mit Icons
EnhancedChoiceChip(
  label: 'Creative',
  selected: _selectedInspirationMode == 'creative',
  onSelected: (selected) {
    if (selected) {
      setState(() => _selectedInspirationMode = 'creative');
    }
  },
  icon: Icons.brush,
  selectedIcon: Icons.auto_awesome,
  selectedColor: Colors.purple,
)
```

## Demo Screen

Um alle Enhanced Chips in Aktion zu sehen, können Sie den `ChipDemoScreen` verwenden:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ChipDemoScreen()),
);
```

## Vorteile gegenüber Standard Chips

### ✅ Verbesserungen
- **Bessere Sichtbarkeit**: Ausgewählte Chips sind deutlich erkennbar
- **Konsistente Farbgebung**: Automatische Anpassung an das Theme
- **Flexible Icons**: Verschiedene Icons für normalen und ausgewählten Zustand
- **Smooth Animationen**: Professionelle Übergänge
- **Multi-Select Optimiert**: Perfekt für mehrere Auswahlen
- **Accessibility**: Bessere Kontraste und visuelle Hinweise

### 🎯 Besonders nützlich für
- **Multi-Select Szenarien**: Animationen, Tags, Kategorien
- **Filter-Funktionen**: Komplexitäts-Filter, Kategorie-Filter
- **Einstellungen**: Modus-Auswahl, Präferenzen
- **Aktions-Buttons**: Schnellfilter, Aktionen

## Migration von Standard Chips

### Von FilterChip zu EnhancedFilterChip
```dart
// Vorher
FilterChip(
  label: Text('Animation'),
  selected: isSelected,
  onSelected: (selected) => handleSelection(selected),
)

// Nachher
EnhancedFilterChip(
  label: 'Animation',
  selected: isSelected,
  onSelected: (selected) => handleSelection(selected),
  icon: Icons.add,
  selectedIcon: Icons.check,
  selectedColor: Colors.primary,
)
```

### Von ChoiceChip zu EnhancedChoiceChip
```dart
// Vorher
ChoiceChip(
  label: Text('Mode'),
  selected: isSelected,
  onSelected: (selected) => handleSelection(selected),
)

// Nachher
EnhancedChoiceChip(
  label: 'Mode',
  selected: isSelected,
  onSelected: (selected) => handleSelection(selected),
  icon: Icons.category,
  selectedIcon: Icons.check,
  selectedColor: Colors.primary,
)
```

## Best Practices

### 🎨 Farbgebung
- Verwenden Sie kategorispezifische Farben für bessere Unterscheidung
- Nutzen Sie das Theme-System für konsistente Farben
- Achten Sie auf ausreichenden Kontrast für Accessibility

### 🔧 Icons
- Verwenden Sie intuitive Icons für bessere UX
- Unterschiedliche Icons für normalen und ausgewählten Zustand
- Konsistente Icon-Größen (16px empfohlen)

### 📱 Responsive Design
- Chips passen sich automatisch an verschiedene Bildschirmgrößen an
- Wrap-Widget für automatisches Umbruch
- Angemessene Abstände zwischen Chips (8px empfohlen)

### ♿ Accessibility
- Ausreichende Kontraste für bessere Lesbarkeit
- Klare visuelle Hinweise für ausgewählte Zustände
- Unterstützung für Screen Reader

## Technische Details

### Animationen
- **Dauer**: 200ms für smooth Übergänge
- **Kurve**: `Curves.easeInOut` für natürliche Bewegung
- **Eigenschaften**: Farbe, Border, Schatten, Text-Style

### Performance
- **Optimiert**: Minimale Rebuilds durch effiziente State-Management
- **Memory**: Geringer Speicherverbrauch durch Shared Components
- **Rendering**: Hardware-beschleunigte Animationen

### Theme-Integration
- **Automatisch**: Anpassung an das aktuelle Theme
- **Fallback**: Sichere Standard-Farben wenn Theme-Farben nicht verfügbar
- **Konsistent**: Einheitliche Farbgebung in der gesamten App 