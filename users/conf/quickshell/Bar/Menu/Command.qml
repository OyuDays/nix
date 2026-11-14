import Quickshell.Io
import QtQuick.Layouts
import "root:Bar"
import ".."

ClickableIcon {
    id: root
    required property string pIcon
    required property string pCommand
    property int size
    icon: pIcon
    height: size
    width: size
    Layout.preferredHeight: size
    Layout.preferredWidth: size

    onClicked: event => proc.running = true

    Process {
        id: proc
        command: ["sh", "-c", pCommand]

        running: false
    }
}