# LUVY Engine – Import/Export Schnittstellen Architektur-Entwurf

## 1. Einführung

Dieses Dokument beschreibt den Architektur-Entwurf für die Import- und Export-Schnittstellen von Projekten und Assets innerhalb der LUVY Engine. Das Ziel ist es, einen nahtlosen Austausch von Daten zwischen verschiedenen 3D-Engines und externen Tools zu ermöglichen, um die Co-Creation und den Game Jam-Prozess zu unterstützen.

## 2. Kernprinzipien

*   **Interoperabilität:** Ermöglicht den Datenaustausch zwischen verschiedenen Engines und Tools.
*   **Standardisierung:** Verwendung von offenen und weit verbreiteten Dateiformaten, wo immer möglich.
*   **Flexibilität:** Unterstützung verschiedener Import-/Export-Szenarien (ganze Projekte, einzelne Assets, Weltsegmente).
*   **Erweiterbarkeit:** Einfache Hinzufügung neuer Importer/Exporter über das Plug-in-System.
*   **Datenintegrität:** Sicherstellung der Konsistenz und Qualität der importierten/exportierten Daten.

## 3. Architektur-Komponenten

### 3.1. `IAssetImporter` und `IAssetExporter` Interfaces (im `data`-Modul oder neuem `asset_management`-Modul)

Diese Interfaces definieren die Verträge für das Importieren und Exportieren von Assets. Es könnte sinnvoll sein, ein neues Modul `asset_management` zu erstellen, das sich speziell um Asset-bezogene Logik kümmert, oder diese Interfaces vorerst im `data`-Modul zu platzieren. Für den Anfang platziere ich sie im `data`-Modul.

```dart
/// Defines the contract for importing assets into the LUVY Engine.
abstract interface class IAssetImporter {
  /// Unique identifier for the importer (e.g., 'gltf_importer', 'obj_importer').
  String get id;

  /// Human-readable name of the importer (e.g., 'glTF Importer', 'OBJ Importer').
  String get name;

  /// Supported file extensions (e.g., ['.gltf', '.glb']).
  List<String> get supportedExtensions;

  /// Imports asset data from the given [filePath].
  /// Returns a map representing the imported asset data.
  Future<Map<String, dynamic>> importAsset(String filePath);
}

/// Defines the contract for exporting assets from the LUVY Engine.
abstract interface class IAssetExporter {
  /// Unique identifier for the exporter (e.g., 'gltf_exporter', 'obj_exporter').
  String get id;

  /// Human-readable name of the exporter (e.g., 'glTF Exporter', 'OBJ Exporter').
  String get name;

  /// Supported file extensions (e.g., ['.gltf', '.glb']).
  List<String> get supportedExtensions;

  /// Exports asset data to the given [filePath].
  /// [assetData] contains the data structure representing the asset to export.
  Future<void> exportAsset(String filePath, Map<String, dynamic> assetData);
}
```

### 3.2. `IProjectImporter` und `IProjectExporter` Interfaces (im `data`-Modul oder `project_management`-Modul)

Ähnlich wie bei Assets könnten diese Interfaces in einem neuen `project_management`-Modul oder vorerst im `data`-Modul angesiedelt werden.

```dart
/// Defines the contract for importing entire projects into the LUVY Engine.
abstract interface class IProjectImporter {
  /// Unique identifier for the project importer.
  String get id;

  /// Human-readable name of the project importer.
  String get name;

  /// Supported project file extensions (e.g., ['.luvyproj']).
  List<String> get supportedExtensions;

  /// Imports project data from the given [filePath].
  /// Returns a map representing the imported project data.
  Future<Map<String, dynamic>> importProject(String filePath);
}

/// Defines the contract for exporting entire projects from the LUVY Engine.
abstract interface class IProjectExporter {
  /// Unique identifier for the project exporter.
  String get id;

  /// Human-readable name of the project exporter.
  String get name;

  /// Supported project file extensions (e.g., ['.luvyproj']).
  List<String> get supportedExtensions;

  /// Exports project data to the given [filePath].
  /// [projectData] contains the data structure representing the project to export.
  Future<void> exportProject(String filePath, Map<String, dynamic> projectData);
}
```

