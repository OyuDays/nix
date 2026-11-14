import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:."
import ".."

Rectangle {
    id: root

    height: list.implicitHeight
    width: list.implicitWidth

    ListView {
        id: list

        // anchors.left: parent.left
        // anchors.right: parent.right
        // anchors.top: parent.top
        anchors.fill: parent

        //height: contentHeight
        // height: (contentHeight < 300) ? contentHeight : 300

        model: NotifServer.server.notifications
        
        delegate: Notif {
            id: notificationView

            required property Notification modelData

            width: list.width

            anchors.fill: list
            notif: parent.modelData
        }
    }
}