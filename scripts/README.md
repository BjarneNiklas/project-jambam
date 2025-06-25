# JambaM Login System - Automated Kanban Board Creation

This directory contains scripts to automatically create GitHub Project Boards and issues for the JambaM Login System implementation.

## 🚀 Quick Start

### Prerequisites

1. **GitHub Personal Access Token**
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Create a new token with the following permissions:
     - `repo` (Full control of private repositories)
     - `project` (Full control of projects)
     - `write:packages` (Upload packages to GitHub Package Registry)

2. **Repository Access**
   - Ensure you have write access to the `project-jambam` repository
   - Update the `OwnerName` in the scripts to match your GitHub username

## 📋 Available Scripts

### 1. Login System Kanban Board
**Python Script (Cross-platform)**
```bash
# Set your GitHub token
export GITHUB_TOKEN="your_github_token_here"

# Run the script
python scripts/create_login_kanban_board.py
```

**PowerShell Script (Windows)**
```powershell
# Run the script with your GitHub token
.\scripts\create_login_kanban_board.ps1 -GitHubToken "your_github_token_here"
```

### 2. External Board Reference Integration
**Python Script (Cross-platform)**
```bash
# Set your GitHub token
export GITHUB_TOKEN="your_github_token_here"

# Run the script to integrate external board
python scripts/reference_external_board.py
```

**PowerShell Script (Windows)**
```powershell
# Run the script with your GitHub token
.\scripts\reference_external_board.ps1 -GitHubToken "your_github_token_here"

# Run in dry-run mode
.\scripts\reference_external_board.ps1 -GitHubToken "your_github_token_here" -WhatIf
```

### 3. Complete Ecosystem Setup
**Python Script (Cross-platform)**
```bash
# Set your GitHub token
export GITHUB_TOKEN="your_github_token_here"

# Run the complete ecosystem script
python scripts/create_jambam_complete_ecosystem.py
```

**PowerShell Script (Windows)**
```powershell
# Run the complete ecosystem script
.\scripts\create_jambam_phases_board.ps1 -GitHubToken "your_github_token_here"
```

## 🎯 What Gets Created

### Login System Kanban Board
- **Name**: "JambaM Login System Implementation"
- **Description**: Complete login system implementation with Supabase, guest login, and offline capabilities
- **Visibility**: Public

### Kanban Columns
```
📋 BACKLOG → 📝 TO DO → 🔄 IN PROGRESS → 👀 REVIEW → 🧪 TESTING → ✅ DONE
```

### Issues Created (7 total)
1. **Supabase Authentication Integration** (13 SP) - Critical
2. **Guest Login Implementation** (8 SP) - High
3. **Offline Login Implementation** (8 SP) - Medium
4. **Supabase Project Setup & Configuration** (2 SP) - Critical
5. **Database Schema Implementation** (3 SP) - Critical
6. **Anonymous Authentication Setup** (2 SP) - High
7. **Offline State Detection** (2 SP) - Medium

### External Board Integration
- **Reference Issue**: Links to external board with analysis
- **Integration Documentation**: Strategy and planning document
- **Board Analysis**: Item count, structure, and suggested approach
- **Integration Options**: Reference, Mirror, or Migration strategies

## 🔧 Configuration

### Environment Variables
- `GITHUB_TOKEN`: Your GitHub personal access token
- `GITHUB_REPO`: Repository name (default: "project-jambam")
- `GITHUB_OWNER`: Repository owner (default: "your-github-username")

### Project Board Integration (Optional)
To enable automatic project board integration, you need to set up the `PROJECT_ID` secret:

#### 1. Get Your Project ID
**Python Script:**
```bash
export GITHUB_TOKEN="your_github_token_here"
export GITHUB_REPOSITORY="BjarneNiklas/project-jambam"
python scripts/get_project_id.py
```

**PowerShell Script:**
```powershell
$env:GITHUB_REPOSITORY="BjarneNiklas/project-jambam"
.\scripts\get_project_id.ps1 -GitHubToken "your_github_token_here"
```

#### 2. Set Up Repository Secret
1. Go to your repository on GitHub
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `PROJECT_ID`
5. Value: [paste the project ID from step 1]
6. Click "Add secret"

#### 3. Verify Setup
The workflow will now automatically add new issues to your project board. If `PROJECT_ID` is not set, the workflow will still work but skip project board integration.