### 3.3. `AssetManager` und `ProjectManager` (im `data`-Modul oder neuen Modulen)

Diese Manager würden die Erkennung und Verwaltung der Importer/Exporter über das Plug-in-System übernehmen.

*   **`AssetManager`:**
    *   Verwaltet registrierte `IAssetImporter` und `IAssetExporter` Plug-ins.
    *   Bietet Methoden zum Importieren und Exportieren von Assets basierend auf Dateityp oder explizitem Importer/Exporter.
*   **`ProjectManager`:**
    *   Verwaltet registrierte `IProjectImporter` und `IProjectExporter` Plug-ins.
    *   Bietet Methoden zum Importieren und Exportieren ganzer Projekte.

### 3.4. Standardisierte Datenformate

Um die Interoperabilität zu gewährleisten, sollten standardisierte interne Datenformate für Assets und Projekte definiert werden.

*   **Für 3D-Assets:**
    *   **glTF (GL Transmission Format):** Ein offenes Standardformat für 3D-Szenen und -Modelle. Ideal für den Austausch von Modellen, Animationen, Materialien.
    *   **OBJ/MTL:** Einfach, aber weniger funktionsreich als glTF. Nützlich für grundlegende Geometrie.
    *   **Voxel-Datenformat:** Ein spezifisches Format für den Austausch von Voxel-basierten Welten (z.B. ein einfaches JSON- oder Binärformat, das Block-IDs und Positionen speichert).
*   **Für Projekte:**
    *   Ein proprietäres JSON-basiertes Format (`.luvyproj`), das Verweise auf Assets, Engine-Konfigurationen, Game Jam-Metadaten und andere projektspezifische Daten enthält.

### 3.5. Integration mit dem Plug-in-System

Alle Importer und Exporter sollten als Plug-ins implementiert werden, die das `IPlugin` Interface (aus dem `core`-Modul) und die jeweiligen `IAssetImporter`, `IAssetExporter`, `IProjectImporter` oder `IProjectExporter` Interfaces implementieren.

## 4. Kommunikations- und Datenfluss

1.  **UI-Interaktion:** Der Benutzer wählt im UI eine Import-/Export-Operation und eine Datei aus.
2.  **Manager-Delegation:** Die UI ruft die entsprechende Methode im `AssetManager` oder `ProjectManager` auf.
3.  **Importer/Exporter-Auswahl:** Der Manager identifiziert den passenden Importer/Exporter basierend auf der Dateierweiterung oder einer expliziten Auswahl.
4.  **Datenverarbeitung:** Der ausgewählte Importer/Exporter liest/schreibt die Daten und konvertiert sie in/aus dem internen LUVY Engine Datenformat.
5.  **Engine-Interaktion (für Import):** Nach dem Import eines Assets/Projekts kann der `EnginesManager` verwendet werden, um die Daten in die aktive 3D-Engine zu laden (z.B. `activeEngine.loadBlockWorld()`).
6.  **KI-Integration:** Importierte Assets oder Weltsegmente können an KI-Modelle (über das `Mindflow`-Modul) zur Analyse oder weiteren Generierung übergeben werden.

## 5. Nächste Schritte

*   Erstellung der `IAssetImporter`, `IAssetExporter`, `IProjectImporter`, `IProjectExporter` Interfaces im `data`-Modul.
*   Anpassung des `data`-Moduls, um diese Interfaces zu verwalten (ggf. `AssetManager` und `ProjectManager` erstellen).
*   Implementierung eines einfachen Dummy-Importers/Exporters (z.B. für ein einfaches Voxel-Format oder JSON).
*   Aktualisierung der `docs/TODO.md`.