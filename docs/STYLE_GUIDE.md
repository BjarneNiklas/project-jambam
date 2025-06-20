# Project Jambam - Style Guide & UI/UX Principles

## 1. Core Philosophy: "Creative Clarity"

Our UI should be clean, intuitive, and inspiring. It needs to provide a clear path for the user's creative process without getting in the way. The design should feel modern, encouraging, and slightly playful, reflecting the "Jamfam" spirit.

- **Clarity over Clutter:** Every element on the screen must have a purpose.
- **Consistency is Key:** Components should look and behave predictably across the app.
- **Responsive & Accessible:** The UI must be usable and beautiful on all target platforms (mobile, web, desktop) and accessible to everyone.

---

## 2. Color Palette

The palette is designed to be energetic and creative, yet easy on the eyes for long sessions.

| Role              | Color         | Hex Code    | Usage                                                               |
| ----------------- | ------------- | ----------- | ------------------------------------------------------------------- |
| **Primary**       | Deep Purple   | `#673AB7`   | Main actions, app bars, interactive elements, highlights.           |
| **Primary Light** | Light Purple  | `#D1C4E9`   | Backgrounds for highlighted sections, hover states.                 |
| **Secondary**     | Amber         | `#FFC107`   | Call-to-actions (CTAs), special highlights, gamification elements. |
| **Accent**        | Teal          | `#009688`   | Secondary actions, links, icons, supportive information.            |
| **Background**    | Off-White     | `#F7F7F9`   | Main application background.                                        |
| **Surface**       | White         | `#FFFFFF`   | Cards, modals, input fields.                                        |
| **Text Primary**  | Dark Grey     | `#212121`   | Headings and primary body text.                                     |
| **Text Secondary**| Medium Grey   | `#757575`   | Subtitles, helper text, disabled states.                            |
| **Error**         | Red           | `#D32F2F`   | Error messages, destructive action confirmation.                    |

---

## 3. Typography

We will use the `Google Fonts` package to ensure consistent typography. The chosen font is **"Roboto"** for its excellent readability on screens.

- **Display Large:** `48sp`, Bold (`w700`) - For major screen titles or key numbers.
- **Headline Medium:** `24sp`, Bold (`w700`) - For page titles and major section headers.
- **Title Large:** `20sp`, Medium (`w500`) - For card titles and subtitles.
- **Body Large:** `16sp`, Regular (`w400`) - For all primary body copy.
- **Body Medium:** `14sp`, Regular (`w400`) - For secondary text, captions, and list items.
- **Label Small:** `12sp`, Regular (`w400`) - For button text and small labels.

---

## 4. Component Principles

- **Buttons:**
  - **Primary (Elevated):** Use the `Primary` color. Reserved for the main action on a screen.
  - **Secondary (Outlined):** Use the `Accent` color. For secondary, non-critical actions.
  - **Text Buttons:** For tertiary actions, like "Cancel" in a dialog.
- **Cards:**
  - Use `Surface` color for the background with a subtle shadow.
  - A `borderRadius` of 8-12px should be used consistently.
- **Input Fields:**
  - Use standard `TextField` widgets with the `Outlined` decoration.
  - The border color should be `Text Secondary` by default and `Primary` when focused.

---

## 5. Iconography

We will use the standard **Material Design Icons** provided by the Flutter SDK (`Icons` class) to ensure visual consistency and a native feel.

This document will be the single source of truth for the visual design of Project Jambam. 