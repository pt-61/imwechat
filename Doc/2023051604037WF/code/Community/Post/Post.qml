/*
帖子
展示帖子的详细内容：作者、内容、评论
还有各种附带的功能： 鼠标光标悬停在用户头像上，会弹出用户的信息卡片
*/
import QtQuick
import QtQuick.Controls
import "../User"

Rectangle {
    id: post
    default property string postTitle: "Post"
    property string userName: "Niya"
    property string userEmail: "Niya@uu.com"
    property string postContent: "This \n\nis \n\npost \n\ncontent\n\n\n\n\n\n\n\n\n\n\n\n\nE\nN\nD!"

    signal back
    signal showInfoCard
    signal hideInfoCard

    width: 600
    color: "#fdfdfd"
    border.color: "#f6f6f6"
    border.width: 1

    Rectangle {
        id: header
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 50
        // color: parent.color

        Icon {
            id: backIco
            anchors.left: parent.left;  anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            height: 30; width: 30

            ico: "picture/icons/back.png"
        }
        Text {
            id: title
            anchors.verticalCenter: backIco.verticalCenter
            anchors.left: backIco.right;    anchors.leftMargin: 30
            font.pixelSize: 22
            font.bold: true

            text: postTitle
        }
    }

    ScrollView {
        anchors.top: header.bottom; anchors.topMargin: 20
        anchors.bottom: parent.bottom
        width: parent.width
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        clip: true

        Column {
            width: parent.width
            spacing: 20

            Rectangle {
                id: avator
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;anchors.rightMargin: 20
                height: 50

                Avatar {
                    id: av
                    anchors.verticalCenter: parent.verticalCenter
                    onEntered: hoverTimer.restart()
                    onExited: hoverTimer.restart()
                }
                Text {
                    id: name
                    anchors.left: av.right; anchors.leftMargin: 6
                    anchors.top: parent.top; anchors.topMargin: 4
                    font.pixelSize: 14
                    font.bold: true

                    text: userName
                }
                Text {
                    id: email
                    anchors.left: av.right; anchors.leftMargin: 6
                    anchors.bottom: av.bottom; anchors.bottomMargin: 4
                    font.pixelSize: 14

                    text: userEmail
                }
            }

            Text {
                id: content
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;anchors.rightMargin: 20

                text: postContent
                wrapMode: Text.Wrap
                font.pixelSize: 16
                color: "#303030"
            }
        }
    }

    property bool showCard: false
    Timer {
        id: hoverTimer
        interval: 500   // 悬停 500ms 才显示
        repeat: false
        onTriggered: {
            if (showCard)
                // console.log("WOW")
                infoCard.close()
            else
                // console.log("TAT")
                infoCard.open()
            showCard = !showCard
        }
    }
    InfoCard {
        id: infoCard

        onEntered:  {
            console.log("MoM")
            hoverTimer.stop()
        }
        onExited: hoverTimer.restart()
    }
}
