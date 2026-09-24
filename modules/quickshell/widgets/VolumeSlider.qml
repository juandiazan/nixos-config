import QtQuick
import qs
import qs.services

// Hover the screen edge to open; scroll or drag to set the volume,
// right click to mute.
EdgePanel {
    id: root

    readonly property real level: Math.min(1, Audio.volume)

    layerNamespace: "quickshell-volume"
    onRight: Config.volume.onRight
    collapsedWidth: Config.volume.collapsedWidth
    expandedWidth: Config.volume.expandedWidth
    bandHeight: Config.volume.bandHeight
    showHandle: Config.volume.handle
    handleColor: Audio.muted ? Theme.lightRed : Theme.teal
    track: trackRect

    onScrolled: steps => Audio.addVolume(steps * Config.volume.step)
    onSlid: fraction => {
        Audio.setMuted(false);
        Audio.setVolume(fraction);
    }
    onAltClicked: Audio.toggleMute()

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 14
        color: Qt.rgba(Theme.ink1.r, Theme.ink1.g, Theme.ink1.b, 0.78)
        border.width: 1
        border.color: Theme.ink3

        Rectangle {
            id: trackRect

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: icon.top
                topMargin: 12
                leftMargin: 14
                rightMargin: 14
                bottomMargin: 10
            }
            radius: width / 2
            color: Theme.ink3

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: parent.height * root.level
                radius: parent.radius
                color: Audio.muted ? Theme.ink5 : Theme.teal

                Behavior on height {
                    NumberAnimation {
                        duration: 90
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Text {
            id: icon

            anchors {
                bottom: label.top
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 2
            }
            text: {
                if (Audio.muted)
                    return "󰝟";
                if (root.level < 0.33)
                    return "󰕿";
                if (root.level < 0.66)
                    return "󰖀";
                return "󰕾";
            }
            font.family: Theme.fontFamily
            font.pixelSize: 18
            color: Audio.muted ? Theme.red : Theme.white
        }

        Text {
            id: label

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            text: Math.round(Audio.volume * 100)
            font.family: Theme.fontFamily
            font.pixelSize: 14
            color: Theme.whiteDim
        }
    }
}
