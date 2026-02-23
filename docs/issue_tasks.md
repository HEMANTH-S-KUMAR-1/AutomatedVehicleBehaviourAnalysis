# Proposed Issue-Fix Tasks

## 1) Typo fix task
**Task:** Standardize spelling in project naming by changing `Behaviour` to `Behavior` where it is intended to match the rest of repository terminology.

**Why:** The repo and documentation currently mix British and American spelling (e.g., title uses “Behaviour” while most docs and code artifacts use “behavior”), which can cause confusion and inconsistent naming in future files.

**Acceptance criteria:**
- Project title and references are consistent across README/docs/script outputs.
- File names and user-facing labels use one chosen convention.

---

## 2) Bug fix task
**Task:** Remove hard-coded local Windows path usage in `scripts/vehicle_behavior_analysis.m` and derive paths relative to the script/repo.

**Why:** The script currently sets `projectRoot` to a machine-specific path, which breaks execution on any other system.

**Acceptance criteria:**
- Script runs from a clean clone without editing `projectRoot` manually.
- `input/traffic_video.mp4` and `output/` are resolved relative to repository root.

---

## 3) Documentation discrepancy task
**Task:** Align docs with implementation regarding input selection and setup flow.

**Why:** `docs/README.md` claims “GUI-based video selection” and “No manual configuration is needed,” but the script uses a fixed `input/traffic_video.mp4` path and does not prompt for GUI video selection.

**Acceptance criteria:**
- Either implement GUI file selection in script **or** update docs to describe the real non-GUI workflow.
- Setup and usage sections accurately describe required user actions.

---

## 4) Test improvement task
**Task:** Add MATLAB unit tests for core behavior-detection logic and log integrity.

**Why:** There are currently no automated tests; regressions in ID assignment/risk logging can go unnoticed.

**Acceptance criteria:**
- Add tests that validate at least:
  - lane-change threshold behavior,
  - tailgating threshold behavior,
  - risk log rows map only to vehicles involved in detected risk events.
- Tests run via MATLAB `runtests` and are documented in `docs/README.md`.
