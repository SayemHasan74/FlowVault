# Approved clear glass preview

The shared material uses the approved HTML preview’s 22% blue tint, 165% saturation, cool sheen, and a light filter approximating its 2.85 px blur. The title, dock, menu variants, queue, settings, info and toast use the same material. The shader reads the existing mpv video texture in the surface draw; there is no backdrop capture, intermediate blur texture or second video render. Subtitles remain in place. Qt and the browser do not use identical filters.

The player draws vector paths from the original HTML for matching controls. Qt Quick Shapes replaces the old Canvas icon painter. Extra player actions retain equivalent SVG paths and existing hit targets. The portable runtime includes the pinned Shapes module.

The muted input and scene check uses the reference scene and an SRT track. See `tests/results/approved-glass-final/summary.json`. The capture checks appearance and input routing, not sustained 4K GPU cost or native desktop transitions.

Subtitle blur follow-up: set linear filtering on the actual shared texture after FBO creation and recreation. A controlled filtering-only capture changed the subtitle region negligibly. The final shader blends adjacent texels using a contiguous, weighted 11-pixel kernel on each axis, packed into 36 bilinear reads in the same draw. It adds no video render or intermediate texture and leaves subtitle placement intact. The final muted run verifies texture filtering and input behavior; see `tests/results/glass-smooth/summary.json`.

Welcome and dock follow-up: Home and no-video menus now use the same neutral gray glass fallback, with no blue startup fill. Dock glyphs round to 20 and 24 px from 18 and 22 px respectively; the middle play/pause circle and its glyph stay the same size. Home wheel and dock/input checks passed on the same executable; see `tests/results/neutral-home/` and `tests/results/neutral-home-dock/`.
