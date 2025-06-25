#!/usr/bin/env python3
"""
Phase Automation Script for JamBam Platform
Handles automatic phase assignment, project board management, and issue categorization.
"""

import os
import sys
import json
import requests
from typing import Dict, List, Optional
from datetime import datetime

class PhaseAutomation:
    def __init__(self):
        self.token = os.environ.get('GITHUB_TOKEN')
        self.project_id = os.environ.get('PROJECT_ID', '').strip()
        
        if not self.token:
            print("❌ GITHUB_TOKEN environment variable not set")
            sys.exit(1)
        
        # Log PROJECT_ID status
        if self.project_id:
            print(f"✅ PROJECT_ID configured: {self.project_id[:10]}...")
        else:
            print("⚠️  PROJECT_ID not set - project board integration will be skipped")
        
        self.headers = {
            'Authorization': f'Bearer {self.token}',
            'Content-Type': 'application/json',
        }
        
        # Get repository info from GitHub context
        self.repository = os.environ.get('GITHUB_REPOSITORY')
        if self.repository:
            self.owner, self.repo = self.repository.split('/')
        else:
            print("❌ GITHUB_REPOSITORY environment variable not set")
            sys.exit(1)
    
    def get_issue_data(self, issue_number: int) -> Optional[Dict]:
        """Get issue data from GitHub API"""
        url = f'https://api.github.com/repos/{self.owner}/{self.repo}/issues/{issue_number}'
        
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            return response.json()
        else:
            print(f"❌ Failed to get issue {issue_number}: {response.status_code}")
            return None
    
    def add_to_project_board(self, issue_node_id: str) -> bool:
        """Add issue to project board"""
        if not self.project_id:
            print("⚠️  PROJECT_ID not set, skipping project board addition")
            return False
        
        query = """
        mutation AddProjectV2Item($input: AddProjectV2ItemInput!) {
            addProjectV2Item(input: $input) {
                item {
                    id
                }
            }
        }
        """
        
        variables = {
            "input": {
                "projectId": self.project_id,
                "contentId": issue_node_id
            }
        }
        
        response = requests.post(
            'https://api.github.com/graphql',
            headers=self.headers,
            json={'query': query, 'variables': variables}
        )
        
        if response.status_code == 200:
            result = response.json()
            if 'errors' not in result:
                print(f"✅ Added issue to project board")
                return True
            else:
                print(f"❌ GraphQL errors: {result['errors']}")
        else:
            print(f"❌ Failed to add to project board: {response.status_code}")
        
        return False
    
    def suggest_phase_labels(self, issue_data: Dict) -> List[str]:
        """Suggest phase labels based on issue content"""
        title = issue_data.get('title', '').lower()
        body = issue_data.get('body', '').lower()
        content = title + ' ' + body
        
        suggestions = []
        
        # Phase suggestions based on content
        if any(word in content for word in ['kickoff', 'setup', 'foundation', 'initial']):
            suggestions.append('phase-1-kickoff')
        
        if any(word in content for word in ['research', 'ideation', 'market', 'analysis', 'study']):
            suggestions.append('phase-2-ideation')
        
        if any(word in content for word in ['mvp', 'minimum', 'core', 'basic', 'essential']):
            suggestions.append('phase-3-mvp')
        
        if any(word in content for word in ['thesis', 'academic', 'research', 'master', 'university']):
            suggestions.append('phase-4-masterthesis')
        
        if any(word in content for word in ['alpha', 'testing', 'internal', 'debug']):
            suggestions.append('phase-5-alpha')
        
        if any(word in content for word in ['beta', 'external', 'user feedback', 'public test']):
            suggestions.append('phase-6-beta')
        
        if any(word in content for word in ['launch', 'public', 'release', 'go live']):
            suggestions.append('phase-7-launch')
        
        if any(word in content for word in ['growth', 'scaling', 'expansion', 'scale up']):
            suggestions.append('phase-8-growth')
        
        if any(word in content for word in ['future', 'innovation', 'vision', 'next gen']):
            suggestions.append('phase-9-future')
        
        return suggestions
    
    def suggest_module_labels(self, issue_data: Dict) -> List[str]:
        """Suggest module labels based on issue content"""
        title = issue_data.get('title', '').lower()
        body = issue_data.get('body', '').lower()
        content = title + ' ' + body
        
        suggestions = []
        
        # Module suggestions
        if any(word in content for word in ['ai', 'agent', 'intelligence', 'machine learning', 'neural']):
            suggestions.append('module-ai')
        
        if any(word in content for word in ['community', 'squad', 'legion', 'team', 'social']):
            suggestions.append('module-community')
        
        if any(word in content for word in ['battle', 'competition', 'game', 'match', 'tournament']):
            suggestions.append('module-battle')
        
        if any(word in content for word in ['asset', 'content', 'generation', '3d', 'model']):
            suggestions.append('module-assets')
        
        if any(word in content for word in ['academy', 'lab', 'learning', 'education', 'tutorial']):
            suggestions.append('module-academy')
        
        if any(word in content for word in ['workflow', 'integration', 'api', 'automation']):
            suggestions.append('module-workflow')
        
        if any(word in content for word in ['security', 'compliance', 'gdpr', 'privacy', 'audit']):
            suggestions.append('module-security')
        
        if any(word in content for word in ['business', 'pro', 'premium', 'enterprise', 'commercial']):
            suggestions.append('module-business')
        
        return suggestions
    
    def suggest_type_labels(self, issue_data: Dict) -> List[str]:
        """Suggest type labels based on issue content"""
        title = issue_data.get('title', '').lower()
        body = issue_data.get('body', '').lower()
        content = title + ' ' + body
        
        suggestions = []
        
        # Type suggestions
        if any(word in content for word in ['bug', 'fix', 'error', 'crash', 'broken']):
            suggestions.append('type-bug')
        
        if any(word in content for word in ['feature', 'new', 'add', 'implement']):
            suggestions.append('type-feature')
        
        if any(word in content for word in ['enhancement', 'improve', 'optimize', 'better']):
            suggestions.append('type-enhancement')
        
        if any(word in content for word in ['documentation', 'doc', 'guide', 'readme', 'wiki']):
            suggestions.append('type-documentation')
        
        if any(word in content for word in ['research', 'study', 'analysis', 'investigation']):
            suggestions.append('type-research')
        
        return suggestions
    
    def suggest_priority_labels(self, issue_data: Dict) -> List[str]:
        """Suggest priority labels based on issue content"""
        title = issue_data.get('title', '').lower()
        body = issue_data.get('body', '').lower()
        content = title + ' ' + body
        
        suggestions = []
        
        # Priority suggestions
        if any(word in content for word in ['critical', 'urgent', 'blocker', 'emergency']):
            suggestions.append('priority-critical')
        
        elif any(word in content for word in ['high', 'important', 'priority']):
            suggestions.append('priority-high')
        
        elif any(word in content for word in ['medium', 'normal', 'standard']):
            suggestions.append('priority-medium')
        
        elif any(word in content for word in ['low', 'nice to have', 'optional']):
            suggestions.append('priority-low')
        
        return suggestions
    
    def process_issue(self, issue_number: int):
        """Process a single issue for phase automation"""
        print(f"🔍 Processing issue #{issue_number}")
        
        # Get issue data
        issue_data = self.get_issue_data(issue_number)
        if not issue_data:
            return
        
        # Add to project board if not already there
        if self.project_id:
            self.add_to_project_board(issue_data['node_id'])
        
        # Generate label suggestions
        phase_suggestions = self.suggest_phase_labels(issue_data)
        module_suggestions = self.suggest_module_labels(issue_data)
        type_suggestions = self.suggest_type_labels(issue_data)
        priority_suggestions = self.suggest_priority_labels(issue_data)
        
        all_suggestions = phase_suggestions + module_suggestions + type_suggestions + priority_suggestions
        
        if all_suggestions:
            print(f"  💡 Suggested labels: {', '.join(all_suggestions)}")
        
        # Check if issue needs phase assignment
        current_labels = [label['name'] for label in issue_data.get('labels', [])]
        phase_labels = [label for label in current_labels if label.startswith('phase-')]
        
        if not phase_labels and phase_suggestions:
            print(f"  ⚠️  No phase label found, consider adding: {phase_suggestions[0]}")
    
    def run(self):
        """Main execution function"""
        print("🚀 Starting Phase Automation for JamBam Platform")
        print(f"Repository: {self.owner}/{self.repo}")
        
        # Get the issue number from GitHub context
        event_path = os.environ.get('GITHUB_EVENT_PATH')
        if event_path and os.path.exists(event_path):
            with open(event_path, 'r') as f:
                event_data = json.load(f)
            
            # Handle different event types
            if 'issue' in event_data:
                issue_number = event_data['issue']['number']
                self.process_issue(issue_number)
            elif 'pull_request' in event_data:
                pr_number = event_data['pull_request']['number']
                print(f"📝 Processing PR #{pr_number}")
                # Handle PR processing if needed
            else:
                print("⚠️  Unknown event type")
        else:
            print("⚠️  No event data found")
        
        print("✅ Phase automation complete")

def main():
    automation = PhaseAutomation()
    automation.run()

if __name__ == "__main__":
    main() 