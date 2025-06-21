# Plugin Manifest (`plugin.json`) Specification

Every plugin for the LUVY Platform must include a `plugin.json` file in its root directory. This manifest defines the plugin's metadata, compatibility, and dependencies, ensuring seamless integration and management by the platform.

---

## Example

```json
{
  "id": "my_awesome_plugin",
  "name": "My Awesome Plugin",
  "className": "MyAwesomePlugin",
  "version": "1.2.0",
  "author": "Jane Doe",
  "description": "Adds awesome features to the platform.",
  "minVersion": "1.0.0",
  "maxVersion": "2.0.0",
  "dependencies": ["core_plugin"]
}
```

---

## Field Reference

| Field         | Type     | Required | Description                                                                 |
|---------------|----------|----------|-----------------------------------------------------------------------------|
| `id`          | String   | Yes      | Unique identifier for the plugin.                                           |
| `name`        | String   | Yes      | Human-readable name of the plugin.                                          |
| `className`   | String   | Yes      | Dart class name implementing the plugin (must extend `Plugin`).             |
| `version`     | String   | Yes      | Plugin version (semantic versioning, e.g., `1.2.0`).                        |
| `author`      | String   | No       | Plugin author or maintainer.                                                |
| `description` | String   | No       | Short description of the plugin.                                            |
| `minVersion`  | String   | No       | Minimum compatible platform version (default: `1.0.0`).                     |
| `maxVersion`  | String   | No       | Maximum compatible platform version (default: `2.0.0`).                     |
| `dependencies`| Array    | No       | List of plugin IDs this plugin depends on.                                  |

---

## Professional Notes

- **Version Compatibility:** Plugins with missing or incompatible `minVersion`/`maxVersion` will be skipped at load time. Always keep these fields up to date for future-proofing.
- **Class Registration:** The `className` must match a class registered in the plugin registry and must extend the `Plugin` base class.
- **Dependencies:** List all required plugins in `dependencies` to ensure correct load order and activation.
- **Maintainability:** Keep all fields accurate and descriptive to facilitate debugging, analytics, and user experience.
- **Security:** Avoid hardcoding sensitive data in the manifest. Use secure APIs for secrets and tokens.

---

For further details, see the [Plugin Development Guide](plugin_development_guide.md) or contact the LUVY Platform core team. 