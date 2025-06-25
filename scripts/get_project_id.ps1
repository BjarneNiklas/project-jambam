#Requires -Version 7.0

<#
.SYNOPSIS
    Get Project ID Script for GitHub Project Boards
    
.DESCRIPTION
    This script helps you get the project ID for GitHub project boards
    so you can set up the PROJECT_ID secret in your repository.
    
.PARAMETER GitHubToken
    GitHub Personal Access Token with required permissions
    
.EXAMPLE
    .\scripts\get_project_id.ps1 -GitHubToken "ghp_xxxxxxxxxxxxxxxxxxxx"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubToken
)

# Configuration
$GitHubGraphQLUrl = "https://api.github.com/graphql"

# Headers for API requests
$Headers = @{
    "Authorization" = "Bearer $GitHubToken"
    "Content-Type" = "application/json"
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Get-UserProjects {
    <#
    .SYNOPSIS
        Get all user projects
    #>
    $query = @"
    query(`$login: String!) {
        user(login: `$login) {
            projectsV2(first: 20) {
                nodes {
                    id
                    title
                    number
                    url
                    createdAt
                }
            }
        }
    }
"@
    
    $variables = @{
        login = $env:GITHUB_REPOSITORY.Split('/')[0]
    }
    
    $body = @{
        query = $query
        variables = $variables
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri $GitHubGraphQLUrl -Method Post -Headers $Headers -Body $body -ContentType "application/json"
        
        if ($response.errors) {
            Write-ColorOutput "❌ GraphQL errors: $($response.errors | ConvertTo-Json)" "Red"
            return @()
        }
        
        return $response.data.user.projectsV2.nodes
        
    } catch {
        Write-ColorOutput "❌ Error fetching user projects: $($_.Exception.Message)" "Red"
        return @()
    }
}

function Get-OrganizationProjects {
    <#
    .SYNOPSIS
        Get all organization projects
    #>
    $query = @"
    query(`$login: String!) {
        organization(login: `$login) {
            projectsV2(first: 20) {
                nodes {
                    id
                    title
                    number
                    url
                    createdAt
                }
            }
        }
    }
"@
    
    $variables = @{
        login = $env:GITHUB_REPOSITORY.Split('/')[0]
    }
    
    $body = @{
        query = $query
        variables = $variables
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri $GitHubGraphQLUrl -Method Post -Headers $Headers -Body $body -ContentType "application/json"
        
        if ($response.errors) {
            # Organization might not exist, that's okay
            return @()
        }
        
        return $response.data.organization.projectsV2.nodes
        
    } catch {
        Write-ColorOutput "❌ Error fetching organization projects: $($_.Exception.Message)" "Red"
        return @()
    }
}

function Get-RepositoryProjects {
    <#
    .SYNOPSIS
        Get all repository projects
    #>
    $query = @"
    query(`$owner: String!, `$repo: String!) {
        repository(owner: `$owner, name: `$repo) {
            projectsV2(first: 20) {
                nodes {
                    id
                    title
                    number
                    url
                    createdAt
                }
            }
        }
    }
"@
    
    $repoParts = $env:GITHUB_REPOSITORY.Split('/')
    $variables = @{
        owner = $repoParts[0]
        repo = $repoParts[1]
    }
    
    $body = @{
        query = $query
        variables = $variables
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri $GitHubGraphQLUrl -Method Post -Headers $Headers -Body $body -ContentType "application/json"
        
        if ($response.errors) {
            Write-ColorOutput "❌ GraphQL errors: $($response.errors | ConvertTo-Json)" "Red"
            return @()
        }
        
        return $response.data.repository.projectsV2.nodes
        
    } catch {
        Write-ColorOutput "❌ Error fetching repository projects: $($_.Exception.Message)" "Red"
        return @()
    }
}

function Show-Projects {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Projects,
        
        [Parameter(Mandatory = $true)]
        [string]$Source
    )
    
    if (-not $Projects -or $Projects.Count -eq 0) {
        Write-ColorOutput "   No $Source projects found" "Gray"
        return
    }
    
    Write-ColorOutput "`n📋 $($Source.ToUpper()) Projects:" "Cyan"
    Write-ColorOutput "=" * 60 "Gray"
    
    foreach ($project in $Projects) {
        $projectId = $project.id
        $title = $project.title
        $number = $project.number
        $url = $project.url
        $created = $project.createdAt.Substring(0, 10)  # Just the date part
        
        Write-ColorOutput "🔹 $title" "Yellow"
        Write-ColorOutput "   ID: $projectId" "Gray"
        Write-ColorOutput "   Number: $number" "Gray"
        Write-ColorOutput "   URL: $url" "Gray"
        Write-ColorOutput "   Created: $created" "Gray"
        Write-Host ""
    }
}

# Main execution
Write-ColorOutput "🚀 GitHub Project ID Helper" "Green"
Write-ColorOutput "=" * 40 "Gray"

# Check if GITHUB_REPOSITORY is set
if (-not $env:GITHUB_REPOSITORY) {
    Write-ColorOutput "❌ GITHUB_REPOSITORY environment variable not set" "Red"
    Write-ColorOutput "   Please set your repository:" "Gray"
    Write-ColorOutput "   `$env:GITHUB_REPOSITORY='owner/repo'" "Gray"
    exit 1
}

Write-ColorOutput "Repository: $env:GITHUB_REPOSITORY" "Gray"
Write-ColorOutput "Token: $($GitHubToken.Substring(0, 10))..." "Gray"
Write-Host ""

# Get projects from different sources
$userProjects = Get-UserProjects
$orgProjects = Get-OrganizationProjects
$repoProjects = Get-RepositoryProjects

# Display all projects
Show-Projects -Projects $userProjects -Source "User"
Show-Projects -Projects $orgProjects -Source "Organization"
Show-Projects -Projects $repoProjects -Source "Repository"

# Summary
$totalProjects = $userProjects.Count + $orgProjects.Count + $repoProjects.Count

if ($totalProjects -eq 0) {
    Write-ColorOutput "❌ No projects found" "Red"
    Write-ColorOutput "`n💡 To create a project board:" "Yellow"
    Write-ColorOutput "   1. Go to your repository on GitHub" "Gray"
    Write-ColorOutput "   2. Click on 'Projects' tab" "Gray"
    Write-ColorOutput "   3. Click 'New project'" "Gray"
    Write-ColorOutput "   4. Choose 'Board' or 'Table' view" "Gray"
    Write-ColorOutput "   5. Run this script again to get the project ID" "Gray"
} else {
    Write-ColorOutput "`n✅ Found $totalProjects project(s)" "Green"
    Write-ColorOutput "`n📝 To set up PROJECT_ID secret:" "Yellow"
    Write-ColorOutput "   1. Copy the project ID from above" "Gray"
    Write-ColorOutput "   2. Go to your repository Settings → Secrets and variables → Actions" "Gray"
    Write-ColorOutput "   3. Click 'New repository secret'" "Gray"
    Write-ColorOutput "   4. Name: PROJECT_ID" "Gray"
    Write-ColorOutput "   5. Value: [paste the project ID]" "Gray"
    Write-ColorOutput "   6. Click 'Add secret'" "Gray"
    Write-ColorOutput "`n🔗 Example project ID: PVT_kwDOABc0Nc4AAgE" "Cyan"
} 