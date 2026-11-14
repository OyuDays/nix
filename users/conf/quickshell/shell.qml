//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import Quickshell
import Quickshell.Io
import QtQuick
import "Bar"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens;
        Scope {
            id: scope;
            required property var modelData
            Bar {
                screen: scope.modelData
            }
        }
    }

}
