import QtQuick
import QtQuick.Controls

Popup {
    id: infoCard
    default property bool followed: false
    property string userName: "Niya"
    property string userEmail: "niya@ww.com"
    property string userBrief: "Cute && Powerful"
    property real xPos: 20
    property real yPos: 120

    signal entered
    signal exited
    signal wantToFollow
    signal cancelFollow

    modal: false
    focus: false
    padding: 2

    // 出现位置
    x: xPos
    y: yPos

    contentItem: Rectangle {
        id: content
        implicitWidth: 260
        implicitHeight: layout.implicitHeight
        anchors.centerIn: parent
        clip: true

        Column {
            id: layout
            spacing: 4
            anchors.fill: parent

            Rectangle {
                id: avator
                anchors.left: parent.left
                anchors.right: parent.right
                height: 80

                Avatar {
                    anchors.left: parent.left;  anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    height: 70; width: 70
                }

                Rectangle {
                    anchors.right: parent.right;    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    height: 30; width: 70
                    radius: 10
                    color: followed ? "white"  : "#101010"
                    border.color: "#101010"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        font.bold: true
                        text: followed ? "已关注" : "关注"
                        color: followed ? "#101010"  : "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (followed)
                                infoCard.wantToFollow()
                            else
                                infoCard.cancelFollow()
                            followed = !followed
                        }
                    }
                }
            }

            Column {
                id: info
                anchors.left: parent.left;  anchors.right: parent.right
                height: 40
                spacing: 2

                Text {
                    id: name
                    anchors.left: parent.left;  anchors.leftMargin: 20
                    font.pixelSize: 14
                    font.bold: true

                    text: userName
                }
                Text {
                    id: email
                    anchors.left: name.left
                    font.pixelSize: 14
                    color: "#606060"

                    text: userEmail
                }
            }

            Text {
                id: brief
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;    anchors.rightMargin: 20
                maximumLineCount: 6

                wrapMode: Text.Wrap
                elide: Text.ElideRight
                font.pixelSize: 12
                font.bold: true
                color: "#303030"
                text: userBrief
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            onEntered: infoCard.entered()
            onExited: infoCard.exited()
        }
    }

}
