# KaaJu Task Manager 

**Flodo AI Take-Home Assignment**

## Track & Stretch Goal
- **Track**: Track B: The Mobile Specialist (Flutter + GetX + GetStorage)
- **Stretch Goal**: Debounced Autocomplete Search with Text Highlighting! ✨

## Key Features Implemented:
1. **Clean Architecture & State Management**: Complete `GetX` architecture moving logic out of UI and utilizing reactive state management (`Obx`, `Rx`).
2. **Task Data Model**: Implemented `Task` entity with `Title`, `Description`, `Due Date`, `Status`, and optional `Blocked By` functionality.
3. **Advanced UI Constraints (Blocked Logic)**: Blocked tasks appear visually greyed out (opacity 0.4) and disabled from clicks until the blocking task reaches `Done` status.
4. **Mocked Network Delays**: Enforced a `Future.delayed(Duration(seconds: 2))` on Create/Update requests. Provided smooth visual feedback with `CircularProgressIndicator` inside disabled Save buttons dynamically, maintaining stable UI frames.
5. **Drafts Logic**: Utilized `GetStorage` to persist input from the bottom-sheet form to disk while typing using `onChange`. Minimizing or closing unrecoverable screens will preserve text for next use automatically.
6. **Debounced Search with Highlighting**: Implemented a `Timer`-based 300ms Search Debouncer that filters dynamically, and utilized standard regex/Substrings mapping to apply `RichText` highlight layers internally over matched String queries inside the titles dynamically.

## Steps to Run Locally
1. Clone the repository and navigate to the project directory:
   ```bash
   cd kaaju
   ```
2. Fetch flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on standard physical devices or emulators (iOS / Android / MacOS):
   ```bash
   flutter run
   ```

## AI Usage Report
I utilized AI (Gemini) strictly to expedite boilerplate refactoring, primarily focusing on creating clean data structures and isolating UI controllers into the GetX syntax structure.
**Prompting highlights:** 
- "Refactor `Task` model to have due-date and enum state parsing for json storage mapping"
- "Help write the logic for the Debounced text query with highlight spans for title matching"

**Handling Halucinations:**
While running `flutter analyze`, the AI occasionally deprecated features. For example, using `value` inside form fields deprecated since Flutter v3.33. The fix involved catching this warning manually using `flutter analyze` and refactoring FormFields internally to `DropdownButton` bounded inside generic `InputDecorator` constraints to meet the new strict Flutter UI guidelines.
