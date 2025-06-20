# PowerShell Script to Create the Initial GitHub Backlog for Project Jambam
#
# INSTRUCTIONS:
# 1. Make sure you have the GitHub CLI installed: https://cli.github.com/
# 2. Authenticate with your GitHub account by running: gh auth login
# 3. Set your GitHub username and repository name in the variables below.
# 4. Run this script from your PowerShell terminal: .\create_backlog.ps1
#

$githubUser = "BjarneNiklas" # <--- IMPORTANT: SET YOUR GITHUB USERNAME HERE
$repoName = "project-jambam"
$repo = "$githubUser/$repoName"

Write-Host "Setting up repository: $repo"

# ----------------------------------------------------
# 1. DEFINING LABELS
# ----------------------------------------------------
Write-Host "Creating labels..."
gh label create "Epic" --color "7e57c2" --description "A collection of features and tasks for a major product area." --repository $repo --force
gh label create "Feature" --color "42a5f5" --description "A self-contained, user-facing feature." --repository $repo --force
gh label create "Task" --color "bdbdbd" --description "A specific, non-user-facing development task." --repository $repo --force
gh label create "Bug" --color "ef5350" --description "A problem or an error." --repository $repo --force
gh label create "Documentation" --color "66bb6a" --description "A documentation-related task." --repository $repo --force
gh label create "Architecture" --color "ffa726" --description "A task related to software architecture or infrastructure." --repository $repo --force
gh label create "AI-Model" --color "26c6da" --description "A task related to the AI model." --repository $repo --force
gh label create "UI/UX" --color "ff7043" --description "A task related to UI/UX design or implementation." --repository $repo --force
Write-Host "Labels created."

# ----------------------------------------------------
# 2. CREATING EPIC ISSUES
# ----------------------------------------------------
Write-Host "Creating Epic issues..."
gh issue create --title "[EPIC] Säule 1: Der KI-Innovationsassistent" --body "Dieses Epic umfasst alle Features, die zur Kernfunktionalität der KI-gestützten Ideen- und Konzeptgenerierung gehören. Ziel ist es, Nutzern einen nahtlosen Weg von einer vagen Idee zu einem strukturierten 'Jam Kit' zu ermöglichen." --label "Epic" --repository $repo
gh issue create --title "[EPIC] Säule 2: Die Community- & Gamification-Plattform" --body "Dieses Epic bündelt alle Aufgaben rund um die Schaffung eines lebendigen, community-getriebenen Ökosystems. Im Mittelpunkt stehen Interaktion, Belohnung für qualitative Beiträge und kollaborative Entscheidungsfindung." --label "Epic" --repository $repo
gh issue create --title "[EPIC] Säule 3: Plattform-Architektur & User Experience" --body "Dieses Epic befasst sich mit den technischen und gestalterischen Grundlagen der Anwendung. Ziel ist eine robuste, skalierbare und plattformübergreifende Architektur sowie eine intuitive und ansprechende User Experience." --label "Epic" --repository $repo
gh issue create --title "[EPIC] Säule 4: Langfristige Vision (3D-Hub & Multi-Engine)" --body "Dieses Epic sammelt Aufgaben, die auf die langfristige Vision des Projekts hinarbeiten. Dazu gehören die Integration von 3D-Visualisierungen, die Nutzung von OpenUSD und die Vorbereitung für eine Multi-Engine-Unterstützung." --label "Epic" --repository $repo
Write-Host "Epics created."

# ----------------------------------------------------
# 3. CREATING FEATURE & TASK ISSUES
# ----------------------------------------------------
Write-Host "Creating Feature and Task issues..."

# For Epic 1 (AI)
gh issue create --title "Themen-Generator auf Basis von Keywords" --body "Als Nutzer möchte ich ein oder mehrere Keywords eingeben können, um eine Liste von passenden Game-Jam-Themen generiert zu bekommen, damit ich schnell Inspiration finde." --label "Feature,AI-Model" --repository $repo
gh issue create --title "Quest-System für Jam-Themen" --body "Als Entwickler möchte ich zu einem generierten Thema eine Liste von optionalen 'Quests' (Design-Herausforderungen) erhalten, um meinem Projekt mehr Struktur und eine kreative Richtung zu geben." --label "Feature,AI-Model" --repository $repo

# For Epic 2 (Community)
gh issue create --title "Konzept für Punktesystem" --body "Als Projektmanager müssen wir ein detailliertes Konzept für das Punktesystem entwerfen. Wofür erhalten Nutzer Punkte (Themen einreichen, Voten, Assets bewerten etc.)?" --label "Task,Documentation" --repository $repo
gh issue create --title "Community-Voting für Themen" --body "Als Mitglied der Community möchte ich über eingereichte Themenvorschläge abstimmen können, damit die beliebtesten Ideen für offizielle Jams ausgewählt werden." --label "Feature,UI/UX" --repository $repo

# For Epic 3 (Architecture)
gh issue create --title "Setup des Flutter-Projekts für Mobile, Web & Desktop" --body "Als Entwickler muss ich sicherstellen, dass das initialisierte Flutter-Projekt korrekt für alle drei Zielplattformen (iOS/Android, Web, Desktop) konfiguriert ist und ein 'Hello World' auf jeder Plattform lauffähig ist." --label "Task,Architecture" --repository $repo
gh issue create --title "Entwurf eines UI/UX-Styleguides" --body "Als Designer muss ich einen grundlegenden Styleguide (Farben, Typografie, Komponentenstil) entwerfen, um eine konsistente und moderne User Experience sicherzustellen." --label "Task,UI/UX,Documentation" --repository $repo

