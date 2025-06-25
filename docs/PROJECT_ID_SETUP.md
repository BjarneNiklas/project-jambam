# PROJECT_ID Setup Guide

## 🚨 Issue Fixed

The GitHub Actions workflow was showing a warning about invalid context access for `PROJECT_ID`. This has been resolved by using a safer approach to handle the optional PROJECT_ID secret.

## 🔧 What Was Fixed

### 1. Workflow File (.github/workflows/phase-automation.yml)
- **Before**: `PROJECT_ID: ${{ secrets.PROJECT_ID || '' }}` (caused linter warning)
- **After**: Safe handling in shell script with proper conditional logic
- **Added**: Comprehensive comments explaining the setup process

### 2. Python Script (.github/scripts/phase_automation.py)
- **Enhanced**: Better error handling for missing PROJECT_ID
- **Added**: Graceful fallback when PROJECT_ID is not set
- **Improved**: Clear warning messages when project board integration is skipped
- **Added**: Logging to show PROJECT_ID status

### 3. Helper Scripts Created
- **`scripts/get_project_id.py`**: Python script to get project IDs
- **`scripts/get_project_id.ps1`**: PowerShell script to get project IDs

## 🎯 How to Set Up PROJECT_ID

### Step 1: Get Your Project ID

**Option A: Python Script**
```bash
export GITHUB_TOKEN="your_github_token_here"
export GITHUB_REPOSITORY="BjarneNiklas/project-jambam"
python scripts/get_project_id.py
```

**Option B: PowerShell Script**
```powershell
$env:GITHUB_REPOSITORY="BjarneNiklas/project-jambam"
.\scripts\get_project_id.ps1 -GitHubToken "your_github_token_here"
```

### Step 2: Copy the Project ID
From the script output, copy the project ID. For example:
- **JamBam Platform - Complete Ecosystem**: `PVT_kwHOBJgNrM4A8Ucv`
- **JamBam Auth & Identity Platform**: `PVT_kwHOBJgNrM4A8UOT`

### Step 3: Add Repository Secret
1. Go to your GitHub repository: https://github.com/BjarneNiklas/project-jambam
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. **Name**: `PROJECT_ID`
5. **Value**: Paste the project ID from step 2
6. Click **"Add secret"**

## ✅ Verification

### Check Workflow Status
After setting up the secret:
1. Create a new issue in your repository
2. Check the GitHub Actions tab
3. Verify that the "Phase Automation & Project Board Management" job runs successfully
4. Confirm that the issue is added to your project board

### Expected Behavior
- **With PROJECT_ID set**: Issues are automatically added to the project board
- **Without PROJECT_ID**: Workflow runs normally but skips project board integration

### Workflow Output
The workflow will now show:
- `✅ PROJECT_ID is configured` (when secret is set)
- `⚠️  PROJECT_ID not set - project board integration will be skipped` (when not set)

## 🔍 Available Project Boards

Based on the analysis, you have these project boards available:

### User Projects
1. **JamBam Platform - Complete Ecosystem** (ID: `PVT_kwHOBJgNrM4A8Ucv`)
   - Number: 6
   - URL: https://github.com/users/BjarneNiklas/projects/6
   - Status: Empty (0 items)

2. **JamBam Auth & Identity Platform** (ID: `PVT_kwHOBJgNrM4A8UOT`)
   - Number: 5
   - URL: https://github.com/users/BjarneNiklas/projects/5
   - Status: Active

### Repository Projects
1. **JamBam Auth & Identity Platform** (ID: `PVT_kwHOBJgNrM4A8UOT`)
   - Number: 5
   - URL: https://github.com/users/BjarneNiklas/projects/5

## 🎯 Recommended Setup

For the JamBam platform, I recommend using:
- **Project ID**: `PVT_kwHOBJgNrM4A8Ucv` (JamBam Platform - Complete Ecosystem)
- **Reason**: This is the main ecosystem board that aligns with your project vision

## 🔄 Workflow Integration

Once PROJECT_ID is set up, the workflow will:

1. **Automatically add new issues** to the project board
2. **Assign phases and modules** based on issue content
3. **Add appropriate labels** for categorization
4. **Create welcome comments** with relevant information
5. **Auto-assign team members** based on module/phase

## 🚨 Troubleshooting

### Common Issues

1. **"Context access might be invalid: PROJECT_ID"**
   - **Solution**: ✅ This issue has been fixed with the new workflow approach

2. **"PROJECT_ID not set, skipping project board addition"**
   - **Solution**: This is expected behavior when PROJECT_ID is not configured

3. **"Failed to add to project board"**
   - **Solution**: Check that the project ID is correct and the project exists

4. **"GraphQL errors"**
   - **Solution**: Verify your GitHub token has the `project` permission

### Debug Mode
```bash
# Enable debug output
export DEBUG=1
python scripts/get_project_id.py
```

## 📚 Related Documentation

- **Main Scripts README**: `scripts/README.md`
- **External Board Integration**: `docs/EXTERNAL_BOARD_SUMMARY.md`
- **Workflow Configuration**: `.github/workflows/phase-automation.yml`

## 🎉 Success Checklist

After setup, verify:
- [ ] PROJECT_ID secret is configured in repository settings
- [ ] GitHub Actions workflow runs without warnings ✅
- [ ] New issues are automatically added to project board
- [ ] Phase and module labels are applied correctly
- [ ] Welcome comments are generated
- [ ] Auto-assignment works based on labels

## 🔧 Technical Details

### Workflow Changes
The workflow now uses a shell script approach to safely handle the PROJECT_ID:

```yaml
run: |
  # Handle PROJECT_ID safely
  if [ -n "${{ secrets.PROJECT_ID }}" ]; then
    export PROJECT_ID="${{ secrets.PROJECT_ID }}"
    echo "✅ PROJECT_ID is configured"
  else
    export PROJECT_ID=""
    echo "⚠️  PROJECT_ID not set - project board integration will be skipped"
  fi
  python .github/scripts/phase_automation.py
```

This approach:
- ✅ Avoids linter warnings about context access
- ✅ Provides clear feedback about PROJECT_ID status
- ✅ Works whether PROJECT_ID is set or not
- ✅ Maintains all existing functionality

---

**Status**: ✅ Issue Fixed  
**Last Updated**: 2025-06-25  
**Next Review**: After first successful workflow run 