#!/usr/bin/env pwsh
<#
.SYNOPSIS
    JamBam Project Board Creator with 9 Phases
.DESCRIPTION
    Automatically creates a comprehensive GitHub Project Board with all phases, epics, and labels.
.PARAMETER Token
    GitHub Personal Access Token
.PARAMETER Owner
    GitHub owner (user or org)
.PARAMETER Repo
    Repository name (optional for org boards)
.PARAMETER Title
    Project board title
.PARAMETER Description
    Project board description
.EXAMPLE
    .\create_jambam_phases_board.ps1 -Token "ghp_..." -Owner "revor" -Repo "project-jambam"
.EXAMPLE
    .\create_jambam_phases_board.ps1 -Token "ghp_..." -Owner "jambam-org" -Title "JamBam Platform Roadmap"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Token,
    
    [Parameter(Mandatory = $true)]
    [string]$Owner,
    
    [Parameter(Mandatory = $false)]
    [string]$Repo,
    
    [Parameter(Mandatory = $false)]
    [string]$Title = "JamBam Platform - Complete Roadmap",
    
    [Parameter(Mandatory = $false)]
    [string]$Description = "Comprehensive project management for JamBam platform with 9 phases"
)

# Ensure we have the required modules
if (-not (Get-Module -ListAvailable -Name "PowerShellForGitHub")) {
    Write-Host "Installing PowerShellForGitHub module..." -ForegroundColor Yellow
    Install-Module -Name "PowerShellForGitHub" -Force -Scope CurrentUser
}

Import-Module PowerShellForGitHub

# Set up authentication
Set-GitHubAuthentication -PersonalAccessToken $Token

Write-Host "🚀 Creating JamBam Project Board with all phases..." -ForegroundColor Green
Write-Host "Owner: $Owner" -ForegroundColor Cyan
if ($Repo) {
    Write-Host "Repository: $Repo" -ForegroundColor Cyan
}
Write-Host ""

# Define all labels with their colors and descriptions
$labels = @{
    # Phase Labels
    "phase-1-kickoff" = @{ Color = "0e8a16"; Description = "Phase 1: Project Kickoff & Foundation" }
    "phase-2-ideation" = @{ Color = "1d76db"; Description = "Phase 2: Ideation & Research" }
    "phase-3-mvp" = @{ Color = "fbca04"; Description = "Phase 3: MVP Development" }
    "phase-4-masterthesis" = @{ Color = "d93f0b"; Description = "Phase 4: Masterthesis Implementation" }
    "phase-5-alpha" = @{ Color = "fef2c0"; Description = "Phase 5: Alpha Testing" }
    "phase-6-beta" = @{ Color = "c2e0c6"; Description = "Phase 6: Beta Testing" }
    "phase-7-launch" = @{ Color = "d4c5f9"; Description = "Phase 7: Public Launch" }
    "phase-8-growth" = @{ Color = "bfdadc"; Description = "Phase 8: Growth & Scaling" }
    "phase-9-future" = @{ Color = "f9d0c4"; Description = "Phase 9: Future Vision" }
    
    # Priority Labels
    "priority-critical" = @{ Color = "d73a4a"; Description = "Critical priority" }
    "priority-high" = @{ Color = "fbca04"; Description = "High priority" }
    "priority-medium" = @{ Color = "0e8a16"; Description = "Medium priority" }
    "priority-low" = @{ Color = "1d76db"; Description = "Low priority" }
    
    # Type Labels
    "type-feature" = @{ Color = "0e8a16"; Description = "New feature" }
    "type-bug" = @{ Color = "d73a4a"; Description = "Bug fix" }
    "type-enhancement" = @{ Color = "1d76db"; Description = "Enhancement" }
    "type-documentation" = @{ Color = "0075ca"; Description = "Documentation" }
    "type-research" = @{ Color = "d4c5f9"; Description = "Research task" }
    "type-thesis" = @{ Color = "fef2c0"; Description = "Masterthesis related" }
    
    # Module Labels
    "module-ai" = @{ Color = "d4c5f9"; Description = "AI & Multi-Agent Systems" }
    "module-community" = @{ Color = "0e8a16"; Description = "Community & Squads" }
    "module-battle" = @{ Color = "d73a4a"; Description = "Battle Management" }
    "module-assets" = @{ Color = "fbca04"; Description = "Asset & Content Generation" }
    "module-academy" = @{ Color = "1d76db"; Description = "Academy & Labs" }
    "module-workflow" = @{ Color = "bfdadc"; Description = "Workflow & Integration" }
    "module-security" = @{ Color = "f9d0c4"; Description = "Security & Compliance" }
    "module-business" = @{ Color = "0075ca"; Description = "Business & Pro Features" }
    
    # Status Labels
    "status-ready" = @{ Color = "0e8a16"; Description = "Ready to work on" }
    "status-in-progress" = @{ Color = "fbca04"; Description = "In progress" }
    "status-review" = @{ Color = "1d76db"; Description = "Under review" }
    "status-blocked" = @{ Color = "d73a4a"; Description = "Blocked" }
    "status-done" = @{ Color = "bfdadc"; Description = "Completed" }
    
    # Special Labels
    "masterthesis" = @{ Color = "d4c5f9"; Description = "Masterthesis relevant" }
    "product" = @{ Color = "0e8a16"; Description = "Product feature" }
    "research" = @{ Color = "fef2c0"; Description = "Research component" }
    "german-market" = @{ Color = "1d76db"; Description = "German market focus" }
    "european-market" = @{ Color = "0075ca"; Description = "European market focus" }
    "epic" = @{ Color = "d4c5f9"; Description = "Epic issue" }
}

