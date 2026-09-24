import QtQuick
import Quickshell
import Quickshell.Wayland
import qs

// A layer-shell panel pinned to a vertical screen edge that stays out of the
// way until hovered.
//
// Only a thin strip accepts pointer input while collapsed -- the input mask
// follows the hover area, so everything past `collapsedWidth` still reaches the
// windows underneath. The strip covers a band of `bandHeight` centred on the
// screen rather than the whole edge, so it doesn't eat window resize handles.
//
// Children are laid out inside that band and slide in when it opens.
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

    // press and drag positions are reported relative to this item
    property Item track: null

    signal scrolled(int steps)
    signal slid(real fraction)  // 0 at the bottom of `track`, 1 at the top
    signal altClicked

    default property alias content: body.data

    function reveal() {
        collapseTimer.stop();
        root.expanded = true;
    }

    function emitSlide(y: real) {
        if (!root.track)
            return;

        const point = hover.mapToItem(root.track, 0, y);
        root.slid(Math.max(0, Math.min(1, 1 - point.y / root.track.height)));
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

        // while collapsed the strip has to hug the screen edge itself, which is
        // the far side of the window when anchored right
        x: root.onRight && !root.expanded ? root.expandedWidth - root.collapsedWidth : 0
        y: Math.round((root.height - root.bandHeight) / 2)
        width: root.expanded ? root.expandedWidth : root.collapsedWidth
        height: root.bandHeight

        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onEntered: root.reveal()
        onExited: collapseTimer.restart()

        onWheel: event => {
            root.reveal();

            const delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x;
            if (delta !== 0)
                root.scrolled(delta > 0 ? 1 : -1);
        }

        onPressed: event => {
            root.reveal();

            if (event.button === Qt.RightButton)
                root.altClicked();
            else
                root.emitSlide(event.y);
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
