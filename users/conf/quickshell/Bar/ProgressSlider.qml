import QtQuick
import QtQuick.Layouts
import "root:."

MouseArea {
    id: root
    required property var progressLength
    required property var progressPosition
    property string leftColor: Globals.colors.inactivetext
    property string trackerColor: Globals.colors.text
    property string progressColor: Globals.colors.active

    height: 15

    Rectangle {
        id: bar

        color: root.leftColor
        height: 5
        width: parent.width

        //radius: height/2

        Rectangle {
            id: progress
            height: parent.height+2
            width: (Math.min(root.progressPosition, root.progressLength)/root.progressLength)*root.width+2
            x: parent.x-1
            //radius: parent.radius

            color: root.progressColor
            anchors.verticalCenter: parent.verticalCenter

        }
        Rectangle {
            id: pos
            x: (Math.min(root.progressPosition, root.progressLength)/root.progressLength)*root.width - width/2
            
            height: 15
            width: 15
            color: root.trackerColor
            
            //radius: height/2
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
