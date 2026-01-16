import QtQuick
import QtQuick.Controls

Popup {
    id: infoCard
    property bool isMe: false
    property bool followed: false
    property string name: "Niya"
    property string socialName: "@niya"
    property string userIntro: "Cute && Powerful\n\nAlways full of hope!"
    property real xPos: 20
    property real yPos: 120

    signal entered
    signal exited

    signal wantToFollow
    signal cancelFollow
    signal seeUser

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

                    height: 40; width: 100
                    radius: height / 4
                    color: isMe ? "#101010" : (followed ? "white"  : "#101010")
                    border.color: "#101010"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 16
                        font.bold: true
                        text: isMe ? "进入空间" : (followed ? "已关注" : "关注")
                        color: isMe ? "white" :followed ? "#101010"  : "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (isMe)
                            {
                                infoCard.seeUser()
                                return
                            }
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
                    id: userName
                    anchors.left: parent.left;  anchors.leftMargin: 20
                    font.pixelSize: 16
                    font.bold: true

                    text: name
                }
                Text {
                    id: usersname
                    anchors.left: userName.left
                    font.pixelSize: 16
                    color: "#606060"

                    text: socialName
                }
            }

            Text {
                id: userBrief
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;    anchors.rightMargin: 20
                maximumLineCount: 6

                wrapMode: Text.Wrap
                elide: Text.ElideRight
                font.pixelSize: 14
                font.bold: true
                color: "#303030"
                text: userIntro
            }

            Rectangle {
                id: furring
                width: 1
                height: 10
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
