## Learning + Building (how to use this guide)

This document is both a learning plan and a development roadmap. The goal is to learn Flutter and related technologies while actively building features for FitTracker. You will alternate short learning exercises with small, ship‑ready code changes so your knowledge grows as the product evolves.

- Working mode: "learn-by-building" — make one small change, run the app, observe, and iterate. Prefer hands‑on tasks that directly add value to the app (new table, DAO, provider method, or UI tweak).
- Priorities: keep the app working, add features incrementally, and write small tests for pure logic when possible.

## Learning Flutter fundamentals (practical, repo‑focused)

These are the concrete topics you should learn first — each maps to things you will do inside this repo.

- Widgets & build(): Understand how widgets compose. In this repo, open `scheduled_workouts_view.dart` and follow the widget tree from top to bottom. Try to predict what each child widget renders before hot reloading the app.
- Layout: Learn Row, Column, Expanded, ListView, SizedBox and how padding/margin works. Practice by changing spacing in one small area of the app (for example, the list item layout) and observe the result.
- State: Learn the Provider pattern used here. Focus on ChangeNotifier lifecycle: set fields, call `notifyListeners()`, and consumers rebuild. Practice by adding a simple counter field to the `ScheduleWorkoutProvider` and displaying it in the view.
- Async: Understand Future vs Stream. Drift queries often return Stream<List<T>>; your provider subscribes and updates UI. Practice by logging stream emissions (we already did) and then updating state from those callbacks.
- Navigation: Find how screens are routed in `lib/main.dart` or route files. Practice pushing a new route from the gym screen to a detail screen and returning a value.
- Packages & codegen: When you edit DAOs/tables, run build_runner. Practice: add a harmless read-only DAO method (e.g., `watchAll()`), run the generator, and inspect the generated `.g.dart` file to see the mapping.

Practice pattern: change a small thing, hot reload, observe, revert if needed. Small iterative experiments build confidence.

## Expanding FitTracker: a future roadmap and how-to notes

Below is a prioritized list of real features you can add to the app, with short implementation tips and what to learn first. Treat each as a small project (1–3 days) with a clear acceptance criterion.

1. Calorie entry by barcode scanning (high value)

   - Why: quick data entry increases daily active use.
   - Tech: `mobile_scanner` (already present), Retrofit/Dio for API calls to nutrition DB, or local cache with Drift for history.
   - Steps: implement camera scanner screen → parse barcode → call API → cache result in Drift → present confirmation UI to store a food log entry.
   - Acceptance: scan a barcode, show product name + calories, and save to the day's log.

2. Workout plans & progress tracking (core)

   - Why: core product feature for users & trainers.
   - Data model: Workouts → Exercises → Sets. Keep relational tables in Drift and use DAO patterns you already have.
   - UI: builder for plans and run mode for tracking reps/weights with per-set timers and rest tracking.
   - Acceptance: create a plan with a workout, add exercises, and mark a completed set that persists to DB.

3. Trainer‑client relationships & sharing (social)

   - Why: differentiator for trainers and revenue potential.
   - Architecture: server-backed sharing (API + auth) or peer-export/import via files. Start with local export/import (JSON) before implementing server sync.
   - Acceptance: export a workout plan to JSON and import on another device preserving structure.

4. Sync & backup (reliability)

   - Why: users expect their data to survive device loss.
   - Options: Cloud sync (Firebase/REST) or scheduled backups to Google Drive. Implement conflict resolution: latest-wins or per-record versioning.
   - Acceptance: ability to upload/download a backup file and restore the DB schema safely.

5. Notifications & reminders (engagement)

   - Why: bring users back for workouts and meal logging.
   - Tech: `flutter_local_notifications` for scheduled local reminders; plan for push later (Firebase Cloud Messaging) for cross-device reminders.
   - Acceptance: schedule a daily reminder at a user-selected time and show a local notification.

6. Analytics & progress dashboards (retention)

   - Why: users want to see trends (weight, calories, workouts completed).
   - Implementation: compute aggregates in provider or DAOs (e.g., daily calorie totals) and show charts (use `fl_chart` or similar). Keep heavy aggregations off the main isolate if large.
   - Acceptance: show a 7‑day weight trend and a weekly calories bar chart.

7. Onboarding, privacy & compliance

   - Why: clear UX reduces churn and ensures compliance (GDPR, privacy policies) if you collect sensitive data.
   - Implementation: onboarding flow, clear permission dialogs (camera for barcode), and privacy policy link in settings.

8. CI/CD and release readiness
   - Why: automation saves time and prevents regression.
   - Tasks: add linting, run `flutter test` in CI, add codegen step (`build_runner`) to CI, and build artifacts for Android/iOS. Use GitHub Actions or GitLab CI with a Linux runner for builds.

