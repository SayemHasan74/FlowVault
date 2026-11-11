import QtQuick
import QtQuick.Shapes

Item {
    id:icon
    property string name:"play"
    property color tint:UiPalette.text
    width:24;height:24

    // SVG geometry from the reference; extra player actions use the same stroke.
    readonly property var glyph: {
        switch(name) {
        case "pin": return ["M12 17v5 M9 3h6l-1 6 3 3v2H7v-2l3-3z", 1.8]
        case "mini": return ["M6.0 5.0H18.0Q21.0 5.0 21.0 8.0V16.0Q21.0 19.0 18.0 19.0H6.0Q3.0 19.0 3.0 16.0V8.0Q3.0 5.0 6.0 5.0Z M12.2 12.0H16.8Q18.0 12.0 18.0 13.2V14.8Q18.0 16.0 16.8 16.0H12.2Q11.0 16.0 11.0 14.8V13.2Q11.0 12.0 12.2 12.0Z", 1.8]
        case "minimize": return ["M5 12h14", 1.8]
        case "maximize": return ["M7.5 5.0H16.5Q19.0 5.0 19.0 7.5V16.5Q19.0 19.0 16.5 19.0H7.5Q5.0 19.0 5.0 16.5V7.5Q5.0 5.0 7.5 5.0Z", 1.8]
        case "close": return ["M6 6l12 12M18 6L6 18", 1.8]
        case "volume": return ["M4 9.5v5h3.5L12 18.5v-13L7.5 9.5z M15.5 9a4 4 0 0 1 0 6 M18 6.5a7.5 7.5 0 0 1 0 11", 1.8]
        case "previous": return ["M6 5h2v14H6zM20 5v14L9.5 12z", 0]
        case "back10": return ["M4 12a8 8 0 1 0 8-8H8 M10.5 1.5L7.5 4.5l3 3", 1.7]
        case "forward10": return ["M20 12a8 8 0 1 1 -8-8h4 M13.5 1.5l3 3-3 3", 1.7]
        case "next": return ["M16 5h2v14h-2zM4 5v14l10.5-7z", 0]
        case "subtitles": return ["M6.5 5.0H17.5Q21.0 5.0 21.0 8.5V15.5Q21.0 19.0 17.5 19.0H6.5Q3.0 19.0 3.0 15.5V8.5Q3.0 5.0 6.5 5.0Z M7 11h4M13 11h4M7 15h2.5M12 15h5", 1.7]
        case "fullscreen": return ["M4 9V5a1 1 0 0 1 1-1h4M15 4h4a1 1 0 0 1 1 1v4M20 15v4a1 1 0 0 1 -1 1h-4M9 20H5a1 1 0 0 1 -1-1v-4", 1.7]
        case "more": return ["M3.8 12.0a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0Z M10.3 12.0a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0Z M16.8 12.0a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0Z", 0]
        case "pause": return ["M7.4 5.0H9.1Q10.5 5.0 10.5 6.4V17.6Q10.5 19.0 9.1 19.0H7.4Q6.0 19.0 6.0 17.6V6.4Q6.0 5.0 7.4 5.0Z M14.9 5.0H16.6Q18.0 5.0 18.0 6.4V17.6Q18.0 19.0 16.6 19.0H14.9Q13.5 19.0 13.5 17.6V6.4Q13.5 5.0 14.9 5.0Z", 0]
        case "play": return ["M7 4.8v14.4a1 1 0 0 0 1.5 .86l12-7.2a1 1 0 0 0 0-1.72l-12-7.2A1 1 0 0 0 7 4.8z", 0]
        case "mute": return ["M4 9.5v5h3.5L12 18.5v-13L7.5 9.5z M16 9l6 6m0-6-6 6", 1.8]
        case "exitFullscreen": return ["M3 9h6V3m6 0v6h6m0 6h-6v6m-6 0v-6H3", 1.7]
        case "restore": return ["M3 8h13v13H3z M8 8V3h13v13h-5", 1.7]
        case "audio": return ["M4 5h16v14H4z M10 15V9l6-1v5m-6 2a1.5 1 0 1 1-3 0 1.5 1 0 1 1 3 0m6-2a1.5 1 0 1 1-3 0 1.5 1 0 1 1 3 0", 1.7]
        case "playlist": return ["M4 6h16M4 11h16M4 16h9m3-2 4 3-4 3z", 1.7]
        case "file": return ["M6 2h8l5 5v15H6z M14 2v5h5", 1.7]
        default: return ["",0]
        }
    }
    Item {
        anchors.centerIn:parent;width:24;height:24
        scale:Math.min(icon.width,icon.height)/24
        Shape {
            anchors.fill:parent
            preferredRendererType:Shape.CurveRenderer
            ShapePath {
                fillColor:icon.glyph[1]===0?icon.tint:"transparent"
                strokeColor:icon.glyph[1]===0?"transparent":icon.tint
                strokeWidth:icon.glyph[1]
                capStyle:ShapePath.RoundCap
                joinStyle:ShapePath.RoundJoin
                PathSvg {path:icon.glyph[0]}
            }
        }
        Text {
            anchors.horizontalCenter:parent.horizontalCenter
            y:15.5-baselineOffset
            visible:icon.name==="back10"||icon.name==="forward10"
            text:visible?"10":"";color:icon.tint;font.pixelSize:8;font.weight:Font.DemiBold
        }
    }
}
