import QtQuick
import Quickshell
import Quickshell.Wayland
import qs

PanelWindow {
    id: root

    property int collapsedWidth: 6
    property int expandedWidth: 54
    property int bandHeight: 300
    property int collapseDelay: 220
    property bool showHandle: true
    property color handleColor: Theme.teal
    property string layerNamespace: "quickshell-edge"
    property bool onRight: false
    property bool expanded: false

    property list<Item> tracks

    signal scrolled(int index, int steps)
    signal slid(int index, real fraction)  // 0 at the bottom of the track, 1 at the top
    signal altClicked(int index)

    default property alias content: body.data

    function reveal() {
        collapseTimer.stop();
        root.expanded = true;
    }

    function trackAt(x: real): int {
        let nearest = -1;
        let nearestDistance = Infinity;
        for (let i = 0; i < root.tracks.length; i++) {
            const track = root.tracks[i];
            const distance = Math.abs(track.mapToItem(body, track.width / 2, 0).x - x);
            if (distance < nearestDistance) {
                nearest = i;
                nearestDistance = distance;
            }
        }
        return nearest;
    }

    function emitSlide(y: real) {
        const track = root.tracks[hover.dragIndex];
        if (!track)
            return;

        const point = hover.mapToItem(track, 0, y);
        root.slid(hover.dragIndex, Math.max(0, Math.min(1, 1 - point.y / track.height)));
    }

    WlrLayershell.namespace: root.layerNamespace

    color: "transparent"
    exclusiveZone: 0
    implicitWidth: root.expandedWidth
    anchors {
        left: !root.onRight
        right: root.onRight
        top: true
        bottom: true
    }

    // input is limited to the hover area, which is the thin strip until opened
    mask: Region {
        item: hover
    }

    Timer {
        id: collapseTimer

        interval: root.collapseDelay
        onTriggered: {
            if (!hover.containsMouse && !hover.pressed)
                root.expanded = false;
        }
    }

    // a hint that there is something here to hover
    Rectangle {
        width: 3
        height: 56
        x: root.onRight ? root.expandedWidth - width : 0
        y: Math.round((root.height - height) / 2)
        radius: width
        color: root.handleColor
        visible: root.showHandle && opacity > 0
        opacity: root.expanded ? 0 : 0.35

        Behavior on opacity {
            NumberAnimation {
                duration: 160
                easing.type: Easing.OutCubic
            }
        }
    }

    Item {
        id: body

        width: root.expandedWidth
        height: root.bandHeight
        y: hover.y
        x: root.expanded ? 0 : (root.onRight ? root.expandedWidth : -root.expandedWidth)
        opacity: root.expanded ? 1 : 0
        visible: opacity > 0

        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 160
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: hover

        x: root.onRight && !root.expanded ? root.expandedWidth - root.collapsedWidth : 0
        y: Math.round((root.height - root.bandHeight) / 2)
        width: root.expanded ? root.expandedWidth : root.collapsedWidth
        height: root.bandHeight

        // the track a drag started on, so the drag stays on it
        property int dragIndex: -1

        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onEntered: root.reveal()
        onExited: collapseTimer.restart()

        // the track is picked before reveal(), which moves the hover area
        // and so the meaning of event.x
        onWheel: event => {
            const index = root.trackAt(hover.x + event.x);
            root.reveal();

            const delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x;
            if (index >= 0 && delta !== 0)
                root.scrolled(index, delta > 0 ? 1 : -1);
        }

        onPressed: event => {
            const index = root.trackAt(hover.x + event.x);
            root.reveal();

            if (index < 0)
                return;
            if (event.button === Qt.RightButton) {
                root.altClicked(index);
            } else {
                hover.dragIndex = index;
                root.emitSlide(event.y);
            }
        }

        onPositionChanged: event => {
            if (hover.pressedButtons & Qt.LeftButton)
                root.emitSlide(event.y);
        }

        onReleased: {
            if (!hover.containsMouse)
                collapseTimer.restart();
        }
    }
}
