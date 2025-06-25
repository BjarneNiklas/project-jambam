#!/usr/bin/env python3
"""
External Project Board Reference Script
=======================================

This script helps integrate and reference external GitHub project boards
with the JamBam project management system.

Usage:
    python scripts/reference_external_board.py
"""

import os
import sys
import requests
import json
from datetime import datetime
from typing import Dict, List, Optional

# Configuration
GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
GITHUB_API_BASE = 'https://api.github.com'
GITHUB_GRAPHQL_URL = 'https://api.github.com/graphql'

# External board reference
EXTERNAL_BOARD_OWNER = 'BjarneNiklas'
EXTERNAL_BOARD_NUMBER = 6
EXTERNAL_BOARD_URL = f'https://github.com/users/{EXTERNAL_BOARD_OWNER}/projects/{EXTERNAL_BOARD_NUMBER}'

class ExternalBoardReference:
    """Handles integration with external GitHub project boards."""
    
    def __init__(self, token: str):
        self.token = token
        self.headers = {
            'Authorization': f'token {token}',
            'Accept': 'application/vnd.github.v3+json'
        }
        self.graphql_headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }
    
    def get_external_board_info(self) -> Dict:
        """Get information about the external project board."""
        print(f"🔍 Fetching external board information...")
        print(f"   URL: {EXTERNAL_BOARD_URL}")
        
        # GraphQL query to get project board details
        query = """
        query($owner: String!, $number: Int!) {
            user(login: $owner) {
                projectV2(number: $number) {
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
        """
        
        variables = {
            'owner': EXTERNAL_BOARD_OWNER,
            'number': EXTERNAL_BOARD_NUMBER
        }
        
        try:
            response = requests.post(
                GITHUB_GRAPHQL_URL,
                headers=self.graphql_headers,
                json={'query': query, 'variables': variables}
            )
            response.raise_for_status()
            
            data = response.json()
            if 'errors' in data:
                print(f"❌ GraphQL errors: {data['errors']}")
                return {}
            
            project = data['data']['user']['projectV2']
            if not project:
                print(f"❌ Project board not found or not accessible")
                return {}
            
            return project
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Error fetching board info: {e}")
            return {}
    
    def create_reference_issue(self, board_info: Dict) -> bool:
        """Create a reference issue in the current repository linking to the external board."""
        if not board_info:
            return False
        
        # Create reference issue content
        issue_title = f"📋 External Project Board Reference: {board_info.get('title', 'Unknown Board')}"
        
        issue_body = f"""# External Project Board Reference

## 🔗 Board Information
- **Owner:** @{EXTERNAL_BOARD_OWNER}
- **Board Number:** {EXTERNAL_BOARD_NUMBER}
- **URL:** {EXTERNAL_BOARD_URL}
- **Title:** {board_info.get('title', 'Unknown')}
- **Created:** {board_info.get('createdAt', 'Unknown')}
- **Last Updated:** {board_info.get('updatedAt', 'Unknown')}

## 📊 Board Structure

### Fields
{self._format_fields(board_info.get('fields', {}).get('nodes', []))}

### Items Count
- **Total Items:** {len(board_info.get('items', {}).get('nodes', []))}

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
*Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*
"""
        
        # Create the issue
        issue_data = {
            'title': issue_title,
            'body': issue_body,
            'labels': ['external-reference', 'project-management', 'documentation']
        }
        
        try:
            response = requests.post(
                f'{GITHUB_API_BASE}/repos/BjarneNiklas/project-jambam/issues',
                headers=self.headers,
                json=issue_data
            )
            response.raise_for_status()
            
            issue = response.json()
            print(f"✅ Created reference issue: #{issue['number']}")
            print(f"   URL: {issue['html_url']}")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Error creating reference issue: {e}")
            return False
    
    def _format_fields(self, fields: List[Dict]) -> str:
        """Format board fields for display."""
        if not fields:
            return "- No custom fields found"
        
        formatted = []
        for field in fields:
            if field.get('options'):
                options = ', '.join([opt['name'] for opt in field['options']])
                formatted.append(f"- **{field['name']}** (Select: {options})")
            else:
                formatted.append(f"- **{field['name']}**")
        
        return '\n'.join(formatted)
    
    def create_integration_documentation(self, board_info: Dict) -> bool:
        """Create documentation for integrating with the external board."""
        doc_content = f"""# External Project Board Integration

## Overview
This document outlines the integration strategy for the external GitHub project board:
**{EXTERNAL_BOARD_URL}**

## Board Details
- **Owner:** {EXTERNAL_BOARD_OWNER}
- **Board Number:** {EXTERNAL_BOARD_NUMBER}
- **Title:** {board_info.get('title', 'Unknown')}

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
- External board contains {len(board_info.get('items', {}).get('nodes', []))} items
- Integration approach to be determined based on analysis
- Consider impact on current JamBam development timeline

---
*Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*
"""
        
        try:
            with open('docs/EXTERNAL_BOARD_INTEGRATION.md', 'w', encoding='utf-8') as f:
                f.write(doc_content)
            
            print(f"✅ Created integration documentation: docs/EXTERNAL_BOARD_INTEGRATION.md")
            return True
            
        except Exception as e:
            print(f"❌ Error creating documentation: {e}")
            return False
    
    def suggest_integration_approach(self, board_info: Dict) -> str:
        """Analyze the external board and suggest integration approach."""
        items = board_info.get('items', {}).get('nodes', [])
        fields = board_info.get('fields', {}).get('nodes', [])
        
        print(f"\n📊 External Board Analysis:")
        print(f"   - Items: {len(items)}")
        print(f"   - Custom Fields: {len(fields)}")
        print(f"   - Title: {board_info.get('title', 'Unknown')}")
        
        # Analyze items to determine relevance
        issue_count = 0
        pr_count = 0
        
        for item in items:
            content = item.get('content', {})
            if content.get('__typename') == 'Issue':
                issue_count += 1
            elif content.get('__typename') == 'PullRequest':
                pr_count += 1
        
        print(f"   - Issues: {issue_count}")
        print(f"   - Pull Requests: {pr_count}")
        
        # Suggest approach based on analysis
        if len(items) < 10:
            approach = "**Reference Only** - Small board, keep as reference"
        elif len(items) < 50:
            approach = "**Mirror Integration** - Medium board, consider mirroring relevant items"
        else:
            approach = "**Migration** - Large board, consider migrating relevant items"
        
        print(f"\n💡 Suggested Approach: {approach}")
        return approach

