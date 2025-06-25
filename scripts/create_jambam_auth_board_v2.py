#!/usr/bin/env python3
"""
JamBam Auth & Identity Platform - GitHub Projects v2 Automation
Creates issues and adds them to the new GitHub Projects v2 board using GraphQL API.
"""

import os
import json
import requests
from typing import Dict, List, Any
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Task:
    title: str
    description: str
    priority: str
    story_points: int
    component: str
    assignee: str
    sprint: str
    acceptance_criteria: List[str]
    dependencies: List[str]
    testing_requirements: List[str]
    documentation_requirements: List[str]

class GitHubProjectsV2Creator:
    def __init__(self, token: str, repo: str, owner: str):
        self.token = token
        self.repo = repo
        self.owner = owner
        self.base_url = "https://api.github.com/graphql"
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Accept": "application/vnd.github.v3+json",
        }
    
    def get_project_id(self) -> str:
        """Get the Project ID for 'JamBam Auth & Identity Platform' from organization projects"""
        query = """
        query($login: String!) {
          organization(login: $login) {
            projectsV2(first: 10) {
              nodes {
                id
                title
                number
              }
            }
          }
        }
        """
        
        variables = {
            "login": "AURAVTECH"  # Use organization name
        }
        
        response = requests.post(
            self.base_url,
            headers=self.headers,
            json={"query": query, "variables": variables}
        )
        response.raise_for_status()
        
        data = response.json()
        projects = data['data']['organization']['projectsV2']['nodes']
        
        for project in projects:
            if project['title'] == 'JamBam Auth & Identity Platform':
                print(f"✅ Found project: {project['title']} (ID: {project['id']})")
                return project['id']
        
        raise Exception("Project 'JamBam Auth & Identity Platform' not found!")
    
    def get_project_fields(self, project_id: str) -> Dict[str, Any]:
        """Get project fields (Status, Sprint, etc.)"""
        query = """
        query($projectId: ID!) {
          node(id: $projectId) {
            ... on ProjectV2 {
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
            }
          }
        }
        """
        
        variables = {"projectId": project_id}
        
        response = requests.post(
            self.base_url,
            headers=self.headers,
            json={"query": query, "variables": variables}
        )
        response.raise_for_status()
        
        data = response.json()
        fields = data['data']['node']['fields']['nodes']
        
        field_info = {}
        for field in fields:
            if field['name'] == 'Status':
                field_info['status'] = {
                    'id': field['id'],
                    'options': {opt['name']: opt['id'] for opt in field.get('options', [])}
                }
            elif field['name'] == 'Sprint':
                field_info['sprint'] = {
                    'id': field['id'],
                    'options': {opt['name']: opt['id'] for opt in field.get('options', [])}
                }
            elif field['name'] == 'Priority':
                field_info['priority'] = {
                    'id': field['id'],
                    'options': {opt['name']: opt['id'] for opt in field.get('options', [])}
                }
        
        print(f"✅ Found project fields: {list(field_info.keys())}")
        return field_info
    
    def create_issue(self, task: Task) -> str:
        """Create a GitHub issue using REST API"""
        url = f"https://api.github.com/repos/{self.owner}/{self.repo}/issues"
        
        # Create issue body
        body = self._create_issue_body(task)
        
        data = {
            "title": f"[AUTH] {task.title}",
            "body": body,
            "labels": ["auth-platform", "authentication", "login-system"],
            "assignees": []  # Remove assignees to avoid 422 error
        }
        
        response = requests.post(url, headers=self.headers, json=data)
        response.raise_for_status()
        
        issue = response.json()
        print(f"✅ Created issue: {issue['title']} (#{issue['number']})")
        return issue['node_id']  # Return GraphQL node ID
    
    def add_issue_to_project(self, project_id: str, issue_id: str, fields: Dict[str, Any], task: Task) -> None:
        """Add issue to project and set field values"""
        # First, add the issue to the project
        add_item_query = """
        mutation($projectId: ID!, $contentId: ID!) {
          addProjectV2Item(input: {projectId: $projectId, contentId: $contentId}) {
            item {
              id
            }
          }
        }
        """
        
        variables = {
            "projectId": project_id,
            "contentId": issue_id
        }
        
        response = requests.post(
            self.base_url,
            headers=self.headers,
            json={"query": add_item_query, "variables": variables}
        )
        response.raise_for_status()
        
        data = response.json()
        item_id = data['data']['addProjectV2Item']['item']['id']
        print(f"✅ Added issue to project (Item ID: {item_id})")
        
        # Now set field values
        self._set_field_values(item_id, fields, task)
    
    def _set_field_values(self, item_id: str, fields: Dict[str, Any], task: Task) -> None:
        """Set field values for the project item"""
        updates = []
        
        # Set Status
        if 'status' in fields and task.priority in ['Critical', 'High']:
            status_option = fields['status']['options'].get('In Progress', None)
            if status_option:
                updates.append(self._create_field_update(item_id, fields['status']['id'], status_option))
        
        # Set Sprint
        if 'sprint' in fields:
            sprint_option = fields['sprint']['options'].get(task.sprint, None)
            if sprint_option:
                updates.append(self._create_field_update(item_id, fields['sprint']['id'], sprint_option))
        
        # Set Priority
        if 'priority' in fields:
            priority_option = fields['priority']['options'].get(task.priority, None)
            if priority_option:
                updates.append(self._create_field_update(item_id, fields['priority']['id'], priority_option))
        
        # Execute all updates
        for update in updates:
            response = requests.post(
                self.base_url,
                headers=self.headers,
                json={"query": update['query'], "variables": update['variables']}
            )
            if response.status_code == 200:
                print(f"✅ Set {update['field_name']} to {update['value']}")
            else:
                print(f"⚠️ Failed to set {update['field_name']}: {response.text}")
    
    def _create_field_update(self, item_id: str, field_id: str, option_id: str) -> Dict[str, Any]:
        """Create a field update mutation"""
        query = """
        mutation($projectId: ID!, $itemId: ID!, $fieldId: ID!, $optionId: String!) {
          updateProjectV2ItemFieldValue(input: {
            projectId: $projectId
            itemId: $itemId
            fieldId: $fieldId
            value: {singleSelectOptionId: $optionId}
          }) {
            projectV2Item {
              id
            }
          }
        }
        """
        
        return {
            "query": query,
            "variables": {
                "projectId": self.project_id,
                "itemId": item_id,
                "fieldId": field_id,
                "optionId": option_id
            },
            "field_name": "field",
            "value": "value"
        }
    
    def _create_issue_body(self, task: Task) -> str:
        """Create the issue body from the task template"""
        acceptance_criteria = "\n".join([f"- [ ] {criteria}" for criteria in task.acceptance_criteria])
        dependencies = "\n".join([f"- {dep}" for dep in task.dependencies]) if task.dependencies else "- None"
        testing_reqs = "\n".join([f"- [ ] {req}" for req in task.testing_requirements])
        doc_reqs = "\n".join([f"- [ ] {req}" for req in task.documentation_requirements])
        
        return f"""## 📋 Task Description
{task.description}

## 🎯 Acceptance Criteria
{acceptance_criteria}

## 🔧 Technical Details

### Component
- [x] {task.component}

### Priority
- [x] {task.priority}

### Story Points
- [x] {task.story_points}

### Sprint
- [x] {task.sprint}

## 🔗 Dependencies
{dependencies}

## 🧪 Testing Requirements
{testing_reqs}

## 📝 Documentation Requirements
{doc_reqs}

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

---

## 🏗️ Modular Architecture Notes

This task is part of the **JamBam Auth & Identity Platform** modular architecture.
Consider how this implementation can be extended for future auth modules and integrations.
"""

