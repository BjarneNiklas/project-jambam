#!/usr/bin/env python3
"""
JamBam Project Board Creator with 9 Phases
Automatically creates a comprehensive GitHub Project Board with all phases, epics, and labels.
"""

import os
import sys
import json
import requests
from typing import Dict, List, Optional
import argparse
from datetime import datetime

class GitHubProjectCreator:
    def __init__(self, token: str, owner: str, repo: str = None):
        self.token = token
        self.owner = owner
        self.repo = repo
        self.headers = {
            'Authorization': f'token {token}',
            'Accept': 'application/vnd.github.v3+json'
        }
        self.graphql_headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json',
        }
        
    def create_project_board(self, title: str, description: str) -> Optional[str]:
        """Create a new GitHub Project Board (v2)"""
        query = """
        mutation CreateProject($input: CreateProjectV2Input!) {
            createProjectV2(input: $input) {
                projectV2 {
                    id
                    title
                    url
                }
            }
        }
        """
        
        variables = {
            "input": {
                "title": title,
                "description": description,
                "ownerId": self._get_owner_id()
            }
        }
        
        response = requests.post(
            'https://api.github.com/graphql',
            headers=self.graphql_headers,
            json={'query': query, 'variables': variables}
        )
        
        if response.status_code == 200:
            result = response.json()
            if 'errors' not in result:
                project_id = result['data']['createProjectV2']['projectV2']['id']
                project_url = result['data']['createProjectV2']['projectV2']['url']
                print(f"✅ Project created: {project_url}")
                return project_id
            else:
                print(f"❌ GraphQL errors: {result['errors']}")
        else:
            print(f"❌ Failed to create project: {response.status_code}")
            print(response.text)
        
        return None
    
    def _get_owner_id(self) -> str:
        """Get the owner ID (user or organization)"""
        if self.repo:
            # Repository owner
            response = requests.get(
                f'https://api.github.com/repos/{self.owner}/{self.repo}',
                headers=self.headers
            )
            if response.status_code == 200:
                return response.json()['owner']['node_id']
        else:
            # User/Organization owner
            response = requests.get(
                f'https://api.github.com/users/{self.owner}',
                headers=self.headers
            )
            if response.status_code == 200:
                return response.json()['node_id']
        
        raise Exception(f"Could not get owner ID for {self.owner}")
    
    def create_labels(self) -> Dict[str, str]:
        """Create all labels for the project"""
        labels_data = {
            # Phase Labels
            "phase-1-kickoff": {"color": "0e8a16", "description": "Phase 1: Project Kickoff & Foundation"},
            "phase-2-ideation": {"color": "1d76db", "description": "Phase 2: Ideation & Research"},
            "phase-3-mvp": {"color": "fbca04", "description": "Phase 3: MVP Development"},
            "phase-4-masterthesis": {"color": "d93f0b", "description": "Phase 4: Masterthesis Implementation"},
            "phase-5-alpha": {"color": "fef2c0", "description": "Phase 5: Alpha Testing"},
            "phase-6-beta": {"color": "c2e0c6", "description": "Phase 6: Beta Testing"},
            "phase-7-launch": {"color": "d4c5f9", "description": "Phase 7: Public Launch"},
            "phase-8-growth": {"color": "bfdadc", "description": "Phase 8: Growth & Scaling"},
            "phase-9-future": {"color": "f9d0c4", "description": "Phase 9: Future Vision"},
            
            # Priority Labels
            "priority-critical": {"color": "d73a4a", "description": "Critical priority"},
            "priority-high": {"color": "fbca04", "description": "High priority"},
            "priority-medium": {"color": "0e8a16", "description": "Medium priority"},
            "priority-low": {"color": "1d76db", "description": "Low priority"},
            
            # Type Labels
            "type-feature": {"color": "0e8a16", "description": "New feature"},
            "type-bug": {"color": "d73a4a", "description": "Bug fix"},
            "type-enhancement": {"color": "1d76db", "description": "Enhancement"},
            "type-documentation": {"color": "0075ca", "description": "Documentation"},
            "type-research": {"color": "d4c5f9", "description": "Research task"},
            "type-thesis": {"color": "fef2c0", "description": "Masterthesis related"},
            
            # Module Labels
            "module-ai": {"color": "d4c5f9", "description": "AI & Multi-Agent Systems"},
            "module-community": {"color": "0e8a16", "description": "Community & Squads"},
            "module-battle": {"color": "d73a4a", "description": "Battle Management"},
            "module-assets": {"color": "fbca04", "description": "Asset & Content Generation"},
            "module-academy": {"color": "1d76db", "description": "Academy & Labs"},
            "module-workflow": {"color": "bfdadc", "description": "Workflow & Integration"},
            "module-security": {"color": "f9d0c4", "description": "Security & Compliance"},
            "module-business": {"color": "0075ca", "description": "Business & Pro Features"},
            
            # Status Labels
            "status-ready": {"color": "0e8a16", "description": "Ready to work on"},
            "status-in-progress": {"color": "fbca04", "description": "In progress"},
            "status-review": {"color": "1d76db", "description": "Under review"},
            "status-blocked": {"color": "d73a4a", "description": "Blocked"},
            "status-done": {"color": "bfdadc", "description": "Completed"},
            
            # Special Labels
            "masterthesis": {"color": "d4c5f9", "description": "Masterthesis relevant"},
            "product": {"color": "0e8a16", "description": "Product feature"},
            "research": {"color": "fef2c0", "description": "Research component"},
            "german-market": {"color": "1d76db", "description": "German market focus"},
            "european-market": {"color": "0075ca", "description": "European market focus"},
            "epic": {"color": "d4c5f9", "description": "Epic issue"}
        }
        
        created_labels = {}
        
        for label_name, label_data in labels_data.items():
            if self._create_label(label_name, label_data):
                created_labels[label_name] = label_data
        
        print(f"✅ Created {len(created_labels)} labels")
        return created_labels
    
    def _create_label(self, name: str, data: Dict) -> bool:
        """Create a single label"""
        if self.repo:
            url = f'https://api.github.com/repos/{self.owner}/{self.repo}/labels'
        else:
            url = f'https://api.github.com/orgs/{self.owner}/labels'
        
        payload = {
            'name': name,
            'color': data['color'],
            'description': data['description']
        }
        
        response = requests.post(url, headers=self.headers, json=payload)
        
        if response.status_code in [200, 201]:
            print(f"  ✅ Label '{name}' created")
            return True
        elif response.status_code == 422:  # Label already exists
            print(f"  ⚠️  Label '{name}' already exists")
            return True
        else:
            print(f"  ❌ Failed to create label '{name}': {response.status_code}")
            return False
    
    def create_epics(self) -> Dict[str, str]:
        """Create epic issues for each module"""
        epics_data = {
            "ai-multi-agent": {
                "title": "🤖 AI & Multi-Agent Systems",
                "body": """## AI & Multi-Agent Systems Epic

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
- `type-research`""",
                "labels": ["module-ai", "epic"]
            },
            "community-squads": {
                "title": "👥 Community & Squads System",
                "body": """## Community & Squads System Epic

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
- `type-feature`""",
                "labels": ["module-community", "epic"]
            },
            "battle-management": {
                "title": "⚔️ Battle Management System",
                "body": """## Battle Management System Epic

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
- `type-feature`""",
                "labels": ["module-battle", "epic"]
            },
            "asset-generation": {
                "title": "🎨 Asset & Content Generation",
                "body": """## Asset & Content Generation Epic

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
- `type-research`""",
                "labels": ["module-assets", "epic"]
            },
            "academy-labs": {
                "title": "🎓 Academy & Labs System",
                "body": """## Academy & Labs System Epic

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
- `type-feature`""",
                "labels": ["module-academy", "epic"]
            },
            "workflow-integration": {
                "title": "🔧 Workflow & Integration",
                "body": """## Workflow & Integration Epic

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
- `type-enhancement`""",
                "labels": ["module-workflow", "epic"]
            },
            "security-compliance": {
                "title": "🔒 Security & Compliance",
                "body": """## Security & Compliance Epic

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
- `type-enhancement`""",
                "labels": ["module-security", "epic"]
            },
            "business-pro": {
                "title": "💼 Business & Pro Features",
                "body": """## Business & Pro Features Epic

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
- `type-feature`""",
                "labels": ["module-business", "epic"]
            }
        }
        
        created_epics = {}
        
        for epic_key, epic_data in epics_data.items():
            if self.repo:
                epic_id = self._create_issue(
                    epic_data["title"],
                    epic_data["body"],
                    epic_data["labels"]
                )
                if epic_id:
                    created_epics[epic_key] = epic_id
        
        print(f"✅ Created {len(created_epics)} epics")
        return created_epics
    
    def _create_issue(self, title: str, body: str, labels: List[str]) -> Optional[str]:
        """Create an issue"""
        if not self.repo:
            print("⚠️  Cannot create issues without repository")
            return None
        
        payload = {
            'title': title,
            'body': body,
            'labels': labels
        }
        
        response = requests.post(
            f'https://api.github.com/repos/{self.owner}/{self.repo}/issues',
            headers=self.headers,
            json=payload
        )
        
        if response.status_code == 201:
            issue_data = response.json()
            print(f"  ✅ Issue '{title}' created: {issue_data['html_url']}")
            return issue_data['node_id']
        else:
            print(f"  ❌ Failed to create issue '{title}': {response.status_code}")
            return None
    
    def create_milestones(self) -> Dict[str, str]:
        """Create milestones for all 9 phases"""
        milestones_data = {
            "phase-1-kickoff": {
                "title": "🚀 Phase 1: Project Kickoff",
                "description": "Foundation setup, team formation, and initial planning",
                "state": "open",
                "due_on": "2024-03-31T23:59:59Z"
            },
            "phase-2-ideation": {
                "title": "💡 Phase 2: Ideation & Research",
                "description": "Research phase, concept development, and market analysis",
                "state": "open",
                "due_on": "2024-05-31T23:59:59Z"
            },
            "phase-3-mvp": {
                "title": "⚡ Phase 3: MVP Development",
                "description": "Minimum viable product development and core features",
                "state": "open",
                "due_on": "2024-07-31T23:59:59Z"
            },
            "phase-4-masterthesis": {
                "title": "🎓 Phase 4: Masterthesis Implementation",
                "description": "Academic research implementation and thesis development",
                "state": "open",
                "due_on": "2024-09-30T23:59:59Z"
            },
            "phase-5-alpha": {
                "title": "🧪 Phase 5: Alpha Testing",
                "description": "Internal testing, bug fixes, and feature refinement",
                "state": "open",
                "due_on": "2024-11-30T23:59:59Z"
            },
            "phase-6-beta": {
                "title": "🔍 Phase 6: Beta Testing",
                "description": "External beta testing and user feedback integration",
                "state": "open",
                "due_on": "2025-01-31T23:59:59Z"
            },
            "phase-7-launch": {
                "title": "🎉 Phase 7: Public Launch",
                "description": "Public release and initial user acquisition",
                "state": "open",
                "due_on": "2025-03-31T23:59:59Z"
            },
            "phase-8-growth": {
                "title": "📈 Phase 8: Growth & Scaling",
                "description": "User growth, feature expansion, and platform scaling",
                "state": "open",
                "due_on": "2025-06-30T23:59:59Z"
            },
            "phase-9-future": {
                "title": "🔮 Phase 9: Future Vision",
                "description": "Advanced features, AI integration, and market expansion",
                "state": "open",
                "due_on": "2025-12-31T23:59:59Z"
            }
        }
        
        created_milestones = {}
        
        for milestone_key, milestone_data in milestones_data.items():
            if self.repo:
                milestone_id = self._create_milestone(milestone_data)
                if milestone_id:
                    created_milestones[milestone_key] = milestone_id
        
        print(f"✅ Created {len(created_milestones)} milestones")
        return created_milestones
    
    def _create_milestone(self, data: Dict) -> Optional[str]:
        """Create a milestone"""
        if not self.repo:
            print("⚠️  Cannot create milestones without repository")
            return None
        
        payload = {
            'title': data['title'],
            'description': data['description'],
            'state': data['state'],
            'due_on': data['due_on']
        }
        
        response = requests.post(
            f'https://api.github.com/repos/{self.owner}/{self.repo}/milestones',
            headers=self.headers,
            json=payload
        )
        
        if response.status_code == 201:
            milestone_data = response.json()
            print(f"  ✅ Milestone '{data['title']}' created")
            return milestone_data['number']
        else:
            print(f"  ❌ Failed to create milestone '{data['title']}': {response.status_code}")
            return None