def main():
    """Main function to handle external board integration."""
    print("🚀 External Project Board Integration Script")
    print("=" * 50)
    
    if not GITHUB_TOKEN:
        print("❌ Error: GITHUB_TOKEN environment variable not set")
        print("   Please set your GitHub personal access token:")
        print("   export GITHUB_TOKEN='your_token_here'")
        sys.exit(1)
    
    # Initialize reference handler
    ref_handler = ExternalBoardReference(GITHUB_TOKEN)
    
    # Get external board information
    board_info = ref_handler.get_external_board_info()
    
    if not board_info:
        print("❌ Could not fetch external board information")
        print("   Possible reasons:")
        print("   - Board doesn't exist")
        print("   - Board is private and not accessible")
        print("   - Invalid board number")
        print("   - Insufficient permissions")
        sys.exit(1)
    
    print(f"✅ Successfully fetched external board information")
    
    # Suggest integration approach
    approach = ref_handler.suggest_integration_approach(board_info)
    
    # Create reference issue
    print(f"\n📝 Creating reference issue...")
    issue_created = ref_handler.create_reference_issue(board_info)
    
    # Create integration documentation
    print(f"\n📚 Creating integration documentation...")
    doc_created = ref_handler.create_integration_documentation(board_info)
    
    # Summary
    print(f"\n🎉 Integration Setup Complete!")
    print(f"   - Reference Issue: {'✅' if issue_created else '❌'}")
    print(f"   - Documentation: {'✅' if doc_created else '❌'}")
    print(f"   - Suggested Approach: {approach}")
    print(f"\n📋 Next Steps:")
    print(f"   1. Review the created reference issue")
    print(f"   2. Read the integration documentation")
    print(f"   3. Decide on integration approach")
    print(f"   4. Execute chosen strategy")

if __name__ == '__main__':
    main() 