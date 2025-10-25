# FitTracker — Flutter fundamentals (fast path)

Short, practical fundamentals tailored to this repo. Each module has a tiny exercise you can do in the FitTracker codebase (no prior deep knowledge required). Target: 1–2 hours total for the core modules; keep it hands-on.

Quick start (run these once in repo root)

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

Why this path

- You mentioned you "don't really have Flutter fundamentals". These modules explain the essential Flutter/Dart concepts you'll need to read and safely change FitTracker: widgets, layout, state, async, packages, and a couple of Drift notes.

Module A — Dart quick primer (15–30m)
Goal: understand the language basics you need to read the code.

What to learn:

- Types, null-safety, final vs var, functions, classes, async/await, Future and Stream basics.

Tiny exercise (5–10m):

- Open `lib/main.dart` and find a usage of `Future` or `async` (e.g., DB open or DI init). Read the function and add a short comment that explains what the Future-returning function does.

Acceptance: you can explain in one sentence what `async`/`await` does.

Module B — Widgets and the Widget tree (20–40m)
Goal: learn StatefulWidget vs StatelessWidget and how build() composes UI.

What to learn:

- StatelessWidget: immutable config, simple render.
- StatefulWidget: local state + lifecycle (initState, dispose, setState).
- The build method: returns a tree of widgets; small changes re-run build.

Tiny exercise (10–15m):

- Open `lib/feature/gym_tracking/presentation/view/scheduled_workouts_view.dart`.
- Add a single `Text` widget near the top of the view that says "Hello from fundamentals" to confirm you can reload the app and see the change.

How to run: `flutter run` and make sure the emulator/device shows the change.

Module C — Layout basics: Row, Column, Expanded, Padding (20–40m)
Goal: place widgets on screen and understand constraints.

What to learn:

- Row/Column rules, mainAxis/crossAxis alignment, Expanded/Flexible, SizedBox and Padding.

Tiny exercise (10–15m):

- In the same view, wrap your `Text` in a `Padding` and center it with `Center` or `Column` so you see how layout affects position.

Module D — State management (Provider) — 30–60m
Goal: Understand how Provider is used in this repo and how ChangeNotifier notifies UI.

What to learn:

- `ChangeNotifier` and `ChangeNotifierProvider` (or `Provider`), `Consumer` and `context.watch<T>()`.
- Why providers are placed above a screen (life cycle) and not inside `build()`.

Hands-on exercise (15–25m):

- Open `lib/feature/gym_tracking/presentation/providers/scheduled_workout_provider.dart` and `scheduled_workouts_view.dart`.
- Find where the provider is created in the screen tree (look for `ChangeNotifierProvider` or service locator wiring). Confirm `provider.loadForDate(selectedDate)` is called to start the DAO subscription.

Smoke test (apply this if you want me to make the change):

- Add a visible scheduled-count: `Text('Scheduled: ${provider.scheduled.length}')` in `scheduled_workouts_view.dart` next to the date header.
- Run the app. When you add a scheduled item, the count should update automatically.

Module E — Async patterns: Future, Stream & DAO streams (20–40m)
Goal: Understand async return types and listen to streams from DB.

What to learn:

- When to use Future vs Stream: use Stream for ongoing updates; DAO `watchX()` returns a Stream.
- How to subscribe in a provider: `StreamSubscription` + cancel in `dispose()`.

Tiny exercise (10m):

- Inspect `watchForDate` in the DAO and `ScheduleWorkoutProvider._subscribeToDate` to see how the stream is listened to and how `notifyListeners()` is called.

Module F — Packages & codegen you must know (15–30m)
Goal: know the commands and what they do.

What to learn:

- `build_runner` — code generation for Drift/models.
- `flutter pub get` — dependency install.
- `flutter test` — run tests.

Commands quick list

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
flutter test
```

Module G — Drift highlights (30–60m)
Goal: understand the repository's DB approach and safe migration patterns.

What to learn:

- Tables and DAOs are defined in `lib/core/app_database.dart`.
- Avoid SQL-side dynamic defaults; use `clientDefault(() => DateTime.now())`.
- Use `MigrationStrategy.onUpgrade` with `m.createTable(table)` for safe additions.

Tiny exercise (15–30m):

- Open `lib/core/app_database.dart` and find the `ScheduledWorkout` table and DAO. Note the `schemaVersion`. If you changed the DB recently, run `build_runner` to ensure generated classes are up-to-date.

Module H — Testing basics (30–60m)
Goal: run small tests and learn how DB tests can differ across environments.

What to learn:

- Unit tests vs widget tests vs integration tests.
- DB tests: prefer a deterministic approach — either native in-memory DB on CI images that include libsqlite3 or a correctly-configured FFI adapter.

Tiny exercise (15–30m):

- Run `flutter test test/scheduled_migration_test.dart` (if present). If it fails due to missing native sqlite dynamic library, you can skip and we'll adjust to use `sqflite_common_ffi` or run in a different environment.

Path forward (30m)

- After these modules you will:
  - Be able to read and safely edit UI code in FitTracker.
  - Add small features (like scheduled-count) and run the app locally.
  - Understand how to change DB schemas safely.

Ask me to do one of the following (I'll do it for you):

- A: Apply the scheduled-count smoke test change to `scheduled_workouts_view.dart` and run a quick verification.
- B: Walk you step-by-step through Module D (Provider) with inline code comments in the repo.
- C: Scaffold a minimal `eventsMap` grouping helper in the provider and show usage in the view.

Pick A, B or C (or ask for something else) and I'll do it next.
