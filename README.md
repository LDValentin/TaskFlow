# TaskFlow – Intelligent Task Prioritization App

TaskFlow is an offline-first task manager built with **Flutter** that helps users decide **what to work on next** when they feel overwhelmed by many tasks.

Instead of a simple to-do list, the app uses a **local recommendation engine** to evaluate tasks based on urgency, priority, available time, and user energy to suggest the most appropriate task to start.

All computation is done **locally and offline**, without external APIs.

---

## Features

- Create, edit, and delete tasks
- Categorize tasks (Study, Cleaning, Errands)
- Track deadlines and estimated duration
- Mark tasks as completed
- Persistent storage using **SQLite**
- Local **Task Recommendation Engine**
- Session-based task suggestion based on:
  - available time
  - energy level
- Automatic task ranking using a weighted scoring algorithm

---

## How the Recommendation Engine Works

When the user presses **Start Session**, the app asks:

- available time (minutes)
- current energy level (1–5)

The app evaluates all active tasks using a scoring function:
score =
0.30 * urgency

0.20 * priority

0.25 * timeFit

0.15 * energyFit

0.10 * age

### Scoring Components

| Component | Description |
|----------|-------------|
| Urgency | How close the deadline is |
| Priority | User-assigned priority (1–5) |
| Time Fit | How well the task fits in the available time |
| Energy Fit | Compatibility between task difficulty and user energy |
| Age | Older tasks receive a slight boost |

Tasks are ranked and the app recommends the **best task to start now**, along with alternatives.

---

## Tech Stack

- **Flutter**
- **Dart**
- **SQLite (sqflite)**
- Local algorithmic recommendation engine

---

## Project Structure
lib/
│
├── models/
│ └── task.dart
│
├── services/
│ ├── recommendation_engine.dart
│ └── task_database.dart
│
├── screens/
│ ├── home_page.dart
│ ├── add_task_page.dart
│ └── task_detail_page.dart
│
└── main.dart


---

## Database Schema

SQLite table used for persistence:
tasks

Columns:

- id
- title
- category
- createdAt
- deadline
- estimatedMinutes
- difficulty
- priority
- isCompleted
- subject
- chapters
- cleaningDetails
- errandDetails

---

## Running the Project

### Requirements

- Flutter SDK
- Android Studio or Android device/emulator

### Install dependencies
flutter pub get

### Run the app
flutter run


---

## Future Improvements

Planned features include:

- Subtasks and automatic task decomposition
- Focus level input in recommendation engine
- Preference mode (light vs heavy tasks)
- Better recommendation explanations
- Task statistics
- Improved UI/UX

---

## Motivation

Many productivity apps focus on storing tasks, but they do not help answer the real question:

> **What should I work on right now?**

TaskFlow attempts to solve that problem by combining task management with algorithmic prioritization.

---
## Contributing

Contributions are welcome!

If you would like to improve the project, please:

1. Fork the repository
2. Create a new branch
3. Submit a pull request

You can also open issues for bugs or feature suggestions.

## License

MIT License

Copyright (c) 2026 Luis Valentin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.