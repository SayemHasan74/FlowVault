import QtQuick

Rectangle {
    // Opaque material: neither reads the video texture nor exposes subtitles underneath.
    border.color: UiPalette.border
    gradient: Gradient {
        GradientStop { position: 0; color: UiPalette.frostTop }
        GradientStop { position: 0.45; color: UiPalette.frostMid }
        GradientStop { position: 1; color: UiPalette.frostBottom }
    }
}
