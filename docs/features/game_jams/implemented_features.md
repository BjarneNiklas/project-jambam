# Game Jam Features: Backend Implementation Summary

This document outlines the Game Jam related features that have been implemented in the backend, primarily within the `GameJamManager` and associated data models. The backend now provides a comprehensive API (defined in `gamejam/api/gamejam_api.yaml`) to support these functionalities.

## 1. Game Jam Generator

The Game Jam Generator encompasses a suite of tools to help organizers run dynamic and engaging game jams.

*   **Theme Generation & Suggestion:**
    *   **Curated Themes:** Administrators can define and manage a list of curated themes. Organizers can fetch these themes.
    *   **Theme Suggestions:** The system can provide organizers with theme suggestions, combining randomly generated word combinations and picks from the curated list.
    *   Organizers can still define their own custom theme for a jam.
    *   The `GameJam` model now includes a `theme_suggestions_enabled` flag.

*   **Advanced Team Formation:**
    *   **Team Management:** Users can create teams within a jam, assign a leader, provide a name and description. Team status (open, full, locked) can be managed.
    *   **Team Membership:** Participants can request to join open teams. Team leaders can approve or reject these requests. Leaders can also remove members or update their roles within the team. Participants can leave teams.
    *   **Team Formation Ideas:** Participants looking for team members can post project ideas with descriptions and desired skills. Others can browse these ideas.
    *   The `GameJam` model now includes a `team_formation_enabled` flag.

*   **Comprehensive Submission System:**
    *   The `GameSubmission` model has been enhanced to include fields for:
        *   `genre` (e.g., "Puzzle", "Platformer")
        *   `engine_used` (e.g., "Unity", "Godot")
        *   `platforms` (e.g., "Windows", "Web")
        *   `controls_instructions`
    *   Backend logic for creating and updating submissions now supports these new fields.

*   **Flexible Evaluation/Voting System:**
    *   **Voting Criteria:** Organizers can define custom evaluation criteria for their jam (e.g., "Gameplay", "Graphics", "Theme Adherence"), each with a name, description, and maximum score.
    *   **Judge Assignment:** Organizers can assign specific users as judges for a jam.
    *   **Voting Process:** Eligible voters (participants and assigned judges) can cast votes on submissions based on the defined criteria. The system prevents users from voting on their own (or their team's) submissions.
    *   **Results Calculation:** The system can calculate and provide aggregated voting results for a jam, including average scores per criterion for each submission and an overall average score, along with a basic ranking.
    *   The `GameJam` model now includes a `voting_enabled` flag.

## 2. Community & Spectator Features

These features aim to increase engagement from users who may not be direct participants in creating a game but wish to be part of the jam community.

*   **Spectator Voting/Feedback:**
    *   Authenticated users (spectators, participants) can provide feedback on game submissions. This includes:
        *   A star rating (e.g., 1-5).
        *   A "like" toggle.
        *   Textual comments.
    *   This feedback is distinct from the official judging/evaluation system.
    *   The `GameSubmission` model is updated to store aggregated community feedback metrics (`community_average_rating`, `community_feedback_count`, `community_like_count`). These are updated when new feedback is submitted.
    *   The `GameJam` model has a `community_feedback_enabled` flag.

*   **Community Challenges/Suggestions:**
    *   Users can propose additional "mini-themes" or challenges for an ongoing game jam.
    *   Organizers can review these suggestions and approve, reject, or feature them. Approved challenges can then be highlighted to participants.
    *   The `GameJam` model has a `community_challenges_enabled` flag.

*   **Public Showcase Aspects (API Support):**
    *   The API supports public-facing endpoints for listing jams and viewing details of specific jams and their submissions.
    *   This allows a UI to build rich public views, leaderboards (based on official results or community scores), and highlights.
    *   Information such as jam details, submission titles, team/participant names, game URLs, and community feedback (ratings/comments) can be made publicly visible through these API endpoints as appropriate.

*   **Jam Subscriptions & Notifications:**
    *   Users can subscribe to specific game jams to receive updates (though actual notification delivery is outside the backend manager's scope).
    *   The backend manages the list of subscribers per jam.

These backend features provide a robust foundation for building a rich and interactive Game Jam platform.