### External Board Configuration
- **Owner**: BjarneNiklas
- **Board Number**: 6
- **URL**: https://github.com/users/BjarneNiklas/projects/6

### Customization
You can modify the scripts to:
- Add more tasks/subtasks
- Change assignees
- Adjust story points
- Modify acceptance criteria
- Add custom labels
- Change external board reference

## 📊 Issue Template Features

Each created issue includes:
- ✅ **Task Description**: Detailed description of what needs to be implemented
- ✅ **Acceptance Criteria**: Specific criteria that must be met
- ✅ **Technical Details**: Component, priority, story points, sprint
- ✅ **Dependencies**: List of tasks this depends on
- ✅ **Testing Requirements**: What testing is required
- ✅ **Documentation Requirements**: What documentation needs to be updated
- ✅ **Implementation Checklist**: Step-by-step checklist for development

## 🔄 Workflow Integration

### Automation Rules (Manual Setup)
After creating the board, set up these automation rules in GitHub:

1. **Status Transitions**
   - Move to "In Progress" when assigned
   - Move to "Review" when PR created
   - Move to "Testing" when PR merged
   - Move to "Done" when tests pass

2. **Assignment Rules**
   - Auto-assign based on component
   - Auto-assign based on expertise

3. **Notification Rules**
   - Notify assignee when task assigned
   - Notify team when task blocked
   - Notify reviewers when PR ready

## 🧪 Testing the Scripts

### Test Mode (Python)
```python
# Add this to the script for testing
TEST_MODE = True  # Set to True to prevent actual API calls
```

### Dry Run (PowerShell)
```powershell
# Add -WhatIf parameter for dry run
.\scripts\create_login_kanban_board.ps1 -GitHubToken "test" -WhatIf
.\scripts\reference_external_board.ps1 -GitHubToken "test" -WhatIf
```

## 🔒 Security Considerations

- **Token Security**: Never commit your GitHub token to version control
- **Token Permissions**: Use the minimum required permissions
- **Token Expiration**: Set appropriate expiration dates for tokens
- **Access Control**: Ensure only authorized users can run the scripts

## 🚨 Troubleshooting

### Common Issues

1. **Authentication Error**
   ```
   ❌ Error: 401 Unauthorized
   ```
   **Solution**: Check your GitHub token and permissions

2. **Repository Not Found**
   ```
   ❌ Error: 404 Not Found
   ```
   **Solution**: Verify repository name and owner

3. **Permission Denied**
   ```
   ❌ Error: 403 Forbidden
   ```
   **Solution**: Check repository access and token permissions

4. **Rate Limit Exceeded**
   ```
   ❌ Error: 429 Too Many Requests
   ```
   **Solution**: Wait and retry, or use authenticated requests

5. **External Board Not Accessible**
   ```
   ❌ Error: Project board not found or not accessible
   ```
   **Solution**: Check if the external board is public or you have access permissions

### Debug Mode

Enable debug mode by setting:
```bash
export DEBUG=1
```

## 📈 Monitoring and Analytics

### Success Metrics
- **Board Creation**: 100% success rate
- **Issue Creation**: All 7 issues created successfully
- **Column Setup**: All 6 columns created
- **Assignment**: Proper assignee assignment
- **External Integration**: Reference issue and documentation created

### Performance Metrics
- **Script Execution Time**: <30 seconds
- **API Calls**: ~15 calls total
- **Error Rate**: <1%

## 🔄 Updates and Maintenance

### Adding New Tasks
1. Edit the task arrays in the scripts
2. Add new task objects with required fields
3. Run the script to create new issues

### Modifying Existing Tasks
1. Update the task definitions in the scripts
2. Note: This won't modify existing issues, only create new ones

### External Board Integration
1. Update external board configuration in scripts
2. Re-run integration script to update references
3. Review and update integration documentation

### Version Control
- Scripts are version controlled
- Changes are tracked and documented
- Rollback capability available

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Verify your GitHub token and permissions
3. Review the error messages
4. Check GitHub API status
5. Contact the development team

## 🎉 Success Checklist

After running the script, verify:
- [ ] Project board created successfully
- [ ] All 6 columns created
- [ ] All 7 issues created
- [ ] Issues added to backlog column
- [ ] Proper labels applied
- [ ] Assignees set correctly
- [ ] Story points assigned
- [ ] Dependencies configured
- [ ] External board reference issue created
- [ ] Integration documentation generated

---

**Note**: These scripts are designed for the JambaM Login System implementation. Modify as needed for other projects. 