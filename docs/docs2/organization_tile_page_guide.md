# Organization Tile Page Guide

## 1. Overview

The `OrganizationTilePage` is a versatile Flutter widget designed to display content for an organization in a structured and visually appealing manner. It dynamically builds a page based on a JSON configuration, allowing for easy customization of content sections, display styles (grid, list, carousel), and individual content items. This enables developers to create rich, informative pages for different organizations or services without modifying the core widget code.

## 2. Data Models

The behavior and content of the `OrganizationTilePage` are driven by a set of data models defined in `lib/models/organization_content.dart`.

### `OrganizationPageConfig`
This is the root model for an organization's page configuration.

| Field      | Type                  | Required | Description                                     |
|------------|-----------------------|----------|-------------------------------------------------|
| `id`       | `String`              | Yes      | A unique identifier for the page configuration. |
| `title`    | `String`              | Yes      | The title to be displayed in the AppBar.        |
| `sections` | `List<ContentSection>` | Yes      | A list of content sections for the page.        |

### `ContentSection`
Represents a distinct section of content on the page.

| Field         | Type                   | Required | Description                                                                 |
|---------------|------------------------|----------|-----------------------------------------------------------------------------|
| `id`          | `String`               | Yes      | A unique identifier for the section.                                        |
| `title`       | `String`               | Yes      | The title of the section, displayed as a header.                            |
| `displayType` | `SectionDisplayType`   | Yes      | Defines how items in this section are displayed (`grid`, `list`, `carousel`). |
| `items`       | `List<ContentItem>`    | Yes      | A list of content items within this section.                                |

### `SectionDisplayType` (Enum)
Defines the visual layout for items within a `ContentSection`.

| Value      | Description                                                                                                |
|------------|------------------------------------------------------------------------------------------------------------|
| `grid`     | Displays items in a grid layout. Currently, the grid defaults to 2 columns.                                |
| `list`     | Displays items in a vertical list.                                                                         |
| `carousel` | (Placeholder) Intended for a horizontally scrolling carousel of items. Currently renders a placeholder.      |

### `ContentItem`
Represents an individual piece of content to be displayed.

| Field         | Type     | Required | Description                                                                              |
|---------------|----------|----------|------------------------------------------------------------------------------------------|
| `id`          | `String` | Yes      | A unique identifier for the content item.                                                |
| `title`       | `String` | Yes      | The main title of the item.                                                              |
| `description` | `String?`| No       | Optional additional text describing the item.                                            |
| `imageUrl`    | `String?`| No       | Optional URL for an image. Can be a network URL (starting with `http`/`https`) or an asset path. |
| `linkUrl`     | `String?`| No       | Optional URL or deep link path for navigation when the item is tapped.                   |
| `type`        | `String?`| No       | Optional type identifier (e.g., 'video', 'article', 'course', 'tile', 'info'). Currently not used for specific rendering logic like icons, but can be used for semantic categorization. |

## 3. JSON Configuration File Structure

The `OrganizationTilePage` is configured using a JSON file. This file must adhere to the structure defined by the data models.

### Field Descriptions & Structure:

The JSON structure directly maps to the `OrganizationPageConfig`, `ContentSection`, and `ContentItem` models.

-   **Root Object (`OrganizationPageConfig`):**
    -   `id` (String, required): Unique ID for the entire page configuration.
    *   `title` (String, required): Title for the AppBar of the page.
    -   `sections` (Array, required): List of `ContentSection` objects.

-   **`ContentSection` Object:**
    -   `id` (String, required): Unique ID for the section.
    -   `title` (String, required): Header title for the section.
    -   `displayType` (String, required): How items are displayed. Valid values:
        -   `"grid"`: Items arranged in a grid. (Note: `gridCrossAxisCount` is not currently configurable via JSON; defaults to 2 columns in the widget).
        -   `"list"`: Items arranged in a vertical list.
        -   `"carousel"`: (Placeholder for future implementation).
    -   `items` (Array, required): List of `ContentItem` objects.

-   **`ContentItem` Object:**
    -   `id` (String, required): Unique ID for the item.
    -   `title` (String, required): Title of the item.
    -   `description` (String, optional): Detailed text.
    -   `imageUrl` (String, optional): URL or asset path for an image.
    -   `linkUrl` (String, optional): Navigation link.
    -   `type` (String, optional): Semantic type of the content.

### Example JSON:

