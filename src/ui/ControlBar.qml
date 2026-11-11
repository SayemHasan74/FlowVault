import QtQuick

Item {
    id: controls
    objectName: "playbackControls"
    property string inputRole: "control"
    property bool showRemaining: true
    readonly property real uiScale: playerWindow.mini ? 0.63 : Math.min(1,Math.max(0.54,width/900))
    readonly property bool narrow: layout.width < 730
    readonly property bool compact: layout.width < 960
    readonly property bool hovered: hover.hovered || seek.dragging
    signal menuRequested(string kind,real px,real py)
    signal playlistRequested()

    function dockWidth() {return Math.min(1040,Math.max(1,parent.width-(playerWindow.mini?24:48)))}
    width: dockWidth()
    height: (narrow ? 138 : 97)*uiScale
    HoverHandler {id:hover}
    GlassSurface {anchors.fill:parent;radius:28*controls.uiScale}

    function menu(kind,item) {let p=item.mapToItem(controls.parent,0,0);menuRequested(kind,p.x,p.y)}
    function stamp(seconds) {seconds=Math.max(0,Math.floor(seconds));let h=Math.floor(seconds/3600),m=Math.floor(seconds/60)%60,s=seconds%60;return (h>0?h+":"+String(m).padStart(2,"0"):String(m))+":"+String(s).padStart(2,"0")}
    FontMetrics {id:timeMetrics;font:elapsed.font}
    function diagnosticLayout() {
        let results=[]
        for(let size of [240,336,444.16,800,1040]){
            controls.width=size;volumeRow.forceLayout();transport.forceLayout();actions.forceLayout()
            results.push({width:size,volumeClear:volumeRow.x+volumeRow.width<=(narrow?actions.x:transport.x),actionsClear:narrow||transport.x+transport.width<=actions.x,seekWidth:seek.width})
        }
        controls.width=Qt.binding(()=>controls.dockWidth())
        return results
    }

    Item {
        id: layout
        width: controls.width/controls.uiScale
        height: controls.height/controls.uiScale
        scale: controls.uiScale
        transformOrigin: Item.TopLeft
        readonly property int inset: controls.compact?20:30
        Text {
            id:elapsed;x:layout.inset;y:14-height/2
            width:Math.max(44,timeMetrics.advanceWidth(controls.stamp(mpv.duration)))
            text:controls.stamp(controls.visible?mpv.position:0);color:UiPalette.text;font.pixelSize:13;font.weight:Font.Medium
        }
        Text {
            id:remaining;y:14-height/2;width:Math.max(52,timeMetrics.advanceWidth("−"+controls.stamp(mpv.duration)))
            horizontalAlignment:Text.AlignRight;anchors.right:parent.right;anchors.rightMargin:layout.inset
            text:controls.showRemaining?"−"+controls.stamp(controls.visible?mpv.duration-mpv.position:0):controls.stamp(mpv.duration)
            color:UiPalette.text;font.pixelSize:13;font.weight:Font.Medium
            MouseArea {anchors.fill:parent;onClicked:controls.showRemaining=!controls.showRemaining}
        }
        SeekBar {id:seek;y:0;anchors.left:elapsed.right;anchors.leftMargin:16;anchors.right:remaining.left;anchors.rightMargin:16;height:28}
        Row {
            id:volumeRow;objectName:"volumeGroup";x:layout.inset;y:controls.narrow?96:41;spacing:10
            ActionButton {icon:mpv.mute?"mute":"volume";iconSize:22;hint:"Mute · M";onActivated:mpv.toggleMute()}
            Item {
                property string inputRole:"volume";width:controls.narrow?64:104;height:40
                Rectangle {anchors.verticalCenter:parent.verticalCenter;width:parent.width;height:5;radius:2.5;color:UiPalette.track}
                Rectangle {anchors.verticalCenter:parent.verticalCenter;width:parent.width*Math.min(1,mpv.volume/150);height:5;radius:2.5;color:UiPalette.text}
                Rectangle {anchors.verticalCenter:parent.verticalCenter;x:Math.max(-7,Math.min(parent.width-7,parent.width*mpv.volume/150-7));width:14;height:14;radius:7;color:UiPalette.text}
                MouseArea {anchors.fill:parent;onPressed:event=>mpv.setVolume(event.x/width*150);onPositionChanged:event=>{if(pressed)mpv.setVolume(event.x/width*150)}}
            }
        }
        Row {
            id:transport;objectName:"transportGroup";anchors.horizontalCenter:parent.horizontalCenter;y:28;spacing:controls.compact?8:14
            ActionButton {objectName:"previousButton";icon:"previous";width:controls.compact?34:44;height:68;iconSize:22;hint:"Previous file";onActivated:history.navigate(-1)}
            ActionButton {icon:"back10";width:controls.compact?38:48;height:68;iconSize:28;hint:"Back 10 seconds";onActivated:mpv.seek(-10)}
            ActionButton {objectName:"playPauseButton";orb:true;icon:mpv.pause?"play":"pause";width:68;height:68;iconSize:mpv.pause?30:28;hint:"Play / Pause · Space";onActivated:{mpv.togglePause();appDiagnostics.overlayClick()}}
            ActionButton {icon:"forward10";width:controls.compact?38:48;height:68;iconSize:28;hint:"Forward 10 seconds";onActivated:mpv.seek(10)}
            ActionButton {objectName:"nextButton";icon:"next";width:controls.compact?34:44;height:68;iconSize:22;hint:"Next file";onActivated:history.navigate(1)}
        }
        Row {
            id:actions;objectName:"actionGroup";anchors.right:parent.right;anchors.rightMargin:layout.inset;y:controls.narrow?96:41;spacing:controls.compact?2:4
            readonly property int buttonWidth: controls.compact?30:40
            ActionButton {icon:"subtitles";width:actions.buttonWidth;hint:"Subtitles · S";onActivated:controls.menu("sub",this)}
            ActionButton {icon:"audio";width:actions.buttonWidth;hint:"Audio tracks · A";onActivated:controls.menu("audio",this)}
            ActionButton {pill:true;label:mpv.speed.toFixed(Math.abs(mpv.speed*10-Math.round(mpv.speed*10))<0.001?1:2)+"×";textSize:13;width:Math.max(48,label.length*8+16);height:32;y:4;hint:"Playback speed";onActivated:controls.menu("speed",this)}
            ActionButton {icon:"playlist";width:actions.buttonWidth;hint:"Playlist · L";onActivated:controls.playlistRequested()}
            ActionButton {objectName:"fullscreenButton";icon:playerWindow.fullscreen?"exitFullscreen":"fullscreen";width:actions.buttonWidth;checked:playerWindow.fullscreen;hint:playerWindow.fullscreen?"Exit fullscreen · F":"Fullscreen · F";onActivated:playerWindow.toggleFullscreen()}
            ActionButton {icon:"more";width:actions.buttonWidth;hint:"More options";onActivated:controls.menu("context",this)}
        }
    }
}
