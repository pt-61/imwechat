/*
用户信息页
可以在这里查看、编辑自己的信息
作为 header, 下方展示用户发布的一些信息, 如发布、收藏、喜欢的帖子和评论
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import "../Common"

Rectangle {
    id: infoPgae

    property string name: "Niya"
    property string socialName: "@Niya"
    property string briefIntro: "💖Cute && Powerful💖"
    property string backgroundImg: "../picture/default/background.jpg"

    signal seePost
    signal seeComment
    signal seeLike
    signal seeCollect

    width: parent.width
    height: bg.height + avatar.height / 2 + 5 + userName.height + 5
            + social.height + 15 + introduction.height + 15 + view.height + 1

    Image {
        id: bg
        anchors.top: parent.top
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: width / 4

        smooth: true
        fillMode: Image.PreserveAspectCrop

        source: backgroundImg
    }

    Avatar {
        id: avatar
        anchors.left: parent.left;  anchors.leftMargin: parent.width / 16
        anchors.bottom: bg.bottom;  anchors.bottomMargin: -height / 2

        height: bg.height / 3 * 2
        width: height
    }

    Text {
        id: userName
        anchors.top: avatar.bottom; anchors.topMargin: 5
        anchors.left: avatar.left
        color: "#404040"
        font.pixelSize: 16
        font.bold: true
        text: name
    }

    Text {
        id: social
        anchors.top: userName.bottom;   anchors.topMargin: 5
        anchors.left: userName.left
        color: "#808080"
        font.pixelSize: 14
        text: socialName
    }

    Button {
        id: editInfo
        anchors.right: parent.right;    anchors.rightMargin: 20
        anchors.top: bg.bottom; anchors.topMargin: 10
        height: userName.height + 6
        width: 120

        background: Rectangle {
            height: editInfo.height
            width: editInfo.width
            radius: height / 2
            border.color: "#606060"
            border.width: 1

            Text {
                id: label1
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                font.bold: true
                text: "编辑个人信息"
            }
        }
    }

    Text {
        id: introduction
        anchors.top: social.bottom; anchors.topMargin: 15
        anchors.left: social.left;
        anchors.right: parent.right; anchors.rightMargin: 40

        color: "#404040"
        wrapMode: Text.Wrap
        font.pixelSize: 16

        text: briefIntro
    }

    ListView {
        id: view
        anchors.left: parent.left;  anchors.leftMargin: parent.width / 8
        anchors.right: parent.right;anchors.rightMargin: parent.width / 8
        anchors.top: introduction.bottom;   anchors.topMargin: 15
        // anchors.bottom: cutLine.top
        height: width / 4 / 3

        orientation: ListView.Horizontal
        layoutDirection: Qt.LeftToRight

        model: ListModel {
            ListElement {txt: "帖子"}
            ListElement {txt: "评论"}
            ListElement {txt: "喜欢"}
            ListElement {txt: "收藏"}
        }
        delegate: Rectangle {
            required property string txt
            required property int index
            width: view.width / 4
            height: width / 3

            Text {
                anchors.centerIn: parent
                color: "#808080"
                font.pixelSize: 14
                font.bold: view.currentIndex === parent.index ? true : false
                text: txt
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2

                height: 3
                color: "#64B5F6"
                opacity: view.currentIndex === parent.index ? 1 : 0
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered:  parent.color = "#f8f8f8"
                onExited:   parent.color = "#ffffff"
                onClicked:
                {
                    view.currentIndex = parent.index
                    switchTo(parent.index)
                }
            }
        }
        currentIndex: 0
    }

    property int lastIndex: 0
    function switchTo(index)
    {
        if (index === lastIndex) return
        lastIndex = index

        switch(index) {
        case 0: seePost();break
        case 1: seeComment();break
        case 2: seeLike();break
        case 3: seeCollect();break
        default: console.log("InfoPage switchTo: unkown ", index)
        }
    }

    Rectangle {
        id: cutLine
        anchors.top: view.bottom;
        // anchors.bottom: parent.bottom
        anchors.left: view.left;    anchors.leftMargin: -parent.width / 24
        anchors.right: view.right;  anchors.rightMargin: -parent.width / 24
        height: 1
        color: "#c0c0c0"
    }
}
