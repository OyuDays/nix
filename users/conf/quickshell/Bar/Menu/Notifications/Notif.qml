import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:."
import ".."

Rectangle {
    id: root
    required property Notification notif

    height: body.implicitHeight
    
    Text {
        id: body
        anchors.fill: parent
        textFormat: Text.MarkdownText
        color: Globals.colors.text
        font.pointSize: Globals.vars.panelSize/2
        font.family: Globals.vars.fontFamily
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        elide: Text.ElideRight
        
        text: root.notif.body
    }
}