# Create labels
Write-Host "🏷️  Creating labels..." -ForegroundColor Yellow
$createdLabels = 0

foreach ($labelName in $labels.Keys) {
    $labelData = $labels[$labelName]
    
    try {
        if ($Repo) {
            # Repository labels
            $params = @{
                Owner = $Owner
                RepositoryName = $Repo
                Name = $labelName
                Color = $labelData.Color
                Description = $labelData.Description
            }
            New-GitHubLabel @params -ErrorAction SilentlyContinue
        } else {
            # Organization labels
            $params = @{
                OrganizationName = $Owner
                Name = $labelName
                Color = $labelData.Color
                Description = $labelData.Description
            }
            New-GitHubLabel @params -ErrorAction SilentlyContinue
        }
        
        Write-Host "  ✅ Label '$labelName' created" -ForegroundColor Green
        $createdLabels++
    }
    catch {
        if ($_.Exception.Message -like "*already exists*") {
            Write-Host "  ⚠️  Label '$labelName' already exists" -ForegroundColor Yellow
            $createdLabels++
        } else {
            Write-Host "  ❌ Failed to create label '$labelName': $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "✅ Created $createdLabels labels" -ForegroundColor Green
Write-Host ""

# Create epics if repository is provided
if ($Repo) {
    Write-Host "📋 Creating epics..." -ForegroundColor Yellow
    
    $epics = @{
        "ai-multi-agent" = @{
            Title = "🤖 AI & Multi-Agent Systems"
            Body = @"
## AI & Multi-Agent Systems Epic

### Overview
Core AI infrastructure for intelligent content generation, user interaction, and platform automation.

### Key Components
- **Multi-Agent Architecture**: Orchestrated AI agents for different tasks
- **Content Generation**: AI-powered asset and content creation
- **Intelligent Workflows**: Automated task management and optimization
- **Analytics & Insights**: AI-driven user behavior and platform analytics

### Success Metrics
- [ ] Multi-agent system operational
- [ ] Content generation pipeline active
- [ ] AI analytics providing insights
- [ ] Intelligent workflows implemented

### Related Labels
- `module-ai`
- `type-feature`
- `type-research`
"@
            Labels = @("module-ai", "epic")
        }
        "community-squads" = @{
            Title = "👥 Community & Squads System"
            Body = @"
## Community & Squads System Epic

### Overview
Building a vibrant, competitive community with squad-based collaboration and gamification.

### Key Components
- **Squad Management**: Team formation, roles, and collaboration tools
- **Legion System**: Larger organizational units for competitions
- **Community Features**: Forums, events, and social interactions
- **Gamification**: Points, achievements, and competitive elements

### Success Metrics
- [ ] Squad creation and management functional
- [ ] Legion system operational
- [ ] Community engagement features active
- [ ] Gamification system implemented

### Related Labels
- `module-community`
- `type-feature`
"@
            Labels = @("module-community", "epic")
        }
        "battle-management" = @{
            Title = "⚔️ Battle Management System"
            Body = @"
## Battle Management System Epic

### Overview
Competitive gameplay mechanics and battle orchestration for user engagement.

### Key Components
- **Battle Mechanics**: Core gameplay systems and rules
- **Matchmaking**: Intelligent player pairing and team formation
- **Tournament System**: Organized competitions and events
- **Battle Analytics**: Performance tracking and statistics

### Success Metrics
- [ ] Battle mechanics implemented
- [ ] Matchmaking system operational
- [ ] Tournament functionality active
- [ ] Analytics dashboard functional

### Related Labels
- `module-battle`
- `type-feature`
"@
            Labels = @("module-battle", "epic")
        }
        "asset-generation" = @{
            Title = "🎨 Asset & Content Generation"
            Body = @"
## Asset & Content Generation Epic

### Overview
AI-powered content creation and asset management for the platform.

### Key Components
- **3D Asset Generation**: AI-created 3D models and environments
- **Content Pipeline**: Automated content creation and curation
- **Asset Management**: Storage, organization, and distribution
- **Quality Control**: Automated and manual content review

### Success Metrics
- [ ] 3D asset generation operational
- [ ] Content pipeline active
- [ ] Asset management system functional
- [ ] Quality control processes implemented

### Related Labels
- `module-assets`
- `type-feature`
- `type-research`
"@
            Labels = @("module-assets", "epic")
        }
        "academy-labs" = @{
            Title = "🎓 Academy & Labs System"
            Body = @"
## Academy & Labs System Epic

### Overview
Educational content, skill development, and experimental features.

### Key Components
- **Learning Paths**: Structured educational content and tutorials
- **Labs Environment**: Experimental features and testing grounds
- **Skill Tracking**: Progress monitoring and achievement system
- **Knowledge Base**: Comprehensive documentation and guides

### Success Metrics
- [ ] Learning paths implemented
- [ ] Labs environment operational
- [ ] Skill tracking system active
- [ ] Knowledge base comprehensive

### Related Labels
- `module-academy`
- `type-feature`
"@
            Labels = @("module-academy", "epic")
        }
        "workflow-integration" = @{
            Title = "🔧 Workflow & Integration"
            Body = @"
## Workflow & Integration Epic

### Overview
Seamless integration and workflow automation across all platform components.

### Key Components
- **API Integration**: Third-party service connections
- **Workflow Automation**: Automated processes and triggers
- **Data Synchronization**: Real-time data consistency
- **Performance Optimization**: System efficiency and scalability

### Success Metrics
- [ ] API integrations functional
- [ ] Workflow automation active
- [ ] Data synchronization reliable
- [ ] Performance targets met

### Related Labels
- `module-workflow`
- `type-enhancement`
"@
            Labels = @("module-workflow", "epic")
        }
        "security-compliance" = @{
            Title = "🔒 Security & Compliance"
            Body = @"
## Security & Compliance Epic

### Overview
Platform security, data protection, and regulatory compliance for European market.

### Key Components
- **Data Protection**: GDPR compliance and privacy controls
- **Security Infrastructure**: Authentication, authorization, and encryption
- **Audit Trails**: Comprehensive logging and monitoring
- **Compliance Framework**: Regulatory adherence and documentation

### Success Metrics
- [ ] GDPR compliance achieved
- [ ] Security infrastructure robust
- [ ] Audit trails comprehensive
- [ ] Compliance framework established

### Related Labels
- `module-security`
- `type-enhancement`
"@
            Labels = @("module-security", "epic")
        }
        "business-pro" = @{
            Title = "💼 Business & Pro Features"
            Body = @"
## Business & Pro Features Epic

### Overview
Premium features and business tools for professional users and organizations.

### Key Components
- **Pro Subscription**: Premium features and advanced tools
- **Business Tools**: Team management and organizational features
- **Analytics Dashboard**: Advanced insights and reporting
- **Enterprise Features**: Large-scale deployment and customization

### Success Metrics
- [ ] Pro subscription system active
- [ ] Business tools functional
- [ ] Analytics dashboard comprehensive
- [ ] Enterprise features available

### Related Labels
- `module-business`
- `type-feature`
"@
            Labels = @("module-business", "epic")
        }
    }
    
    $createdEpics = 0
    foreach ($epicKey in $epics.Keys) {
        $epicData = $epics[$epicKey]
        
        try {
            $params = @{
                Owner = $Owner
                RepositoryName = $Repo
                Title = $epicData.Title
                Body = $epicData.Body
                Label = $epicData.Labels
            }
            
            $issue = New-GitHubIssue @params
            Write-Host "  ✅ Epic '$($epicData.Title)' created: $($issue.HtmlUrl)" -ForegroundColor Green
            $createdEpics++
        }
        catch {
            Write-Host "  ❌ Failed to create epic '$($epicData.Title)': $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "✅ Created $createdEpics epics" -ForegroundColor Green
    Write-Host ""
    
    # Create milestones
    Write-Host "🎯 Creating milestones..." -ForegroundColor Yellow
    
    $milestones = @{
        "phase-1-kickoff" = @{
            Title = "🚀 Phase 1: Project Kickoff"
            Description = "Foundation setup, team formation, and initial planning"
            DueOn = "2024-03-31T23:59:59Z"
        }
        "phase-2-ideation" = @{
            Title = "💡 Phase 2: Ideation & Research"
            Description = "Research phase, concept development, and market analysis"
            DueOn = "2024-05-31T23:59:59Z"
        }
        "phase-3-mvp" = @{
            Title = "⚡ Phase 3: MVP Development"
            Description = "Minimum viable product development and core features"
            DueOn = "2024-07-31T23:59:59Z"
        }
        "phase-4-masterthesis" = @{
            Title = "🎓 Phase 4: Masterthesis Implementation"
            Description = "Academic research implementation and thesis development"
            DueOn = "2024-09-30T23:59:59Z"
        }
        "phase-5-alpha" = @{
            Title = "🧪 Phase 5: Alpha Testing"
            Description = "Internal testing, bug fixes, and feature refinement"
            DueOn = "2024-11-30T23:59:59Z"
        }
        "phase-6-beta" = @{
            Title = "🔍 Phase 6: Beta Testing"
            Description = "External beta testing and user feedback integration"
            DueOn = "2025-01-31T23:59:59Z"
        }
        "phase-7-launch" = @{
            Title = "🎉 Phase 7: Public Launch"
            Description = "Public release and initial user acquisition"
            DueOn = "2025-03-31T23:59:59Z"
        }
        "phase-8-growth" = @{
            Title = "📈 Phase 8: Growth & Scaling"
            Description = "User growth, feature expansion, and platform scaling"
            DueOn = "2025-06-30T23:59:59Z"
        }
        "phase-9-future" = @{
            Title = "🔮 Phase 9: Future Vision"
            Description = "Advanced features, AI integration, and market expansion"
            DueOn = "2025-12-31T23:59:59Z"
        }
    }
    
    $createdMilestones = 0
    foreach ($milestoneKey in $milestones.Keys) {
        $milestoneData = $milestones[$milestoneKey]
        
        try {
            $params = @{
                Owner = $Owner
                RepositoryName = $Repo
                Title = $milestoneData.Title
                Description = $milestoneData.Description
                DueOn = $milestoneData.DueOn
            }
            
            $milestone = New-GitHubMilestone @params
            Write-Host "  ✅ Milestone '$($milestoneData.Title)' created" -ForegroundColor Green
            $createdMilestones++
        }
        catch {
            Write-Host "  ❌ Failed to create milestone '$($milestoneData.Title)': $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "✅ Created $createdMilestones milestones" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ JamBam Project Board setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Add issues to the project board" -ForegroundColor White
Write-Host "2. Organize issues by phases using labels" -ForegroundColor White
Write-Host "3. Link issues to epics and milestones" -ForegroundColor White
Write-Host "4. Set up GitHub Actions for automation" -ForegroundColor White
Write-Host ""
Write-Host "🔗 Useful resources:" -ForegroundColor Cyan
Write-Host "- GitHub Actions for auto-adding issues to board" -ForegroundColor White
Write-Host "- Issue templates for standardization" -ForegroundColor White
Write-Host "- Automated changelog generation" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "- Phase Roadmap: docs/development/phases_roadmap.md" -ForegroundColor White
Write-Host "- GitHub Actions: .github/workflows/phase-automation.yml" -ForegroundColor White 