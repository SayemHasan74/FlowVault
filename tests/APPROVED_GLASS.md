# Approved clear glass preview

The shared material uses the approved HTML preview’s 22% blue tint, 165% saturation, cool sheen, and a light filter approximating its 2.85 px blur. The title, dock, menu variants, queue, settings, info and toast use the same material. The shader reads the existing mpv video texture in the surface draw; there is no backdrop capture, intermediate blur texture or second video render. Subtitles remain in place. Qt and the browser do not use identical filters.

The player draws vector paths from the original HTML for matching controls. Qt Quick Shapes replaces the old Canvas icon painter. Extra player actions retain equivalent SVG paths and existing hit targets. The portable runtime includes the pinned Shapes module.

The muted input and scene check uses the reference scene and an SRT track. See `tests/results/approved-glass-final/summary.json`. The capture checks appearance and input routing, not sustained 4K GPU cost or native desktop transitions.
