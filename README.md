# 🚀 KaaJu: Task Management  (Assignment)

A functional, visually polished Task Management application built with Flutter. This project showcases high-agency problem solving, clean architecture, and modern development workflows using AI-assisted engineering.

---

## 🛠 Tech Stack & Tools
- **Framework**: Flutter (Material 3)
- **State Management**: GetX (Reactive Programming)
- **Local Persistence**: GetStorage
- **IDE**: **Antigravity IDE** (Leveraged for high-performance indexing and rapid prototyping)
- **AI Collaborator**: **Gemini 3 Flash** (Used for architectural brainstorming and logic optimization)

---

## 🛠 Track & Stretch Goal
- **Track**: **Track B: The Mobile Specialist**
- **Stretch Goal**: **Debounced Autocomplete Search with Text Highlighting** ✨

## 🎁 High-Agency Bonus Features
- 🌓 **Global Dark Mode**: A seamless, system-wide dark theme implementation.
- 📌 **Task Pinning**: Added functionality to pin priority tasks to the top of the list.
- 👤 **Profile Context**: Dedicated screen for persistent user identity and theme preferences.
- 🎬 **Micro-interactions**: Subtle animations using `flutter_animate` for a premium feel.

---

## ✨ Key Features & Technical Decisions

| Feature | Technical Implementation |
| :--- | :--- |
| **Reactive State** | Utilized `Obx` and `Rx` variables to ensure the UI reacts instantly to data changes without manual rebuilds. |
| **Blocked Logic** | Implemented a dependency-check algorithm; Blocked tasks are visually greyed out (0.4 opacity) and wrapped in an `AbsorbPointer` to prevent premature interaction. |
| **Simulated Latency** | Enforced a 2-second `Future.delayed` on CRUD operations. Managed via `isLoading` state to disable buttons and provide visual feedback (loaders). |
| **Persistence Layer** | Used `GetStorage` for real-time **Draft Management**. Unsaved form data is persisted to disk on-the-fly, ensuring a crash-proof user experience. |
| **Search Engine** | Built a custom **Debouncer (300ms)** to prevent redundant filtering. Matched strings are rendered using `TextSpan` for real-time highlighting. |

---

## 🏗 Project Architecture (Layered Clean)
I followed a strict separation of concerns to ensure the code is testable and maintainable:
- `models/`: Immutable entities with JSON serialization.
- `controllers/`: Core business logic, storage gateways, and UI-state orchestration.
- `screens/`: Highly modular UI layouts.
- `widgets/`: Reusable, atomic UI components.

---

## 🤖 AI Usage & Learning Report
Developed in an **AI-First workflow** using **Antigravity IDE** and **Gemini**, focusing on rapid iteration and high-quality refactoring.

**Key Prompting Strategies:**
1. *"Architect a robust GetX controller that handles asynchronous persistence with GetStorage and prevents race conditions during a 2-second mocked delay."*
2. *"Generate an optimized logic to find matching substrings within task titles and return a List<TextSpan> for background highlighting."*

**Handling AI Hallucinations:**
While the AI initially suggested legacy `DropdownButton` properties, I identified layout overflow issues during testing. I corrected this by refactoring the UI to use `InputDecorator` with custom constraints, meeting modern Material 3 specifications—a fix that highlights my ability to manually verify and refine AI-generated code.

---

## 🚀 Setup & Execution
1. **Clone**: `git clone https://github.com/devbysaadan/flodo-task-manager`
2. **Dependencies**: `flutter pub get`
3. **Launch**: `flutter run`

---

## 📽 Demo Video
[**Watch the 90-second Technical Walkthrough**](https://drive.google.com/file/d/12luMhdTgZprhPQkcCNve17FAq4OCETkX/view?usp=sharing)  
*(Please ensure Nilay@flodo.ai has view access)*