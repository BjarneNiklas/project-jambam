#!/usr/bin/env python3
"""
Get Project ID Script for GitHub Project Boards
===============================================

This script helps you get the project ID for GitHub project boards
so you can set up the PROJECT_ID secret in your repository.

Usage:
    python scripts/get_project_id.py
"""

import os
import sys
import requests
from typing import List, Dict, Optional

class ProjectIDHelper:
    def __init__(self):
        self.token = os.environ.get('GITHUB_TOKEN')
        if not self.token:
            print("❌ GITHUB_TOKEN environment variable not set")
            print("   Please set your GitHub token:")
            print("   export GITHUB_TOKEN='your_github_token_here'")
            sys.exit(1)
        
        self.headers = {
            'Authorization': f'Bearer {self.token}',
            'Content-Type': 'application/json',
        }
        
        # Get repository info
        self.repository = os.environ.get('GITHUB_REPOSITORY')
        if self.repository:
            self.owner, self.repo = self.repository.split('/')
        else:
            print("❌ GITHUB_REPOSITORY environment variable not set")
            print("   Please set your repository:")
            print("   export GITHUB_REPOSITORY='owner/repo'")
            sys.exit(1)
    
    def get_user_projects(self) -> List[Dict]:
        """Get all user projects"""
        query = """
        query($login: String!) {
            user(login: $login) {
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
        """
        
        variables = {
            'login': self.owner
        }
        
        try:
            response = requests.post(
                'https://api.github.com/graphql',
                headers=self.headers,
                json={'query': query, 'variables': variables}
            )
            response.raise_for_status()
            
            data = response.json()
            if 'errors' in data:
                print(f"❌ GraphQL errors: {data['errors']}")
                return []
            
            return data['data']['user']['projectsV2']['nodes']
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Error fetching projects: {e}")
            return []
    
    def get_organization_projects(self) -> List[Dict]:
        """Get all organization projects"""
        query = """
        query($login: String!) {
            organization(login: $login) {
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
        """
        
        variables = {
            'login': self.owner
        }
        
        try:
            response = requests.post(
                'https://api.github.com/graphql',
                headers=self.headers,
                json={'query': query, 'variables': variables}
            )
            response.raise_for_status()
            
            data = response.json()
            if 'errors' in data:
                # Organization might not exist, that's okay
                return []
            
            return data['data']['organization']['projectsV2']['nodes']
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Error fetching organization projects: {e}")
            return []
    
    def get_repository_projects(self) -> List[Dict]:
        """Get all repository projects"""
        query = """
        query($owner: String!, $repo: String!) {
            repository(owner: $owner, name: $repo) {
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
        """
        
        variables = {
            'owner': self.owner,
            'repo': self.repo
        }
        
        try:
            response = requests.post(
                'https://api.github.com/graphql',
                headers=self.headers,
                json={'query': query, 'variables': variables}
            )
            response.raise_for_status()
            
            data = response.json()
            if 'errors' in data:
                print(f"❌ GraphQL errors: {data['errors']}")
                return []
            
            return data['data']['repository']['projectsV2']['nodes']
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Error fetching repository projects: {e}")
            return []
    
    def display_projects(self, projects: List[Dict], source: str):
        """Display projects in a formatted way"""
        if not projects:
            print(f"   No {source} projects found")
            return
        
        print(f"\n📋 {source.title()} Projects:")
        print("=" * 60)
        
        for project in projects:
            project_id = project['id']
            title = project['title']
            number = project['number']
            url = project['url']
            created = project['createdAt'][:10]  # Just the date part
            
            print(f"🔹 {title}")
            print(f"   ID: {project_id}")
            print(f"   Number: {number}")
            print(f"   URL: {url}")
            print(f"   Created: {created}")
            print()
    
    def run(self):
        """Main execution function"""
        print("🚀 GitHub Project ID Helper")
        print("=" * 40)
        print(f"Repository: {self.owner}/{self.repo}")
        print(f"Token: {self.token[:10]}...")
        print()
        
        # Get projects from different sources
        user_projects = self.get_user_projects()
        org_projects = self.get_organization_projects()
        repo_projects = self.get_repository_projects()
        
        # Display all projects
        self.display_projects(user_projects, "User")
        self.display_projects(org_projects, "Organization")
        self.display_projects(repo_projects, "Repository")
        
        # Summary
        total_projects = len(user_projects) + len(org_projects) + len(repo_projects)
        
        if total_projects == 0:
            print("❌ No projects found")
            print("\n💡 To create a project board:")
            print("   1. Go to your repository on GitHub")
            print("   2. Click on 'Projects' tab")
            print("   3. Click 'New project'")
            print("   4. Choose 'Board' or 'Table' view")
            print("   5. Run this script again to get the project ID")
        else:
            print(f"\n✅ Found {total_projects} project(s)")
            print("\n📝 To set up PROJECT_ID secret:")
            print("   1. Copy the project ID from above")
            print("   2. Go to your repository Settings → Secrets and variables → Actions")
            print("   3. Click 'New repository secret'")
            print("   4. Name: PROJECT_ID")
            print("   5. Value: [paste the project ID]")
            print("   6. Click 'Add secret'")
            print("\n🔗 Example project ID: PVT_kwDOABc0Nc4AAgE")

def main():
    """Main function"""
    helper = ProjectIDHelper()
    helper.run()

if __name__ == '__main__':
    main() 