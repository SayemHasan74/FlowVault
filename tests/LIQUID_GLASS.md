# FlowVault Liquid Glass preview

The reference is the user-supplied **Liquid Glass Player.html**, rendered locally at 1280 × 800 for comparison. The two boards define the playing dock and paused queue. The QML copy uses a seek-first 1040 × 138 dock at that size, a 68 px play/pause orb, pale-blue seek progress, the embedded Inter font, and a 340 px queue with glass rows. Context, track, speed, URL, settings and information surfaces share the same material.

The title bar stays square and flush with the top, with the existing Windows caption hit area. Extra original controls remain present, including pin, Mini, fullscreen, maximize/restore, audio tracks, playlist, and More. The playlist overlays the video without moving the dock. The design's 10-second buttons are additions; keyboard arrows still seek by five seconds. Queue Shuffle only changes upcoming entries when clicked; Autoplay uses the existing setting.

The video stays in the existing QQuickWindow and libmpv framebuffer. A single low-resolution copy of the video (at most 480 × 270) supplies the glass surfaces when needed. The glass uses [Qt ShaderEffect](https://doc.qt.io/qt-6/qml-qtquick-shadereffect.html) and [ShaderEffectSource](https://doc.qt.io/qt-6/qml-qtquick-shadereffectsource.html). The precompiled QSB assets are generated with Qt 6.12.0 `qsb --glsl 120,150,330,440 -o <shader>.qsb <shader>`. Their GLSL sources are in `assets/shaders`; no additional shader tool is needed for a normal build. The Inter font was converted from the reference's bundled WOFF2 to TTF for Qt, with its OFL text included.

## Verification

- Release build SHA-256: `5de8b63615d1be6d8a3c21e21b4d3f5a274e508fa6f661e0a67b4dda4b6296ec`.
- One muted, non-activating input and visual capture run checked Escape from the URL editor, the existing pause/minimize request, hidden-control arrows and mouse reveal, right-click, the title maximize click route, backtick Mini/restore, and dock group spacing at five widths. Zero QML errors; clean exit.
- Captured the actual Qt scene in playing, paused/queue, context-menu and Mini states with synthetic media rendered from the reference backdrop. The capture disables the drawer animation in the occluded test window to show the settled layout; normal playback keeps the slide.
- The isolated Home wheel check moved the list 0 → 72 → 0 and kept volume at 100. An initial concurrent background run did not move the list; the standalone repeat on the same binary passed.
- `tests/results/liquid-glass-checked/summary.json` records the checks. Captures are saved in that local result folder.
- Native desktop minimize/restore and Snap, fullscreen appearance, and real 4K frame pacing remain manual checks. No claim of pixel identity across different video frames or of unchanged GPU cost.

The original FlowPlayer checkout, installed app and data were not changed. FlowVault's settings/history and single-instance identity are separate. The `pre-liquid-glass` tag preserves commit `60a0391` on the FlowVault remote.