```json
{
  "id": "sample_org_config",
  "title": "Sample Organization",
  "sections": [
    {
      "id": "section1",
      "title": "Featured Products",
      "displayType": "grid",
      "items": [
        {
          "id": "item1_prod_alpha",
          "title": "Product Alpha",
          "description": "Description for Product Alpha, a high-quality item for your needs.",
          "imageUrl": "ui/assets/images/placeholder_avatar.png",
          "linkUrl": "/products/alpha",
          "type": "product"
        },
        {
          "id": "item2_service_beta",
          "title": "Service Beta",
          "description": "Details about Service Beta, offering comprehensive solutions.",
          "imageUrl": "https://via.placeholder.com/150/FF0000/FFFFFF?Text=ServiceBeta",
          "type": "service"
        }
      ]
    },
    {
      "id": "section2_news",
      "title": "Latest News & Updates",
      "displayType": "list",
      "items": [
        {
          "id": "news1_announcement",
          "title": "Big Announcement!",
          "description": "We have some exciting news to share with our community and stakeholders.",
          "linkUrl": "/news/1",
          "type": "announcement"
        },
        {
          "id": "news2_update",
          "title": "Platform Update v2.1",
          "description": "Version 2.1 of our platform is now live with new features and improvements.",
          "type": "update"
        }
      ]
    }
  ]
}
```

## 4. `OrganizationConfigService`

This service, located in `lib/services/organization_config_service.dart`, provides methods to load the `OrganizationPageConfig` from different sources.

### `loadFromAssets(String assetPath)`
Loads the configuration from a JSON file included in the app's assets.

-   **Usage:**
    ```dart
    final configService = OrganizationConfigService();
    try {
      // Ensure 'assets/your_org_config.json' is listed in pubspec.yaml
      final config = await configService.loadFromAssets('assets/organization_pages/your_org_config.json');
      // Use the config object
    } catch (e) {
      print('Error loading from assets: $e');
    }
    ```

### `loadFromUrl(String url)`
Loads the configuration from a JSON file hosted on a network server.

-   **Usage:**
    ```dart
    final configService = OrganizationConfigService();
    try {
      final config = await configService.loadFromUrl('https://api.example.com/your_org_config.json');
      // Use the config object
    } catch (e) {
      print('Error loading from URL: $e');
    }
    ```
    *Note: Requires the `http` package.*

## 5. Using `OrganizationTilePage` Widget

To display an organization page, you typically use a `FutureBuilder` along with the `OrganizationConfigService` to load the configuration, and then pass the loaded data to the `OrganizationTilePage` widget.

### Example (`your_org_screen.dart`):

```dart
import 'package:flutter/material.dart';
// Adjust these import paths based on your project structure
import 'package:your_app_name/models/organization_content.dart';
import 'package:your_app_name/services/organization_config_service.dart';
import 'package:your_app_name/widgets/organization_tile_page.dart';

class YourOrgScreen extends StatefulWidget {
  const YourOrgScreen({super.key});

  @override
  State<YourOrgScreen> createState() => _YourOrgScreenState();
}

class _YourOrgScreenState extends State<YourOrgScreen> {
  late final OrganizationConfigService _configService;
  Future<OrganizationPageConfig>? _configFuture;

  @override
  void initState() {
    super.initState();
    _configService = OrganizationConfigService();
    // Load your specific configuration file
    _configFuture = _configService.loadFromAssets('assets/organization_pages/your_org_config.json');
    // OR from a URL:
    // _configFuture = _configService.loadFromUrl('https://api.example.com/your_org_config.json');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrganizationPageConfig>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading configuration: ${snapshot.error}'),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // Pass the loaded config to the OrganizationTilePage
          return OrganizationTilePage(pageConfig: snapshot.data!);
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Unknown error loading configuration.'),
              ),
            ),
          );
        }
      },
    );
  }
}
```

## 6. Adding New Organization Pages

To add a new organization page to your app:

1.  **Create the JSON Configuration File:**
    *   Define the content and structure for the new organization according to the JSON format described in Section 3.
    *   Save this file, typically in a structured way within your `assets` directory (e.g., `assets/organization_pages/new_org_config.json`).

2.  **Register Asset in `pubspec.yaml`:**
    *   If you are loading the configuration from local assets, ensure the path to your new JSON file (or its directory) is included in the `flutter -> assets` section of your `pubspec.yaml` file.
    ```yaml
    flutter:
      uses-material-design: true
      assets:
        - assets/organization_pages/ # This includes all files in the directory
        # OR explicitly:
        # - assets/organization_pages/new_org_config.json
    ```

3.  **Create a Loader Page (Optional but Recommended):**
    *   Create a new Dart file for your organization's screen (e.g., `lib/screens/new_org_screen.dart`).
    *   Implement this screen similar to the example in Section 5, making sure to update the asset path in `initState()` to point to your new JSON file.
    ```dart
    // In lib/screens/new_org_screen.dart
    // ...
    @override
    void initState() {
      super.initState();
      _configService = OrganizationConfigService();
      _configFuture = _configService.loadFromAssets('assets/organization_pages/new_org_config.json'); // <-- Update this path
    }
    // ...
    ```

4.  **Navigate to the New Page:**
    *   Add navigation logic in your app (e.g., from a main menu or a list of organizations) to route to your newly created screen.

By following these steps, you can easily extend your application with multiple, uniquely configured organization tile pages.
```