# For Epic 4 (Vision)
gh issue create --title "Recherche: Flutter-Bibliotheken für 3D-Rendering (OpenUSD)" --body "Als Entwickler muss ich existierende Flutter-Bibliotheken für das Rendern von 3D-Modellen evaluieren, mit einem besonderen Fokus auf die Unterstützung des OpenUSD-Formats." --label "Task,Architecture" --repository $repo

# ----------------------------------------------------
# 4. DETAILING FEATURES WITH TASKS
# ----------------------------------------------------
Write-Host "Creating detailed technical Task issues..."

# Tasks for Feature: "Themen-Generator auf Basis von Keywords"
gh issue create --title "[TASK] UI für Keyword-Eingabe erstellen" --body "Erstellung eines `TextField`-Widgets, um User-Input für die Keywords zu ermöglichen. (Teil von [FEAT] Themen-Generator)" --label "Task,UI/UX" --repository $repo
gh issue create --title "[TASK] Lade- & Fehler-Zustände visualisieren" --body "Implementierung von `CircularProgressIndicator` während der Generierung und einer `SnackBar` zur Anzeige von Fehlern. (Teil von [FEAT] Themen-Generator)" --label "Task,UI/UX" --repository $repo
gh issue create --title "[TASK] `ConceptGenerationService` Abstraktion definieren" --body "Erstellung einer abstrakten Klasse, um die KI-Generierungslogik zu entkoppeln und zukünftige Erweiterungen (z.B. RAG) zu ermöglichen. (Teil von [FEAT] Themen-Generator)" --label "Task,Architecture" --repository $repo
gh issue create --title "[TASK] Sichere API-Key-Verwaltung einrichten" --body "Integration von `flutter_dotenv` zur sicheren Verwaltung des Gemini API-Keys, inklusive `.gitignore`-Eintrag. (Teil von [FEAT] Themen-Generator)" --label "Task,Architecture" --repository $repo
gh issue create --title "[TASK] `LlmConceptGenerationService` implementieren" --body "Implementierung der Service-Klasse, die einen Prompt für die Gemini API erstellt, die API aufruft und die JSON-Antwort parst. (Teil von [FEAT] Themen-Generator)" --label "Task,AI-Model" --repository $repo
gh issue create --title "[TASK] `ApiJamKitRepository` erstellen" --body "Erstellung des 'echten' Repositories, das den `ConceptGenerationService` zur Datenabfrage nutzt. (Teil von [FEAT] Themen-Generator)" --label "Task,Architecture" --repository $repo

# Tasks for Feature: "Quest-System für Jam-Themen"
gh issue create --title "[TASK] UI zur Anzeige der generierten Ergebnisse" --body "Erstellung des `JamKitResultsScreen` zur strukturierten Anzeige von Titel, Theme, Quests und Asset-Vorschlägen. (Teil von [FEAT] Quest-System)" --label "Task,UI/UX" --repository $repo

# Tasks for Feature: "Community-Voting für Themen"
gh issue create --title "[TASK] UI für Login/Registrierung erstellen" --body "Erstellung des `LoginScreen` mit Feldern für E-Mail/Passwort und Buttons für die Aktionen. (Teil von [FEAT] Community-Voting)" --label "Task,UI/UX" --repository $repo
gh issue create --title "[TASK] `AuthRepository` und Mock implementieren" --body "Definition der Abstraktion für die Authentifizierung und Erstellung einer Mock-Implementierung für die lokale Entwicklung. (Teil von [FEAT] Community-Voting)" --label "Task,Architecture" --repository $repo
gh issue create --title "[TASK] `AuthWrapper` für Login-Status implementieren" --body "Erstellung eines Widgets, das basierend auf dem Login-Status des Nutzers entweder die App oder den Login-Screen anzeigt. (Teil von [FEAT] Community-Voting)" --label "Task,Architecture" --repository $repo
gh issue create --title "[TASK] UI für Themen-Voting-Liste erstellen" --body "Erstellung des `CommunityThemeScreen`, um eine Liste von Themen mit Titel, Beschreibung und Stimmenanzahl anzuzeigen. (Teil von [FEAT] Community-Voting)" --label "Task,UI/UX" --repository $repo
gh issue create --title "[TASK] `CommunityThemeRepository` und Mock implementieren" --body "Definition der Abstraktion für das Abrufen und Voten von Themen und Erstellung einer Mock-Implementierung. (Te.il von [FEAT] Community-Voting)" --label "Task,Architecture" --repository $repo
gh issue create --title "[TASK] Dialog zur Einreichung neuer Themen erstellen" --body "Implementierung eines `AlertDialog`s mit einem Formular, damit Nutzer neue Themenvorschläge einreichen können. (Teil von [FEAT] Community-Voting)" --label "Task,UI/UX" --repository $repo

Write-Host "Backlog creation complete!"
Write-Host "Please visit https://github.com/$repo/issues to see your new backlog." 