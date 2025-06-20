# Assets Directory

This directory contains static assets for the JambaM application.

## Environment Configuration (.env)

The `.env` file contains environment variables for the application. 

### Setup Instructions

1. **Copy the example file:**
   ```bash
   cp assets/.env.example assets/.env
   ```

2. **Edit the .env file** with your actual configuration values:
   ```bash
   # API Configuration
   API_BASE_URL=https://your-api-url.com
   
   # Debug Mode
   DEBUG_MODE=true
   ```

3. **Never commit the .env file** - it's already in .gitignore

### Available Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_BASE_URL` | Base URL for API calls | `https://api.jambam.com` |
| `DEBUG_MODE` | Enable debug logging | `true` |
| `LOG_LEVEL` | Logging level (debug, info, warning, error) | `info` |

### Security Notes

- The `.env` file contains sensitive information
- It's automatically excluded from version control
- Use `.env.example` as a template for new environments
- Never hardcode secrets in the application code

### Troubleshooting

If you see a 404 error for `assets/.env`:
1. Ensure the file exists in the `assets/` directory
2. Verify it's listed in `pubspec.yaml` under `flutter.assets`
3. Run `flutter pub get` to refresh assets
4. Restart the development server 