# Direct Liquid Glass preview

The shared QML surface uses the existing mpv framebuffer texture directly when video is visible. A single shader sample per surface pixel supplies the tinted scene color, with a small edge refraction and a brighter rim inspired by the supplied HTML. There is no captured or downsampled backdrop, second video render, or separate window. Home and hidden-video Mini use the solid fallback.

The dock remains 97 logical pixels tall at full scale. Icons are rounded to about 80% of their previous size, the play/pause circle is 48 px (was 68), the paused overlay circle is 84 px at full size (was 120), and the seek row moves down 5 px before scaling. Subtitle positioning and the immediate Escape path are unchanged. Subtitle outlines can show through the live glass, but the material does not blur or repeat them.

Validation uses the existing muted background input test and scene captures with the HTML reference scene and an SRT track. See `tests/results/direct-glass-final/summary.json` and the local captures. Actual desktop transitions and 4K GPU/frame pacing are outside this check.

The checked-in QSB is generated with Qt 6.12 `qsb --glsl 120,150,330,440 -o assets/shaders/glass.frag.qsb assets/shaders/glass.frag`.

Color refinement: use the HTML's 190% saturation, 36% base tint, and brighter top highlight while retaining a single texture sample. Removed the unused legacy maximize-press helper and its test-only cases; current native routing remains covered. The muted input check and remaining window-state tests passed. New capture and executable hash: `tests/results/glass-color/`.
