import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "root:."

Label {
    id: wttrtext
    color: Globals.colors.text
    font.pointSize: 14
    font.family: Globals.vars.fontFamily

    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    horizontalAlignment: Text.AlignHCenter
    elide: Text.ElideRight
    text: "weather"

    Process {
        id: wttrproc
        command: [Qt.resolvedUrl("../../scripts/wttr.sh")]

        running: true

        stdout: SplitParser {
            onRead: data => wttrtext.text = data
        }
    }
    Timer {
        interval: 600000 // 10 min
        running: true
        repeat: true
        onTriggered: {
            wttrproc.running = true
        }
    }
}