import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "Mpris"
import "Systray"
import "Menu"
import "root:."

PanelWindow {
  id: root
  color: Globals.colors.panelbg
  aboveWindows: false

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: Globals.vars.panelSize

  Item {
    id: content

    implicitHeight: Globals.vars.panelSize

    anchors { top: parent.top
      left: parent.left
      right: parent.right
      fill: parent
    }


    // LEFT MODULES
    RowLayout {
      spacing: Globals.vars.spacing
      anchors {
        bottom: parent.bottom
        top: parent.top
        left: parent.left
        leftMargin: Globals.vars.barMargin
      }

      Player {bar: root}
      Clock {}
    }

    // CENTER MODULES
    RowLayout {
      spacing: Globals.vars.spacing
      anchors {
        bottom: parent.bottom
        top: parent.top
        horizontalCenter: parent.horizontalCenter
      }

      Workspace {screen: root.screen}
    }

    // RIGHT MODULES
    RowLayout {
      spacing: Globals.vars.spacing
      anchors {
        bottom: parent.bottom
        top: parent.top
        right: parent.right
        rightMargin: Globals.vars.barMargin
      }

      Systray {bar: root}
      Sysinf {
          pCommand: Qt.resolvedUrl("../scripts/signalstrength.sh")
          pShowText: false
      }
      Sysinf {pCommand: Qt.resolvedUrl("../scripts/cpuavg.py")}
      Sysinf {pCommand: Qt.resolvedUrl("../scripts/memusage.py")}
      Audio {}
      Menu {bar: root}
    }
  }
}
