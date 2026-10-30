# Home recent-video scrolling — 2026-10-30

The window wheel filter now passes events through to QML while Home is visible, so the recent-video ListView scrolls instead of changing playback volume. Playback wheel volume/seek routing is unchanged. The same source fix is applied to FlowPlayer and FlowVault at the user's explicit request, before library development starts.

Verification: Release build and one isolated, muted, non-activating integration check using ten synthetic history entries and in-process wheel events. List contentY moved **0 → 72 → 0**; volume remained **100 → 100**. Clean exit, no activation, no QML errors. The first diagnostic attempt omitted wheel timestamps and did not reproduce reverse scrolling; the final test supplies realistic timestamps and passes in both directions.

Command: `.tools/Scripts/python.exe scripts/test-home-wheel.py --name <unique-result-name>`.

Tested and deployed FlowPlayer executable SHA-256: `e587530547484835080dc51fecfb0ce31cf2b2342e2dec540568ea00950cc9a1`.

Evidence: `tests/results/home-wheel-final/summary.json` and its sibling `logs/flowplayer.log`. FlowVault receives identical changed source files; it was not independently built or launched. No library feature or visual redesign is included.
