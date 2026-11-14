import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:."

Module {
    id: root

    width: 180

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }


    Label {
        color: Globals.colors.text
        font.pointSize: Globals.vars.panelSize/2
        font.family: Globals.vars.fontFamily
        text: Qt.formatDateTime(clock.date, "ddd, dd. MMM hh:mm:ss") 
    }
}
