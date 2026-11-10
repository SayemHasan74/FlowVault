import QtQuick
import QtQuick.Window
Canvas {
    id:icon
    property string name:"play"
    property color tint:UiPalette.text
    width:24;height:24
    canvasSize:Qt.size(Math.ceil(width*Screen.devicePixelRatio),Math.ceil(height*Screen.devicePixelRatio))
    onNameChanged:requestPaint()
    onTintChanged:requestPaint()
    onCanvasSizeChanged:requestPaint()
    // Static cached texture. Repaint only when the icon or its size changes.
    onPaint:{
        let c=getContext("2d");c.reset();c.clearRect(0,0,canvasSize.width,canvasSize.height);c.scale(canvasSize.width/24,canvasSize.height/24)
        c.fillStyle=tint;c.strokeStyle=tint;c.lineWidth=1.7;c.lineCap="round";c.lineJoin="round"
        function line(points){c.beginPath();c.moveTo(points[0],points[1]);for(let i=2;i<points.length;i+=2)c.lineTo(points[i],points[i+1]);c.stroke()}
        function polygon(points){c.beginPath();c.moveTo(points[0],points[1]);for(let i=2;i<points.length;i+=2)c.lineTo(points[i],points[i+1]);c.closePath();c.fill()}
        function box(x,y,w,h){c.strokeRect(x,y,w,h)}
        switch(name){
        case "play":
            c.beginPath();c.moveTo(7,5);c.quadraticCurveTo(7,3.4,8.5,4.3);c.lineTo(20.5,11.2);c.quadraticCurveTo(22,12,20.5,12.8);c.lineTo(8.5,19.7);c.quadraticCurveTo(7,20.6,7,19);c.closePath();c.fill();break
        case "pause":
            c.beginPath();c.roundedRect(6,5,4.5,14,1.4,1.4);c.roundedRect(13.5,5,4.5,14,1.4,1.4);c.fill();break
        case "previous":c.fillRect(6,5,2,14);polygon([20,5,9.5,12,20,19]);break
        case "next":c.fillRect(16,5,2,14);polygon([4,5,14.5,12,4,19]);break
        case "back10":case "forward10":
            c.save();if(name==="back10"){c.translate(24,0);c.scale(-1,1)}
            c.beginPath();c.arc(12,12,8,0,Math.PI*1.5);c.stroke()
            line([12,4,16.5,4]);line([13.5,1,16.5,4,13.5,7]);c.restore()
            c.font="600 7.5px Inter";c.textAlign="center";c.fillText("10",12,15.5);break
        case "volume":case "mute":
            line([4,9.5,4,14.5,7.5,14.5,12,18.5,12,5.5,7.5,9.5,4,9.5]);
            if(name==="mute"){line([16,8,22,16]);line([22,8,16,16])}
            else {c.beginPath();c.arc(11,12,6,-.8,.8);c.stroke();c.beginPath();c.arc(11,12,10,-.8,.8);c.stroke()}
            break
        case "audio":box(3,4,17,13);line([7,8,7,13,10,12,10,7,16,6,16,11]);c.beginPath();c.arc(8,13,1.5,0,Math.PI*2);c.fill();c.beginPath();c.arc(14,12,1.5,0,Math.PI*2);c.fill();line([9,20,15,20]);break
        case "subtitles":c.beginPath();c.roundedRect(3,5,18,14,3.5,3.5);c.stroke();line([7,11,11,11]);line([13,11,17,11]);line([7,15,9.5,15]);line([12,15,17,15]);break
        case "playlist":box(3,3,17,15);line([6,7,17,7]);line([6,11,14,11]);line([6,15,11,15]);polygon([15,13,23,18,15,23]);break
        case "more":for(let x of [5.5,12,18.5]){c.beginPath();c.arc(x,12,1.7,0,Math.PI*2);c.fill()}break
        case "fullscreen":line([3,9,3,3,9,3]);line([15,3,21,3,21,9]);line([21,15,21,21,15,21]);line([9,21,3,21,3,15]);break
        case "exitFullscreen":line([3,9,9,9,9,3]);line([15,3,15,9,21,9]);line([21,15,15,15,15,21]);line([9,21,9,15,3,15]);break
        case "mini":c.beginPath();c.roundedRect(3,5,18,14,3,3);c.roundedRect(11,12,7,4,1.2,1.2);c.stroke();break
        case "restore":box(3,8,13,13);line([8,8,8,3,21,3,21,16,16,16]);break
        case "pin":line([8,3,16,3,15,10,19,15,5,15,9,10,8,3]);line([12,15,12,22]);break
        case "minimize":line([5,12,19,12]);break
        case "maximize":c.beginPath();c.roundedRect(5,5,14,14,2.5,2.5);c.stroke();break
        case "close":line([5,5,19,19]);line([19,5,5,19]);break
        case "file":line([6,2,14,2,19,7,19,22,6,22,6,2]);line([14,2,14,7,19,7]);break
        }
    }
}
