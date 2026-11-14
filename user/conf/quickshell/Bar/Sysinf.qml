import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:."
import org.kde.kirigami as Kirigami;

// this entire file is so hacky

Module {
    id: root

    required property string pCommand
    property bool pShowText: true
    property int pInterval: 1000


    Label {
        id: text
        visible: pShowText
        text: "%" // placeholder

        color: Globals.colors.text
        font.pointSize: Globals.vars.panelSize/2
        font.family: Globals.vars.fontFamily
    }

    Process {
            id: textproc
            command: [pCommand, "-t"]

            running: true

            stdout: SplitParser {
                onRead: data => text.text = data
            }
        }
        
    Process {
            id: iconproc
            command: [pCommand, "-i"]

            running: true

            stdout: SplitParser {
                onRead: data => root.icon = data
            }
        }

    Timer {
        interval: pInterval
        running: true
        repeat: true
        onTriggered: {
            textproc.running = true
            iconproc.running = true
            }
    }
}