Feature roadmap execution tips
—

- Break each feature into small tickets: (data model → DAO → provider → UI → tests). Implement in that order.
- Keep repository architecture conventions: core/data/domain/presentation. Add features in their own `feature/` subfolder to keep code modular.
- Add unit tests for pure logic (grouping, aggregation) and small widget tests for view code. Integration tests can be added later.

Recommended libraries & tools
—

- Network: `dio` + `retrofit` (API client generation)
- Barcode: `mobile_scanner` (already used) or `barcode_scan2`
- Charts: `fl_chart` or `syncfusion_flutter_charts` (commercial)
- Notifications: `flutter_local_notifications` + `firebase_messaging` (for push path)
- State: `provider` (already used) — keep it for consistency; consider Riverpod later if you need global refactors.

Project milestones (example 3‑month plan)
—

- Month 1: polish core UI, implement events grouping + calendar, upcoming list, and add simple unit tests.
- Month 2: implement barcode-based calorie logging and persistent food cache; add onboarding and settings screens.
- Month 3: implement backup/sync strategy (basic upload/download), notifications, and analytics dashboards.

## Next actionable items (pick one)

- If you want to keep learning Flutter fundamentals: pick Step 2 or 3 from the earlier list and I’ll walk you interactively for 30 minutes.
- If you want to expand the app: pick one feature above (e.g., barcode scanning) and I’ll create a concrete task list and the minimal files to add (data model + DAO) so you can implement it step-by-step.
- If you want a roadmap document: I can generate a minimal Project Plan (milestones, rough estimates, tests) as a `ROADMAP.md` in the repo.

Tell me which next action you want and the time you have (15/30/60 min) and I’ll start the guided session.

## Core feature details to add (barcode, gym tracking, trainer‑client)

Below are concrete design notes, data model suggestions, privacy considerations and implementation tips for the three core features you asked for. Add these to the roadmap items above as feature subtasks.

### Barcode → Nutrition flow (practical details)

- Data flow: scan barcode → lookup local cache (Drift) → if miss, call external food API → map response to FoodItem model → show user confirmation → save FoodEntry linked to a Meal/Day.
- Suggested tables:
  - FoodItem(id, barcode, name, nutrientsJson, lastSeenAt)
  - FoodEntry(id, userId, foodItemId, servingSize, calories, protein, carbs, fat, loggedAt)
- Caching: store API responses keyed by barcode; revalidate after a TTL (e.g., 7 days). Consider simple LRU eviction for growth control.
- UX: after scan show editable details (portion size slider, editable name) before saving.

### Gym progress tracking (workouts, sets, history)

- Minimal tables (Drift): Exercise, WorkoutPlan, Workout, WorkoutExercise, WorkoutRun, WorkoutSet.
- Key fields for WorkoutSet: id, runId, exerciseId, reps, weight, rpe, createdAt.
- UX flows:
  - Plan builder (create ordered workouts and exercises).
  - Runner (in-session screen): big buttons for "Add set", quick increment for reps/weight, auto-advance option.
  - History & progress: per-exercise timeline, personal records (PR), weekly/monthly volume.
- Helpful aggregations: personalBest(exerciseId), totalVolumePerWeek(userId), consistencyScore(userId).

### Trainer‑client relationships & communication

- Roles: client, trainer, admin. Store roles in the server model (if you add sync) and apply ACLs.
- Sync model (server): Users, Plans (shared), Assignments (trainer-client link), Messages, Events (workout runs, weight logs).
- Sharing flow (MVP): trainer creates plan → shares with client (invite/accept) → client receives plan and can run it locally. Use minimal server API + versioned records for sync.
- Messaging: store Message(conversationId, fromUserId, toUserId, text, sentAt, readAt). Use FCM for push notifications; implement optimistic UI locally.

### Notifications & reminders

- Local reminders: `flutter_local_notifications` for scheduled reminders (meal logging, workout times).
- Push: Firebase Cloud Messaging (FCM) for cross-device trainer messages and real-time alerts.

### Security & privacy

- Use secure storage for tokens (`flutter_secure_storage`).
- Only sync data the user consents to. Add a privacy/settings screen explaining what is shared with trainers and backups.
- If you store messages/server data, use HTTPS, auth, and consider encrypting sensitive fields.

### Testing & rollout tips

- Start local-only: implement barcode cache and runner + sets locally first. Add unit tests for mapping (API → FoodItem) and aggregation logic.
- Add integration tests for runner flows using `integration_test` when UI is stable.
- Rollout trainer sync behind a feature flag and test with a small user group; monitor sync conflict logs.

Add these items to the roadmap under appropriate months and break each into atomic PRs: schema → DAO → provider → UI → tests.