def main():
    parser = argparse.ArgumentParser(description='Create JamBam Project Board with all phases')
    parser.add_argument('--token', required=True, help='GitHub Personal Access Token')
    parser.add_argument('--owner', required=True, help='GitHub owner (user or org)')
    parser.add_argument('--repo', help='Repository name (optional for org boards)')
    parser.add_argument('--title', default='JamBam Platform - Complete Roadmap', help='Project board title')
    parser.add_argument('--description', default='Comprehensive project management for JamBam platform with 9 phases', help='Project board description')
    
    args = parser.parse_args()
    
    creator = GitHubProjectCreator(args.token, args.owner, args.repo)
    
    print("🚀 Creating JamBam Project Board with all phases...")
    print(f"Owner: {args.owner}")
    if args.repo:
        print(f"Repository: {args.repo}")
    print()
    
    # Create project board
    project_id = creator.create_project_board(args.title, args.description)
    if not project_id:
        print("❌ Failed to create project board")
        sys.exit(1)
    
    print()
    
    # Create labels
    print("🏷️  Creating labels...")
    creator.create_labels()
    
    print()
    
    # Create epics (if repository is provided)
    if args.repo:
        print("📋 Creating epics...")
        creator.create_epics()
        
        print()
        
        # Create milestones
        print("🎯 Creating milestones...")
        creator.create_milestones()
    
    print()
    print("✅ JamBam Project Board setup complete!")
    print()
    print("📋 Next steps:")
    print("1. Add issues to the project board")
    print("2. Organize issues by phases using labels")
    print("3. Link issues to epics and milestones")
    print("4. Set up GitHub Actions for automation")
    print()
    print("🔗 Useful resources:")
    print("- GitHub Actions for auto-adding issues to board")
    print("- Issue templates for standardization")
    print("- Automated changelog generation")

if __name__ == "__main__":
    main() 