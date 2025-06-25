# JambaM Login System Kanban Board Creator (PowerShell)
# Automatically creates GitHub Project Board and all issues for the login system implementation.

param(
    [string]$GitHubToken,
    [string]$RepoName = "project-jambam",
    [string]$OwnerName = "BjarneNiklas"  # Correct GitHub username without spaces
)

# Check if GitHub token is provided
if (-not $GitHubToken) {
    Write-Host "❌ Error: GitHub token is required" -ForegroundColor Red
    Write-Host "Usage: .\create_login_kanban_board.ps1 -GitHubToken 'your_token_here'" -ForegroundColor Yellow
    exit 1
}

# GitHub API configuration
$BaseUrl = "https://api.github.com"
$Headers = @{
    "Authorization" = "token $GitHubToken"
    "Accept" = "application/vnd.github.v3+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

# Function to create GitHub Project Board
function New-GitHubProject {
    param([string]$Name, [string]$Description)
    
    $Url = "$BaseUrl/repos/$OwnerName/$RepoName/projects"
    $Body = @{
        name = $Name
        body = $Description
        private = $false
    } | ConvertTo-Json
    
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $Body -ContentType "application/json"
        Write-Host "✅ Created project board: $($Response.name) (ID: $($Response.id))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Host "❌ Error creating project: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Function to create project columns
function New-GitHubProjectColumns {
    param([int]$ProjectId)
    
    $Columns = @{
        "📋 BACKLOG" = "Backlog items and future planning"
        "📝 TO DO" = "Tasks ready to be worked on"
        "🔄 IN PROGRESS" = "Tasks currently being worked on"
        "👀 REVIEW" = "Tasks ready for review"
        "🧪 TESTING" = "Tasks being tested"
        "✅ DONE" = "Completed tasks"
    }
    
    $ColumnIds = @{}
    
    foreach ($ColumnName in $Columns.Keys) {
        $Url = "$BaseUrl/projects/$ProjectId/columns"
        $Body = @{ name = $ColumnName } | ConvertTo-Json
        
        try {
            $Response = Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $Body -ContentType "application/json"
            $ColumnIds[$ColumnName] = $Response.id
            Write-Host "✅ Created column: $ColumnName" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Error creating column $ColumnName : $($_.Exception.Message)" -ForegroundColor Red
            throw
        }
    }
    
    return $ColumnIds
}

# Function to create GitHub issue
function New-GitHubIssue {
    param(
        [string]$Title,
        [string]$Description,
        [string]$Priority,
        [int]$StoryPoints,
        [string]$Component,
        [string]$Assignee,
        [string]$Sprint,
        [string[]]$AcceptanceCriteria,
        [string[]]$Dependencies,
        [string[]]$TestingRequirements,
        [string[]]$DocumentationRequirements
    )
    
    $Url = "$BaseUrl/repos/$OwnerName/$RepoName/issues"
    
    # Create issue body
    $AcceptanceCriteriaText = $AcceptanceCriteria | ForEach-Object { "- [ ] $_" }
    $DependenciesText = if ($Dependencies) { $Dependencies | ForEach-Object { "- $_" } } else { "- None" }
    $TestingReqsText = $TestingRequirements | ForEach-Object { "- [ ] $_" }
    $DocReqsText = $DocumentationRequirements | ForEach-Object { "- [ ] $_" }
    
    $Body = @"
## 📋 Task Description
$Description

## 🎯 Acceptance Criteria
$($AcceptanceCriteriaText -join "`n")

## 🔧 Technical Details

### Component
- [x] $Component

### Priority
- [x] $Priority

### Story Points
- [x] $StoryPoints

### Sprint
- [x] $Sprint

## 🔗 Dependencies
$($DependenciesText -join "`n")

## 🧪 Testing Requirements
$($TestingReqsText -join "`n")

## 📝 Documentation Requirements
$($DocReqsText -join "`n")

## 🔒 Security Considerations
- Security requirements will be determined during implementation

## 🎨 UI/UX Considerations
- UI/UX requirements will be determined during implementation

## 📊 Success Metrics
- Task completion within estimated story points
- All acceptance criteria met
- Code review approved
- Tests passing

---

## 📋 Checklist for Implementation

### Before Starting
- [ ] Task is properly scoped and understood
- [ ] Dependencies are identified and available
- [ ] Environment is set up
- [ ] Branch is created from main

### During Development
- [ ] Code follows project standards
- [ ] Tests are written and passing
- [ ] Documentation is updated
- [ ] Security review is completed

### Before Review
- [ ] All acceptance criteria are met
- [ ] Code is self-reviewed
- [ ] Tests are comprehensive
- [ ] Documentation is complete
- [ ] Performance is acceptable

### Before Merging
- [ ] Code review is approved
- [ ] All tests are passing
- [ ] Security scan is clean
- [ ] Performance benchmarks are met
- [ ] Documentation is reviewed
"@
    
    $IssueData = @{
        title = "[LOGIN] $Title"
        body = $Body
        labels = @("login-system", "authentication")
        assignees = if ($Assignee) { @($Assignee) } else { @() }
    } | ConvertTo-Json
    
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $IssueData -ContentType "application/json"
        Write-Host "✅ Created issue: $($Response.title) (#$($Response.number))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Host "❌ Error creating issue: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Function to add issue to project column
function Add-IssueToProject {
    param([int]$ProjectId, [int]$ColumnId, [int]$IssueId)
    
    $Url = "$BaseUrl/projects/columns/$ColumnId/cards"
    $Body = @{
        content_id = $IssueId
        content_type = "Issue"
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $Body -ContentType "application/json"
        Write-Host "✅ Added issue #$IssueId to project column" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error adding issue to project: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Define all tasks
$Tasks = @(
    # Main Task 1: Supabase Authentication Integration
    @{
        Title = "Supabase Authentication Integration"
        Description = "Implement complete Supabase authentication system with email/password, social login, and security features"
        Priority = "Critical"
        StoryPoints = 13
        Component = "Backend, Frontend, Database"
        Assignee = "Backend Lead"
        Sprint = "Sprint 1"
        AcceptanceCriteria = @(
            "Supabase project configured with authentication providers",
            "Database schema implemented with RLS policies",
            "Authentication service layer implemented",
            "Frontend UI components created",
            "State management integration completed",
            "Security measures implemented",
            "Comprehensive testing and documentation"
        )
        Dependencies = @()
        TestingRequirements = @(
            "Unit tests for auth service",
            "Integration tests for auth flow",
            "UI tests for login forms",
            "Security tests",
            "Performance tests"
        )
        DocumentationRequirements = @(
            "API documentation",
            "User documentation",
            "Code comments",
            "README updates"
        )
    },
    
    # Main Task 2: Guest Login Implementation
    @{
        Title = "Guest Login Implementation"
        Description = "Implement anonymous user authentication with guest profile management and conversion flow"
        Priority = "High"
        StoryPoints = 8
        Component = "Frontend, Backend"
        Assignee = "Frontend Lead"
        Sprint = "Sprint 2"
        AcceptanceCriteria = @(
            "Anonymous authentication enabled in Supabase",
            "Guest user profile creation and management",
            "Guest login UI implemented",
            "Guest user experience and limitations",
            "Guest to registered user conversion flow",
            "Comprehensive guest login testing"
        )
        Dependencies = @("Supabase Authentication Integration")
        TestingRequirements = @(
            "Guest login tests",
            "Conversion tests",
            "Edge case testing",
            "UI tests for guest flow"
        )
        DocumentationRequirements = @(
            "Guest user documentation",
            "Conversion flow documentation",
            "Code comments"
        )
    },
    
    # Main Task 3: Offline Login Implementation
    @{
        Title = "Offline Login Implementation"
        Description = "Implement offline authentication capabilities with local storage and data synchronization"
        Priority = "Medium"
        StoryPoints = 8
        Component = "Frontend, Backend"
        Assignee = "Full Stack Developer"
        Sprint = "Sprint 2"
        AcceptanceCriteria = @(
            "Offline state detection implemented",
            "Secure local storage for offline data",
            "Offline authentication flow",
            "Data synchronization when connection restored",
            "Comprehensive offline mode testing"
        )
        Dependencies = @("Supabase Authentication Integration")
        TestingRequirements = @(
            "Offline mode tests",
            "Sync tests",
            "Edge case testing",
            "Performance tests for offline mode"
        )
        DocumentationRequirements = @(
            "Offline mode documentation",
            "Sync process documentation",
            "Code comments"
        )
    },
    
    # Subtasks
    @{
        Title = "Supabase Project Setup & Configuration"
        Description = "Configure Supabase project with proper authentication settings"
        Priority = "Critical"
        StoryPoints = 2
        Component = "Backend"
        Assignee = "Backend Lead"
        Sprint = "Sprint 1"
        AcceptanceCriteria = @(
            "Supabase project created and configured",
            "Authentication providers enabled (Email, Google, GitHub)",
            "RLS policies configured",
            "Environment variables set up"
        )
        Dependencies = @()
        TestingRequirements = @("Configuration tests")
        DocumentationRequirements = @("Setup documentation")
    },
    
    @{
        Title = "Database Schema Implementation"
        Description = "Create and implement user profiles table with proper relationships"
        Priority = "Critical"
        StoryPoints = 3
        Component = "Database"
        Assignee = "Backend Lead"
        Sprint = "Sprint 1"
        AcceptanceCriteria = @(
            "Profiles table created with all required fields",
            "RLS policies implemented",
            "Triggers for automatic profile creation",
            "Indexes for performance optimization"
        )
        Dependencies = @("Supabase Project Setup & Configuration")
        TestingRequirements = @("Schema tests", "Performance tests")
        DocumentationRequirements = @("Schema documentation")
    },
    
    @{
        Title = "Anonymous Authentication Setup"
        Description = "Configure Supabase for anonymous authentication"
        Priority = "High"
        StoryPoints = 2
        Component = "Backend"
        Assignee = "Backend Lead"
        Sprint = "Sprint 2"
        AcceptanceCriteria = @(
            "Anonymous auth enabled in Supabase",
            "Anonymous user profile creation",
            "Guest user permissions configured"
        )
        Dependencies = @("Supabase Project Setup & Configuration")
        TestingRequirements = @("Anonymous auth tests")
        DocumentationRequirements = @("Anonymous auth documentation")
    },
    
    @{
        Title = "Offline State Detection"
        Description = "Implement offline/online state detection"
        Priority = "Medium"
        StoryPoints = 2
        Component = "Frontend"
        Assignee = "Full Stack Developer"
        Sprint = "Sprint 2"
        AcceptanceCriteria = @(
            "Network status monitoring",
            "Offline state indicators",
            "Connection recovery handling"
        )
        Dependencies = @()
        TestingRequirements = @("Network detection tests")
        DocumentationRequirements = @("Offline detection documentation")
    }
)

# Main execution
try {
    Write-Host "🚀 Starting JambaM Login System Kanban Board creation..." -ForegroundColor Cyan
    
    # Create project board
    $Project = New-GitHubProject -Name "JambaM Login System Implementation" -Description "Complete login system implementation with Supabase, guest login, and offline capabilities"
    
    # Create columns
    $ColumnIds = New-GitHubProjectColumns -ProjectId $Project.id
    
    # Create issues and add to project
    $BacklogColumnId = $ColumnIds["📋 BACKLOG"]
    
    foreach ($Task in $Tasks) {
        # Create issue
        $Issue = New-GitHubIssue -Title $Task.Title -Description $Task.Description -Priority $Task.Priority -StoryPoints $Task.StoryPoints -Component $Task.Component -Assignee $Task.Assignee -Sprint $Task.Sprint -AcceptanceCriteria $Task.AcceptanceCriteria -Dependencies $Task.Dependencies -TestingRequirements $Task.TestingRequirements -DocumentationRequirements $Task.DocumentationRequirements
        
        # Add to backlog column
        Add-IssueToProject -ProjectId $Project.id -ColumnId $BacklogColumnId -IssueId $Issue.id
    }
    
    Write-Host "`n🎉 Successfully created Kanban board with $($Tasks.Count) tasks!" -ForegroundColor Green
    Write-Host "📋 Project URL: $($Project.html_url)" -ForegroundColor Cyan
    Write-Host "📝 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Review and assign tasks to team members" -ForegroundColor White
    Write-Host "   2. Move tasks to appropriate columns" -ForegroundColor White
    Write-Host "   3. Set up automation rules" -ForegroundColor White
    Write-Host "   4. Begin Sprint 1 implementation" -ForegroundColor White
    
}
catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} 