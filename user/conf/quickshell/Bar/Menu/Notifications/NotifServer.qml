pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Singleton {
    id: root

    // thanks end4, mwa
    component Notif: QtObject {
        required property int id
        property Notification notification
        property list<var> actions: notification?.actions.map((action) => ({
            "identifier": action.identifier,
            "text": action.text,
        })) ?? []
        property bool popup: false
        property string appIcon: notification?.appIcon ?? ""
        property string appName: notification?.appName ?? ""
        property string body: notification?.body ?? ""
        property string image: notification?.image ?? ""
        property string summary: notification?.summary ?? ""
        property double time
        property string urgency: notification?.urgency.toString() ?? "normal"
        property Timer timer
    }

    property int notifCount: notifServer.trackedNotifications.values.length
    property ScriptModel notifications: serverNotifications
    property alias server: notifServer

    function clearNotifs() {
        [...server.trackedNotifications.values].forEach(elem => {
            elem.dismiss();
        });
    }

    NotificationServer {
        id: notifServer

        // filter out later, atm just advertise everything
        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: n => {
            n.tracked = true
            console.info("Got notif!")
            console.info(root.notifCount)
        }
    }

    ScriptModel {
        id: serverNotifications

        values: [...notifServer.trackedNotifications.values].reverse()
  }
}