def create_auth_platform_tasks() -> List[Task]:
    """Define all tasks for the JamBam Auth & Identity Platform"""
    tasks = [
        # Core Authentication Module
        Task(
            title="Supabase Authentication Integration",
            description="Implement complete Supabase authentication system with email/password, social login, and security features",
            priority="Critical",
            story_points=13,
            component="Backend, Frontend, Database",
            assignee="Backend Lead",
            sprint="Sprint 1",
            acceptance_criteria=[
                "Supabase project configured with authentication providers",
                "Database schema implemented with RLS policies",
                "Authentication service layer implemented",
                "Frontend UI components created",
                "State management integration completed",
                "Security measures implemented",
                "Comprehensive testing and documentation"
            ],
            dependencies=[],
            testing_requirements=[
                "Unit tests for auth service",
                "Integration tests for auth flow",
                "UI tests for login forms",
                "Security tests",
                "Performance tests"
            ],
            documentation_requirements=[
                "API documentation",
                "User documentation",
                "Code comments",
                "README updates"
            ]
        ),
        
        # Guest Access Module
        Task(
            title="Guest Login Implementation",
            description="Implement anonymous user authentication with guest profile management and conversion flow",
            priority="High",
            story_points=8,
            component="Frontend, Backend",
            assignee="Frontend Lead",
            sprint="Sprint 2",
            acceptance_criteria=[
                "Anonymous authentication enabled in Supabase",
                "Guest user profile creation and management",
                "Guest login UI implemented",
                "Guest user experience and limitations",
                "Guest to registered user conversion flow",
                "Comprehensive guest login testing"
            ],
            dependencies=["Supabase Authentication Integration"],
            testing_requirements=[
                "Guest login tests",
                "Conversion tests",
                "Edge case testing",
                "UI tests for guest flow"
            ],
            documentation_requirements=[
                "Guest user documentation",
                "Conversion flow documentation",
                "Code comments"
            ]
        ),
        
        # Offline Access Module
        Task(
            title="Offline Login Implementation",
            description="Implement offline authentication capabilities with local storage and data synchronization",
            priority="Medium",
            story_points=8,
            component="Frontend, Backend",
            assignee="Full Stack Developer",
            sprint="Sprint 2",
            acceptance_criteria=[
                "Offline state detection implemented",
                "Secure local storage for offline data",
                "Offline authentication flow",
                "Data synchronization when connection restored",
                "Comprehensive offline mode testing"
            ],
            dependencies=["Supabase Authentication Integration"],
            testing_requirements=[
                "Offline mode tests",
                "Sync tests",
                "Edge case testing",
                "Performance tests for offline mode"
            ],
            documentation_requirements=[
                "Offline mode documentation",
                "Sync process documentation",
                "Code comments"
            ]
        ),
        
        # Infrastructure Tasks
        Task(
            title="Supabase Project Setup & Configuration",
            description="Configure Supabase project with proper authentication settings for modular architecture",
            priority="Critical",
            story_points=2,
            component="Backend",
            assignee="Backend Lead",
            sprint="Sprint 1",
            acceptance_criteria=[
                "Supabase project created and configured",
                "Authentication providers enabled (Email, Google, GitHub)",
                "RLS policies configured for modular access",
                "Environment variables set up",
                "Modular database structure planned"
            ],
            dependencies=[],
            testing_requirements=["Configuration tests"],
            documentation_requirements=["Setup documentation", "Architecture documentation"]
        ),
        
        Task(
            title="Database Schema Implementation",
            description="Create and implement user profiles table with proper relationships for modular auth system",
            priority="Critical",
            story_points=3,
            component="Database",
            assignee="Backend Lead",
            sprint="Sprint 1",
            acceptance_criteria=[
                "Profiles table created with all required fields",
                "RLS policies implemented for modular access",
                "Triggers for automatic profile creation",
                "Indexes for performance optimization",
                "Modular extension points identified"
            ],
            dependencies=["Supabase Project Setup & Configuration"],
            testing_requirements=["Schema tests", "Performance tests"],
            documentation_requirements=["Schema documentation", "Extension guide"]
        ),
        
        # Module-Specific Tasks
        Task(
            title="Anonymous Authentication Setup",
            description="Configure Supabase for anonymous authentication as part of guest access module",
            priority="High",
            story_points=2,
            component="Backend",
            assignee="Backend Lead",
            sprint="Sprint 2",
            acceptance_criteria=[
                "Anonymous auth enabled in Supabase",
                "Anonymous user profile creation",
                "Guest user permissions configured",
                "Module isolation implemented"
            ],
            dependencies=["Supabase Project Setup & Configuration"],
            testing_requirements=["Anonymous auth tests"],
            documentation_requirements=["Anonymous auth documentation", "Module documentation"]
        ),
        
        Task(
            title="Offline State Detection",
            description="Implement offline/online state detection for offline access module",
            priority="Medium",
            story_points=2,
            component="Frontend",
            assignee="Full Stack Developer",
            sprint="Sprint 2",
            acceptance_criteria=[
                "Network status monitoring",
                "Offline state indicators",
                "Connection recovery handling",
                "Module-specific offline features"
            ],
            dependencies=[],
            testing_requirements=["Network detection tests"],
            documentation_requirements=["Offline detection documentation", "Module integration guide"]
        )
    ]
    
    return tasks

