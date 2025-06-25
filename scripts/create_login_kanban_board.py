#!/usr/bin/env python3
"""
JambaM Login System Kanban Board Creator
Automatically creates GitHub Project Board and all issues for the login system implementation.
"""

import os
import json
import requests
from typing import Dict, List, Any
from dataclasses import dataclass
from datetime import datetime, timedelta

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

@dataclass
class Subtask(Task):
    parent_task: str

class GitHubProjectCreator:
    def __init__(self, token: str, repo: str, owner: str):
        self.token = token
        self.repo = repo
        self.owner = owner
        self.base_url = "https://api.github.com"
        self.headers = {
            "Authorization": f"token {token}",
            "Accept": "application/vnd.github.v3+json",
            "X-GitHub-Api-Version": "2022-11-28"
        }
        
    def create_project_board(self, name: str, description: str) -> Dict[str, Any]:
        """Create a new GitHub Project Board"""
        url = f"{self.base_url}/repos/{self.owner}/{self.repo}/projects"
        data = {
            "name": name,
            "body": description,
            "private": False
        }
        
        response = requests.post(url, headers=self.headers, json=data)
        response.raise_for_status()
        
        project = response.json()
        print(f"✅ Created project board: {project['name']} (ID: {project['id']})")
        return project
    
    def create_project_columns(self, project_id: int) -> Dict[str, int]:
        """Create columns for the Kanban board"""
        columns = {
            "📋 BACKLOG": "Backlog items and future planning",
            "📝 TO DO": "Tasks ready to be worked on",
            "🔄 IN PROGRESS": "Tasks currently being worked on",
            "👀 REVIEW": "Tasks ready for review",
            "🧪 TESTING": "Tasks being tested",
            "✅ DONE": "Completed tasks"
        }
        
        column_ids = {}
        for column_name, column_description in columns.items():
            url = f"{self.base_url}/projects/{project_id}/columns"
            data = {"name": column_name}
            
            response = requests.post(url, headers=self.headers, json=data)
            response.raise_for_status()
            
            column = response.json()
            column_ids[column_name] = column['id']
            print(f"✅ Created column: {column_name}")
        
        return column_ids
    
    def create_issue(self, task: Task, labels: List[str] = None) -> Dict[str, Any]:
        """Create a GitHub issue for a task"""
        url = f"{self.base_url}/repos/{self.owner}/{self.repo}/issues"
        
        # Create issue body from task template
        body = self._create_issue_body(task)
        
        data = {
            "title": f"[LOGIN] {task.title}",
            "body": body,
            "labels": labels or ["login-system", "authentication"],
            "assignees": [task.assignee] if task.assignee else []
        }
        
        response = requests.post(url, headers=self.headers, json=data)
        response.raise_for_status()
        
        issue = response.json()
        print(f"✅ Created issue: {issue['title']} (#{issue['number']})")
        return issue
    
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
"""
    
    def add_issue_to_project(self, project_id: int, column_id: int, issue_id: int) -> None:
        """Add an issue to a project column"""
        url = f"{self.base_url}/projects/columns/{column_id}/cards"
        data = {"content_id": issue_id, "content_type": "Issue"}
        
        response = requests.post(url, headers=self.headers, json=data)
        response.raise_for_status()
        
        print(f"✅ Added issue #{issue_id} to project column")

def create_login_system_tasks() -> List[Task]:
    """Define all tasks for the login system"""
    tasks = [
        # Main Task 1: Supabase Authentication Integration
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
        
        # Main Task 2: Guest Login Implementation
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
        
        # Main Task 3: Offline Login Implementation
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
        )
    ]
    
    # Add subtasks
    subtasks = [
        # Supabase subtasks
        Subtask(
            title="Supabase Project Setup & Configuration",
            description="Configure Supabase project with proper authentication settings",
            priority="Critical",
            story_points=2,
            component="Backend",
            assignee="Backend Lead",
            sprint="Sprint 1",
            acceptance_criteria=[
                "Supabase project created and configured",
                "Authentication providers enabled (Email, Google, GitHub)",
                "RLS policies configured",
                "Environment variables set up"
            ],
            dependencies=[],
            testing_requirements=["Configuration tests"],
            documentation_requirements=["Setup documentation"],
            parent_task="Supabase Authentication Integration"
        ),
        
        Subtask(
            title="Database Schema Implementation",
            description="Create and implement user profiles table with proper relationships",
            priority="Critical",
            story_points=3,
            component="Database",
            assignee="Backend Lead",
            sprint="Sprint 1",
            acceptance_criteria=[
                "Profiles table created with all required fields",
                "RLS policies implemented",
                "Triggers for automatic profile creation",
                "Indexes for performance optimization"
            ],
            dependencies=["Supabase Project Setup & Configuration"],
            testing_requirements=["Schema tests", "Performance tests"],
            documentation_requirements=["Schema documentation"],
            parent_task="Supabase Authentication Integration"
        ),
        
        # Guest login subtasks
        Subtask(
            title="Anonymous Authentication Setup",
            description="Configure Supabase for anonymous authentication",
            priority="High",
            story_points=2,
            component="Backend",
            assignee="Backend Lead",
            sprint="Sprint 2",
            acceptance_criteria=[
                "Anonymous auth enabled in Supabase",
                "Anonymous user profile creation",
                "Guest user permissions configured"
            ],
            dependencies=["Supabase Project Setup & Configuration"],
            testing_requirements=["Anonymous auth tests"],
            documentation_requirements=["Anonymous auth documentation"],
            parent_task="Guest Login Implementation"
        ),
        
        # Offline login subtasks
        Subtask(
            title="Offline State Detection",
            description="Implement offline/online state detection",
            priority="Medium",
            story_points=2,
            component="Frontend",
            assignee="Full Stack Developer",
            sprint="Sprint 2",
            acceptance_criteria=[
                "Network status monitoring",
                "Offline state indicators",
                "Connection recovery handling"
            ],
            dependencies=[],
            testing_requirements=["Network detection tests"],
            documentation_requirements=["Offline detection documentation"],
            parent_task="Offline Login Implementation"
        )
    ]
    
    return tasks + subtasks

def main():
    """Main function to create the complete Kanban board"""
    # Configuration
    github_token = os.getenv("GITHUB_TOKEN")
    repo_name = "project-jambam"
    owner_name = "BjarneNiklas"  # Correct GitHub username without spaces
    
    if not github_token:
        print("❌ Error: GITHUB_TOKEN environment variable not set")
        print("Please set your GitHub token: export GITHUB_TOKEN=your_token_here")
        return
    
    try:
        # Initialize GitHub Project Creator
        creator = GitHubProjectCreator(github_token, repo_name, owner_name)
        
        # Create project board
        project = creator.create_project_board(
            name="JambaM Login System Implementation",
            description="Complete login system implementation with Supabase, guest login, and offline capabilities"
        )
        
        # Create columns
        column_ids = creator.create_project_columns(project['id'])
        
        # Get all tasks
        all_tasks = create_login_system_tasks()
        
        # Create issues and add to project
        backlog_column_id = column_ids["📋 BACKLOG"]
        
        for task in all_tasks:
            # Create issue
            issue = creator.create_issue(task)
            
            # Add to backlog column
            creator.add_issue_to_project(project['id'], backlog_column_id, issue['id'])
        
        print(f"\n🎉 Successfully created Kanban board with {len(all_tasks)} tasks!")
        print(f"📋 Project URL: {project['html_url']}")
        print(f"📝 Next steps:")
        print(f"   1. Review and assign tasks to team members")
        print(f"   2. Move tasks to appropriate columns")
        print(f"   3. Set up automation rules")
        print(f"   4. Begin Sprint 1 implementation")
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Error creating project: {e}")
        if hasattr(e, 'response') and e.response:
            print(f"Response: {e.response.text}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main() 