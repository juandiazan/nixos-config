import QtQuick
import qs

// One bar of the audio panel: the fill shows the level, with an icon and the
// percentage underneath. Only draws; the panel handles the mouse.
Item {
    id: root

    property real volume: 0
    property bool muted: false
    property string icon: ""

    readonly property real level: Math.min(1, root.volume)
    readonly property Item track: trackRect

    Rectangle {
        id: trackRect

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: iconText.top
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
            color: root.muted ? Theme.ink5 : Theme.teal

            Behavior on height {
                NumberAnimation {
                    duration: 90
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Text {
        id: iconText

        anchors {
            bottom: label.top
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 2
        }
        text: root.icon
        font.family: Theme.fontFamily
        font.pixelSize: 18
        color: root.muted ? Theme.red : Theme.white
    }

    Text {
        id: label

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 10
        }
        text: Math.round(root.volume * 100)
        font.family: Theme.fontFamily
        font.pixelSize: 14
        color: Theme.whiteDim
    }
}