def main():
    """Main function to create the complete Auth Platform board"""
    # Configuration
    github_token = os.getenv("GITHUB_TOKEN")
    repo_name = "project-jambam"
    owner_name = "BjarneNiklas"
    
    if not github_token:
        print("❌ Error: GITHUB_TOKEN environment variable not set")
        print("Please set your GitHub token: export GITHUB_TOKEN=your_token_here")
        return
    
    try:
        print("🚀 Starting JamBam Auth & Identity Platform automation...")
        
        # Initialize GitHub Projects v2 Creator
        creator = GitHubProjectsV2Creator(github_token, repo_name, owner_name)
        
        # Get project ID
        project_id = creator.get_project_id()
        creator.project_id = project_id  # Store for field updates
        
        # Get project fields
        fields = creator.get_project_fields(project_id)
        
        # Get all tasks
        all_tasks = create_auth_platform_tasks()
        
        print(f"\n📋 Creating {len(all_tasks)} issues for JamBam Auth & Identity Platform...")
        
        # Create issues and add to project
        for task in all_tasks:
            # Create issue
            issue_id = creator.create_issue(task)
            
            # Add to project and set field values
            creator.add_issue_to_project(project_id, issue_id, fields, task)
        
        print(f"\n🎉 Successfully created Auth Platform board with {len(all_tasks)} tasks!")
        print(f"📋 Project URL: https://github.com/{owner_name}/{repo_name}/projects")
        print(f"📝 Next steps:")
        print(f"   1. Review the created issues in the project board")
        print(f"   2. Assign tasks to team members")
        print(f"   3. Set up automation rules for status transitions")
        print(f"   4. Begin Sprint 1 implementation")
        print(f"   5. Plan future auth modules and extensions")
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Error creating project: {e}")
        if hasattr(e, 'response') and e.response:
            print(f"Response: {e.response.text}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main() 