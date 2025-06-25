#Requires -Version 7.0

<#
.SYNOPSIS
    External Project Board Reference Script for JamBam
    
.DESCRIPTION
    This script helps integrate and reference external GitHub project boards
    with the JamBam project management system.
    
.PARAMETER GitHubToken
    GitHub Personal Access Token with required permissions
    
.PARAMETER WhatIf
    Run in dry-run mode without making actual changes
    
.EXAMPLE
    .\scripts\reference_external_board.ps1 -GitHubToken "ghp_xxxxxxxxxxxxxxxxxxxx"
    
.EXAMPLE
    .\scripts\reference_external_board.ps1 -GitHubToken "ghp_xxxxxxxxxxxxxxxxxxxx" -WhatIf
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubToken,
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

# Configuration
$GitHubApiBase = "https://api.github.com"
$GitHubGraphQLUrl = "https://api.github.com/graphql"

# External board reference
$ExternalBoardOwner = "BjarneNiklas"
$ExternalBoardNumber = 6
$ExternalBoardUrl = "https://github.com/users/$ExternalBoardOwner/projects/$ExternalBoardNumber"

# Headers for API requests
$Headers = @{
    "Authorization" = "token $GitHubToken"
    "Accept" = "application/vnd.github.v3+json"
}

$GraphQLHeaders = @{
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

function Get-ExternalBoardInfo {
    <#
    .SYNOPSIS
        Get information about the external project board using GraphQL
    #>
    Write-ColorOutput "🔍 Fetching external board information..." "Cyan"
    Write-ColorOutput "   URL: $ExternalBoardUrl" "Gray"
    
    # GraphQL query to get project board details
    $query = @"
    query(`$owner: String!, `$number: Int!) {
        user(login: `$owner) {
            projectV2(number: `$number) {
                id
                title
                createdAt
                updatedAt
                fields(first: 20) {
                    nodes {
                        ... on ProjectV2Field {
                            id
                            name
                        }
                        ... on ProjectV2SingleSelectField {
                            id
                            name
                            options {
                                id
                                name
                            }
                        }
                    }
                }
                items(first: 100) {
                    nodes {
                        id
                        content {
                            ... on Issue {
                                id
                                title
                                number
                                state
                                labels(first: 10) {
                                    nodes {
                                        name
                                    }
                                }
                            }
                            ... on PullRequest {
                                id
                                title
                                number
                                state
                                labels(first: 10) {
                                    nodes {
                                        name
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
"@
    
    $variables = @{
        owner = $ExternalBoardOwner
        number = $ExternalBoardNumber
    }
    
    $body = @{
        query = $query
        variables = $variables
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri $GitHubGraphQLUrl -Method Post -Headers $GraphQLHeaders -Body $body -ContentType "application/json"
        
        if ($response.errors) {
            Write-ColorOutput "❌ GraphQL errors: $($response.errors | ConvertTo-Json)" "Red"
            return $null
        }
        
        $project = $response.data.user.projectV2
        if (-not $project) {
            Write-ColorOutput "❌ Project board not found or not accessible" "Red"
            return $null
        }
        
        return $project
        
    } catch {
        Write-ColorOutput "❌ Error fetching board info: $($_.Exception.Message)" "Red"
        return $null
    }
}

function New-ReferenceIssue {
    param(
        [Parameter(Mandatory = $true)]
        [object]$BoardInfo
    )
    
    if (-not $BoardInfo) {
        return $false
    }
    
    # Create reference issue content
    $issueTitle = "📋 External Project Board Reference: $($BoardInfo.title)"
    
    $fieldsText = Format-BoardFields -Fields $BoardInfo.fields.nodes
    
    $issueBody = @"
# External Project Board Reference

## 🔗 Board Information
- **Owner:** @$ExternalBoardOwner
- **Board Number:** $ExternalBoardNumber
- **URL:** $ExternalBoardUrl
- **Title:** $($BoardInfo.title)
- **Created:** $($BoardInfo.createdAt)
- **Last Updated:** $($BoardInfo.updatedAt)

## 📊 Board Structure

### Fields
$fieldsText

### Items Count
- **Total Items:** $($BoardInfo.items.nodes.Count)

## 🔄 Integration Options

### Option 1: Reference Only
- Keep external board as reference
- Create local tasks based on external board items
- Maintain separate tracking

### Option 2: Mirror Integration
- Automatically sync items from external board
- Create local copies of relevant items
- Maintain bidirectional updates

### Option 3: Migration
- Migrate relevant items to local board
- Close external board after migration
- Consolidate project management

## 🎯 Recommended Actions

1. **Review External Board** - Examine items and structure
2. **Identify Relevant Items** - Determine which items apply to JamBam
3. **Choose Integration Strategy** - Select from options above
4. **Execute Integration** - Implement chosen strategy

## 📝 Notes
- This is an automated reference issue
- Update this issue as integration progresses
- Consider adding labels: `external-reference`, `project-management`

---
*Generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')*
"@
    
    # Create the issue
    $issueData = @{
        title = $issueTitle
        body = $issueBody
        labels = @("external-reference", "project-management", "documentation")
    }
    
    if ($WhatIf) {
        Write-ColorOutput "🔍 [WhatIf] Would create reference issue:" "Yellow"
        Write-ColorOutput "   Title: $issueTitle" "Gray"
        Write-ColorOutput "   Labels: $($issueData.labels -join ', ')" "Gray"
        return $true
    }
    
    try {
        $response = Invoke-RestMethod -Uri "$GitHubApiBase/repos/BjarneNiklas/project-jambam/issues" -Method Post -Headers $Headers -Body ($issueData | ConvertTo-Json -Depth 10) -ContentType "application/json"
        
        Write-ColorOutput "✅ Created reference issue: #$($response.number)" "Green"
        Write-ColorOutput "   URL: $($response.html_url)" "Gray"
        return $true
        
    } catch {
        Write-ColorOutput "❌ Error creating reference issue: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Format-BoardFields {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Fields
    )
    
    if (-not $Fields -or $Fields.Count -eq 0) {
        return "- No custom fields found"
    }
    
    $formatted = @()
    foreach ($field in $Fields) {
        if ($field.options) {
            $options = ($field.options | ForEach-Object { $_.name }) -join ", "
            $formatted += "- **$($field.name)** (Select: $options)"
        } else {
            $formatted += "- **$($field.name)**"
        }
    }
    
    return $formatted -join "`n"
}

function New-IntegrationDocumentation {
    param(
        [Parameter(Mandatory = $true)]
        [object]$BoardInfo
    )
    
    $docContent = @"
# External Project Board Integration

## Overview
This document outlines the integration strategy for the external GitHub project board:
**$ExternalBoardUrl**

## Board Details
- **Owner:** $ExternalBoardOwner
- **Board Number:** $ExternalBoardNumber
- **Title:** $($BoardInfo.title)

## Integration Strategy

### Phase 1: Analysis (Week 1)
- [ ] Review all items in external board
- [ ] Identify items relevant to JamBam project
- [ ] Map external items to JamBam modules
- [ ] Determine priority and dependencies

### Phase 2: Planning (Week 2)
- [ ] Choose integration approach (Reference/Mirror/Migrate)
- [ ] Create local tasks for relevant items
- [ ] Set up automation if mirroring
- [ ] Establish communication channels

### Phase 3: Implementation (Week 3-4)
- [ ] Execute chosen integration strategy
- [ ] Update local project boards
- [ ] Create cross-references
- [ ] Monitor integration success

## Current Status
- **Analysis Complete:** ❌
- **Planning Complete:** ❌
- **Implementation Started:** ❌

## Notes
- External board contains $($BoardInfo.items.nodes.Count) items
- Integration approach to be determined based on analysis
- Consider impact on current JamBam development timeline

---
*Last Updated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')*
"@
    
    try {
        $docPath = "docs/EXTERNAL_BOARD_INTEGRATION.md"
        
        if ($WhatIf) {
            Write-ColorOutput "🔍 [WhatIf] Would create documentation: $docPath" "Yellow"
            return $true
        }
        
        # Ensure docs directory exists
        if (-not (Test-Path "docs")) {
            New-Item -ItemType Directory -Path "docs" -Force | Out-Null
        }
        
        $docContent | Out-File -FilePath $docPath -Encoding UTF8
        Write-ColorOutput "✅ Created integration documentation: $docPath" "Green"
        return $true
        
    } catch {
        Write-ColorOutput "❌ Error creating documentation: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Test-IntegrationApproach {
    param(
        [Parameter(Mandatory = $true)]
        [object]$BoardInfo
    )
    
    $items = $BoardInfo.items.nodes
    $fields = $BoardInfo.fields.nodes
    
    Write-ColorOutput "`n📊 External Board Analysis:" "Cyan"
    Write-ColorOutput "   - Items: $($items.Count)" "Gray"
    Write-ColorOutput "   - Custom Fields: $($fields.Count)" "Gray"
    Write-ColorOutput "   - Title: $($BoardInfo.title)" "Gray"
    
    # Analyze items to determine relevance
    $issueCount = 0
    $prCount = 0
    
    foreach ($item in $items) {
        $content = $item.content
        if ($content.__typename -eq "Issue") {
            $issueCount++
        } elseif ($content.__typename -eq "PullRequest") {
            $prCount++
        }
    }
    
    Write-ColorOutput "   - Issues: $issueCount" "Gray"
    Write-ColorOutput "   - Pull Requests: $prCount" "Gray"
    
    # Suggest approach based on analysis
    if ($items.Count -lt 10) {
        $approach = "**Reference Only** - Small board, keep as reference"
    } elseif ($items.Count -lt 50) {
        $approach = "**Mirror Integration** - Medium board, consider mirroring relevant items"
    } else {
        $approach = "**Migration** - Large board, consider migrating relevant items"
    }
    
    Write-ColorOutput "`n💡 Suggested Approach: $approach" "Yellow"
    return $approach
}

# Main execution
Write-ColorOutput "🚀 External Project Board Integration Script" "Green"
Write-ColorOutput "=" * 50 "Gray"

if ($WhatIf) {
    Write-ColorOutput "🔍 Running in WhatIf mode - no actual changes will be made" "Yellow"
}

# Get external board information
$boardInfo = Get-ExternalBoardInfo

if (-not $boardInfo) {
    Write-ColorOutput "❌ Could not fetch external board information" "Red"
    Write-ColorOutput "   Possible reasons:" "Red"
    Write-ColorOutput "   - Board doesn't exist" "Gray"
    Write-ColorOutput "   - Board is private and not accessible" "Gray"
    Write-ColorOutput "   - Invalid board number" "Gray"
    Write-ColorOutput "   - Insufficient permissions" "Gray"
    exit 1
}

Write-ColorOutput "✅ Successfully fetched external board information" "Green"

# Suggest integration approach
$approach = Test-IntegrationApproach -BoardInfo $boardInfo

# Create reference issue
Write-ColorOutput "`n📝 Creating reference issue..." "Cyan"
$issueCreated = New-ReferenceIssue -BoardInfo $boardInfo

# Create integration documentation
Write-ColorOutput "`n📚 Creating integration documentation..." "Cyan"
$docCreated = New-IntegrationDocumentation -BoardInfo $boardInfo

# Summary
Write-ColorOutput "`n🎉 Integration Setup Complete!" "Green"
Write-ColorOutput "   - Reference Issue: $(if ($issueCreated) { '✅' } else { '❌' })" "Gray"
Write-ColorOutput "   - Documentation: $(if ($docCreated) { '✅' } else { '❌' })" "Gray"
Write-ColorOutput "   - Suggested Approach: $approach" "Gray"

Write-ColorOutput "`n📋 Next Steps:" "Cyan"
Write-ColorOutput "   1. Review the created reference issue" "Gray"
Write-ColorOutput "   2. Read the integration documentation" "Gray"
Write-ColorOutput "   3. Decide on integration approach" "Gray"
Write-ColorOutput "   4. Execute chosen strategy" "Gray" 