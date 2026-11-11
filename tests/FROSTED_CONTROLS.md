# Frosted controls and Escape response

- The bars, pause control and menus share one opaque QML gradient-and-rim component. The video backdrop capture, blur shaders and their resources are removed. mpv subtitle position, style and rendering are unchanged.
- The standard dock is 97 logical pixels tall at full scale (was 138), with unchanged icon sizes and 68 px play button. Narrow windows keep an extra row for hit targets. The title bar is square and the status dot is gone.
- Escape queues pause, dismisses popups and requests the native minimized state in the same key event. It no longer waits on the pause response or two rendered frames. Escape still leaves playback paused on restore; ordinary minimize retains its existing resume policy.

The muted background check with a real SRT track passed at five dock widths, including Escape dispatch before the key handler returned, paused state afterward, right-click, Mini/restore, and caption routing. The captured playing frame shows no text bleeding through the face of the dock. The OS minimize animation and 4K frame pacing/RAM were not measured in this check.

Tested binary: `b4caefa0393cefe5afaa6a95a7642a4d70e4ac3d2f5e1c14127f37d16bdf6624`. See `tests/results/frosted-controls/summary.json` and local captures in that directory.

References: [Qt Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html), [Qt frameSwapped](https://doc.qt.io/qt-6/qquickwindow.html#frameSwapped), [Qt window states](https://doc.qt.io/qt-6/qwindow.html#setWindowStates).
