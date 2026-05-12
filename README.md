# UIKit Character Browser

Small iOS practice project built with **Swift** and **UIKit** to consume the Jikan API and display manga/anime character data in a native table-based interface.

This repository is part of a pair of learning projects that implement similar functionality twice: once with **UIKit** and once with **SwiftUI**. The goal was to compare both native iOS approaches and strengthen the fundamentals of iOS development.

> Context: this was an open-ended training project created during my internship period at Worldline, after completing iOS learning paths. The idea, functionality, and code published here represent my own learning work and do not include proprietary company code, credentials, internal data, or confidential material.

## What it does

- Loads character data from the public **Jikan API**.
- Displays characters in a `UITableViewController`.
- Shows character name, role and image in a custom table cell.
- Opens a detail screen with additional character information.
- Includes manual refresh behaviour and loading state handling.

## Tech stack

| Area | Technology |
|---|---|
| Language | Swift |
| UI framework | UIKit |
| Architecture style | MVC-style learning project |
| Networking | `URLSession` |
| Data source | Jikan API |
| IDE | Xcode |

## Project structure

```text
uikit_app/
├── Models/
│   ├── Character.swift
│   └── CharacterStore.swift
├── ViewControllers/
│   └── CharacterUITableViewController.swift
├── AppDelegate.swift
└── SceneDelegate.swift
```

## What this project demonstrates

- Native iOS development with UIKit.
- Table-based UI using `UITableViewController` and custom cells.
- Basic navigation from list to detail screen.
- Consuming REST API data from Swift.
- Mapping API responses into app models.
- Handling remote images and asynchronous loading.

## Related project

The same idea was later implemented with SwiftUI in a separate repository:

- `AppSwiftUI` — SwiftUI version of this character browser.

## Status

Learning / portfolio project. It is not a production app, but it shows hands-on experience with native iOS fundamentals.

> Note: I currently do not have access to a Mac environment, so the README documents the project structure and intent, but recent local execution has not been verified.
