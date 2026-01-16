import QtQuick
import QtQuick.Controls

Popup {
    id: suspender
    // 外部传入，用于限制移动范围
    property Item parentItem
    property string str: "Drag"

    signal clicked

    width: 36
    height: width

    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape


    background: Rectangle {
        radius: parent.width / 2
        clip: true
        color: "#ffffff"
        border.color: "#dddddd"
    }

    contentItem:
    Rectangle {
        id: titleBar
        anchors.fill: parent
        radius: parent.width / 2
        color: "#329EEB"

        Text {
            text: suspender.str
            color: "white"
            font.pixelSize: 13
            anchors.centerIn: parent
            font.bold: true
        }

        // Icon {
        //     anchors.centerIn: parent
        //     ico: "refresh.png"
        // }

        MouseArea {
            anchors.fill: parent

            property real startX
            property real startY
            property bool moved: false

            onPressed: mouse => {
                startX = mouse.x
                startY = mouse.y
                moved = false
            }

            onPositionChanged: mouse => {
                if (!parentItem)
                    return

                let dx = mouse.x - startX
                let dy = mouse.y - startY

                // 拖动阈值，5像素
                if (Math.abs(dx) > 2 || Math.abs(dy) > 2)
                    moved = true

                let nx = suspender.x + dx
                let ny = suspender.y + dy

                // ===== 限制在父 Item 内 =====
                nx = Math.max(0, Math.min(nx, parentItem.width - suspender.width))
                ny = Math.max(0, Math.min(ny, parentItem.height - suspender.height))

                suspender.x = nx
                suspender.y = ny
            }

            onReleased: mouse => {
                if (!moved) {
                    suspender.clicked()
                }
            }
        }
    }

    onOpened: {
        Qt.callLater(() => {
            if (parentItem) {
                x = parentItem.width - width * 2
                y = parentItem.height - height * 3
            }
        })
    }
}
