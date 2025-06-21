---
title: Markdown Best Practices für Blog-Artikel
author: AURAX Documentation Team
date: 2024-03-15
tags: [markdown, blogging, documentation, contribution, best practices]
type: blog
summary: Lerne die besten Praktiken für das Schreiben von Blog-Artikeln in Markdown, um klare, konsistente und ansprechende Inhalte zu erstellen.
---
# Markdown Best Practices für Blog-Artikel auf AURAX

Markdown ist eine leichtgewichtige Auszeichnungssprache, die ideal für das Schreiben von Blog-Artikeln und Dokumentationen ist. Um sicherzustellen, dass unsere Inhalte klar, konsistent und gut lesbar sind, bitten wir alle Beitragenden, die folgenden Best Practices zu beachten.

## Zentrale Punkte
- Verwende semantische Überschriften (`#`, `##`, `###`) zur Strukturierung.
- Nutze Listen für Aufzählungen und nummerierte Schritte.
- Integriere Links und Bilder korrekt und mit informativem Text.
- Stelle Code-Blöcke mit Sprachangabe für Syntax-Highlighting dar.
- Achte auf vollständiges und korrektes Frontmatter für Metadaten.

## 1. Frontmatter: Die Visitenkarte deines Artikels
Das Frontmatter am Anfang jeder Markdown-Datei liefert wichtige Metadaten. Stelle sicher, dass es immer vollständig und korrekt ist:
- `title`: Der aussagekräftige Titel des Artikels.
- `author`: Der Autor oder das verantwortliche Team.
- `date`: Das Veröffentlichungsdatum im Format `JJJJ-MM-TT`.
- `tags`: Eine Liste von relevanten Schlagwörtern (Keywords).
- `type`: Der Typ des Inhalts, z.B. `blog`, `devlog`.
- `summary`: Eine kurze Zusammenfassung (max. 160 Zeichen) für Übersichten und Teaser.

```yaml
---
title: Mein Grossartiger Blog-Artikel
author: Max Mustermann
date: 2023-11-15
tags: [beispiel, markdown, tutorial]
type: blog
summary: Eine kurze und knackige Zusammenfassung des Artikelinhalts.
---
```

## 2. Überschriften zur Strukturierung
Verwende Überschriften, um deinen Inhalt logisch zu gliedern. Beginne mit `#` für den Haupttitel (obwohl dieser meist aus dem Frontmatter-Titel generiert wird) und `##` für Hauptabschnitte. Unterabschnitte folgen mit `###` und so weiter.
- Beginne immer mit `#` (oder `##` wenn der Titel aus dem Frontmatter kommt) und erhöhe die Ebenen schrittweise.
- Vermeide das Auslassen von Überschriftebenen (z.B. von `##` direkt zu `####`).

## 3. Absätze und Zeilenumbrüche
- Trenne Absätze durch eine einzelne Leerzeile.
- Für einen harten Zeilenumbruch innerhalb eines Absatzes (selten nötig), verwende zwei Leerzeichen am Ende der Zeile.

## 4. Listen
### Ungeordnete Listen (Bullet Points)
Verwende Sternchen (`*`), Pluszeichen (`+`) oder Bindestriche (`-`) für Aufzählungen.
```markdown
* Erstes Element
* Zweites Element
  * Eingerücktes Element
```

### Geordnete Listen (Nummeriert)
Verwende Zahlen gefolgt von einem Punkt.
```markdown
1. Erster Schritt
2. Zweiter Schritt
3. Dritter Schritt
```

## 5. Hervorhebungen
- `*kursiv*` oder `_kursiv_` für kursiven Text.
- `**fett**` oder `__fett__` für fetten Text.
- `~~durchgestrichen~~` für durchgestrichenen Text.

## 6. Links
Verlinke relevanten Inhalt mit klarem Linktext.
```markdown
[Besuche unsere AURAX Community Seite](./blog_auraventionen.md)
[Externe Webseite](https://beispiel.com)
```
Denke daran, für interne Links innerhalb der `docs/` Ordnerstruktur relative Pfade zu verwenden.

## 7. Bilder
Bilder werden ähnlich wie Links eingebunden, aber mit einem vorangestellten Ausrufezeichen.
```markdown
![Alternativtext für das Bild](../assets/images/logo.png "Optionaler Titel des Bildes")
```
Achte darauf, dass der Alternativtext (alt text) beschreibend ist.

## 8. Code-Blöcke
### Inline Code
Umschließe kurzen Code oder Befehle mit Backticks: `` `const variable = "wert";` ``.

### Fenced Code Blocks
Für längere Code-Beispiele verwende drei Backticks und gib die Sprache für Syntax-Highlighting an:
````markdown
```javascript
function greet(name) {
  console.log(`Hello, ${name}!`);
}
```
````

## 9. Zitate
Verwende `>` für Blockzitate:
```markdown
> Dies ist ein inspirierendes Zitat.
> Es kann sich über mehrere Zeilen erstrecken.
```

## Fazit
Durch die Beachtung dieser Markdown Best Practices trägst du dazu bei, dass unsere AURAX Blog-Artikel und Dokumentationen einheitlich, professionell und leicht zugänglich sind. Vielen Dank für deine Mitarbeit!
