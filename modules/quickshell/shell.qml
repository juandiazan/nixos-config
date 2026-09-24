import Quickshell
import qs
import qs.widgets

ShellRoot {
    Variants {
        model: Quickshell.screens.filter(screen => Config.monitor === "" || screen.name === Config.monitor)

        VolumeSlider {
            required property var modelData

            screen: modelData
        }
    }
}
