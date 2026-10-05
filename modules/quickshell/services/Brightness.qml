pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// The screen backlight, through brightnessctl. On machines without a
// backlight (or without brightnessctl) `available` stays false, and the
// panel leaves the brightness bar out.
Singleton {
    id: root

    property string device: ""
    property real max: 0
    readonly property bool available: root.device !== "" && root.max > 0
    readonly property real brightness: root.available ? Number(current.text()) / root.max : 0

    function setBrightness(value: real) {
        if (!root.available)
            return;

        // -n keeps it from going fully black, same as the brightness keys
        const percent = Math.round(Math.max(0, Math.min(1, value)) * 100);
        Quickshell.execDetached(["brightnessctl", "-q", "-d", root.device, "-n", "set", percent + "%"]);
    }

    function addBrightness(delta: real) {
        root.setBrightness(root.brightness + delta);
    }

    // finds the device once at startup, prints e.g.
    // "amdgpu_bl1,backlight,32771,50%,65535" (name, class, current, percent, max)
    Process {
        running: true
        command: ["brightnessctl", "-c", "backlight", "-m", "info"]
        stdout: StdioCollector {
            onStreamFinished: {
                const fields = this.text.trim().split(",");
                if (fields.length === 5) {
                    root.device = fields[0];
                    root.max = Number(fields[4]);
                }
            }
        }
    }

    // the kernel announces every change to this file, so the bar also
    // follows the brightness keys
    FileView {
        id: current

        path: root.device ? `/sys/class/backlight/${root.device}/brightness` : ""
        watchChanges: true
        onFileChanged: this.reload()
    }
}
