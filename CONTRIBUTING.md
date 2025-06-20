# Willkommen in der Jamfam!

Wir freuen uns riesig, dass du hier bist und Interesse hast, zu Project Jambam beizutragen. Du bist jetzt Teil der **Jamfam**! Jede Hilfe, egal ob eine Zeile Code, eine brillante Idee für ein Feature oder ein sorgfältig dokumentierter Bug-Report, ist für den Erfolg des Projekts unglaublich wertvoll.

## Wie du beitragen kannst

Es gibt viele Wege, ein wertvolles Mitglied unserer Community zu werden. Hier sind einige davon:

*   **Fehler melden:** Wenn du einen Bug findest, erstelle bitte einen [neuen Issue](https://github.com/BjarneNiklas/project-jambam/issues) und beschreibe das Problem so detailliert wie möglich.
*   **Neue Features vorschlagen:** Hast du eine Idee, die Project Jambam noch besser machen würde? Erstelle einen [Issue](https://github.com/BjarneNiklas/project-jambam/issues) und beschreibe dein Konzept.
*   **Dokumentation verbessern:** Wenn du einen Tippfehler findest oder denkst, ein Teil der Dokumentation könnte klarer sein, zögere nicht, einen Pull Request zu erstellen.
*   **Code beitragen:** Wenn du bei der Entwicklung helfen möchtest, schau dir die offenen [Issues](https://github.com/BjarneNiklas/project-jambam/issues) an und suche dir eine Aufgabe aus!

## Dein erstes Setup

Bereit, den Code in die Hände zu bekommen? Hier ist eine Schritt-für-Schritt-Anleitung, um deine Entwicklungsumgebung einzurichten:

1.  **Fork des Repositories:** Erstelle einen Fork dieses Repositories in deinem eigenen GitHub-Account.
2.  **Klonen deines Forks:** Klone deinen Fork auf deinen lokalen Rechner:
    ```bash
    git clone https://github.com/DEIN-USERNAME/project-jambam.git
    cd project-jambam
    ```
3.  **Flutter-Version sicherstellen:** Stelle sicher, dass du die korrekte und eine aktuelle Version von Flutter installiert hast. Folge der [offiziellen Flutter-Installationsanleitung](https://flutter.dev/docs/get-started/install), um alles einzurichten.
4.  **Abhängigkeiten installieren:** Lade alle notwendigen Pakete herunter:
    ```bash
    flutter pub get
    ```
5.  **Alles überprüfen:** Führe die folgenden Befehle aus, um sicherzustellen, dass dein Setup sauber ist und alle Tests bestehen:
    ```bash
    flutter analyze
    flutter test
    ```
Wenn alle Befehle ohne Fehler durchlaufen, bist du startklar!

## Der Entwicklungs-Workflow

Wir folgen dem standardmäßigen GitHub-Flow, um die Codequalität hoch und den Prozess transparent zu halten.

1.  **Wähle ein Issue:** Erstelle immer zuerst ein Issue, das dein Vorhaben beschreibt, oder wähle ein existierendes aus, das du bearbeiten möchtest. Kommentiere im Issue, dass du daran arbeitest.
2.  **Erstelle einen Branch:** Erstelle einen neuen Branch von `main` mit einem aussagekräftigen Namen, der dem Conventional-Commits-Standard folgt:
    *   Für neue Features: `feat/add-voting-system`
    *   Für Bugfixes: `fix/login-button-bug`
    *   Für Dokumentation: `docs/update-readme`
3.  **Implementiere deine Änderungen:** Schreibe deinen Code! Halte dich dabei an unsere Coding-Styles.
4.  **Erstelle einen Pull Request (PR):** Wenn du fertig bist, pushe deinen Branch zu deinem Fork und erstelle einen Pull Request (PR) auf den `main`-Branch des Haupt-Repositories (`BjarneNiklas/project-jambam`).
5.  **Verknüpfe den Issue:** Referenziere im PR-Titel oder der Beschreibung das zugehörige Issue, damit es automatisch geschlossen wird, wenn der PR gemerged wird (z.B. "Closes #42").

## Coding-Style & Konventionen

### Stil

Wir folgen dem offiziellen **[Effective Dart](https://dart.dev/guides/language/effective-dart)** Style Guide. Bitte stelle sicher, dass dein Code diesen Richtlinien entspricht. `flutter analyze` hilft dir dabei, die meisten Probleme zu finden.

### Commit-Messages

Wir verwenden die **[Conventional Commits](https://www.conventionalcommits.org/)** Spezifikation. Das hilft uns, den Verlauf lesbar zu halten und Änderungen automatisch zu versionieren. Jeder Commit sollte diesem Schema folgen:

`<type>: <description>`

**Beispiele:**
*   `feat: Add user login via email`
*   `fix: Correct color of primary button`
*   `docs: Update CONTRIBUTING guide`
*   `refactor: Simplify user authentication service`

## Verhaltenskodex (Code of Conduct)

Die Jamfam ist ein Ort des Respekts und der Zusammenarbeit. Wir erwarten von allen Beitragenden, dass sie sich an unseren Verhaltenskodex halten, der auf dem **Contributor Covenant** basiert. Sei freundlich, sei konstruktiv, sei großartig zu anderen.

Eine vollständige `CODE_OF_CONDUCT.md`-Datei wird in Kürze hinzugefügt. 