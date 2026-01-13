/*
侧边栏
展示：用户背景、头像与昵称，以及个人信息、绘画、社区、群组、关注、好友、收藏、交易、消息、帖子等的按钮
*/
import QtQuick

import "../User"
import "../Common"

Rectangle {
    id: navigationSidebar

    property string userName: "Niya"
    property string socialName: "@Niya"

    anchors.top: parent.top; anchors.bottom: parent.bottom
    anchors.left: parent.left;
    border.color: "#e0e0e0"
    border.width: 1

    signal toPage(page: string)
    // color: "#80efffef"

    // Image {
    //     id: bg
    //     anchors.top: parent.top
    //     anchors.left: parent.left;  anchors.leftMargin: 1
    //     anchors.right: parent.right;anchors.rightMargin: 1
    //     width: parent.width
    //     height: width / 3
    //     smooth: true
    //     fillMode: Image.PreserveAspectCrop

    //     source: "../picture/default/background.jpg"
    // }

    Avatar {
        id: avatar
        // anchors.horizontalCenter: bg.horizontalCenter
        // anchors.bottom: bg.bottom;  anchors.bottomMargin: -height / 2
        anchors.top: parent.top;    anchors.topMargin: 20
        anchors.left: parent.left;  anchors.leftMargin: parent.width / 6

        height: parent.width / 4
        width: height
    }

    Text {
        id: name
        anchors.bottom: avatar.verticalCenter;  anchors.bottomMargin: 4
        anchors.left: avatar.right; anchors.leftMargin: 10
        color: "#404040"
        font.bold: true
        font.pixelSize: 14
        text: userName
    }
    Text {
        id: email
        anchors.top: avatar.verticalCenter; anchors.topMargin: 4
        anchors.left: name.left
        color: "#808080"
        font.pixelSize: 14
        text: socialName
    }

    property real itemHeight: view.height / 9
    ListView {
        id: view
        anchors.top: avatar.bottom; anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left;  anchors.leftMargin: 10
        anchors.right: parent.right;anchors.rightMargin: 10
        spacing: 2
        clip: true

        model: model
        delegate: delegate
        highlight: highlight

        currentIndex: 0 // 社区
    }

    ListModel {
        id: model
        // 个人信息、绘画、社区、帖子、群聊、关注、好友、收藏、交易、消息等的按钮
        ListElement {text: "我的"; ico: "user.png"}   // 信息、帖子
        ListElement {text: "社区"; ico: "community.png"}
        ListElement {text: "绘画"; ico: "draw.png"}
        ListElement {text: "聊天"; ico: "chat.png"}   // 群聊、好友
        ListElement {text: "关注"; ico: "apply.png"}
        // ListElement {text: "收藏"; ico: "booktag.png"}
        // ListElement {text: "喜欢"; ico: "likes.png"}
        ListElement {text: "消息"; ico: "letter.png"}
        ListElement {text: "交易"; ico: "trade.png"}
    }

    Component{
        id: delegate
        Rectangle {
            required property string text
            required property string ico
            required property int index

            property real minHeight: 30
            property real maxHeight: 50

            property color defaultColor: "#ffffff"
            property color hoveredColor: "#f8f8f8"
            property color focusedColor: "#e8e8e8"

            width: view.width
            height: (navigationSidebar.itemHeight < minHeight) ? minHeight :
                        ((navigationSidebar.itemHeight > maxHeight) ? maxHeight :
                                navigationSidebar.itemHeight)
            radius: height / 3

            Rectangle {
                id: mask
                anchors.fill: parent
                radius: parent.radius
                color: parent.focusedColor
                opacity: (view.currentIndex === parent.index) ? 0.8 : 0
            }

            Icon {
                id: icon
                anchors.left: parent.left;  anchors.leftMargin: parent.width / 24 * 7
                anchors.verticalCenter: parent.verticalCenter
                ico: parent.ico
            }

            Text {
                id: txt
                anchors.left: icon.right;   anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                font.bold: (view.currentItem.y === parent.y) ? true : false

                text: parent.text
            }

            HoverHandler {
                onHoveredChanged: {
                    if (hovered)
                        parent.color = parent.hoveredColor
                    else
                        parent.color = parent.defaultColor
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    if (view.currentIndex !== parent.index)
                    {
                        view.currentIndex = parent.index
                        navigationSidebar.switchTo(parent.index)
                    }
                }
            }
        }
    }

    function switchTo(index)
    {
        switch(index) {
        case 0: toPage("home"); break;
        case 1: toPage("community"); break;
        case 2: toPage("draw"); break;
        case 3: toPage("chat"); break;
        case 4: toPage("apply"); break;
        case 5: toPage("letter"); break;
        case 6: toPage("trade"); break;
        }
    }
}
