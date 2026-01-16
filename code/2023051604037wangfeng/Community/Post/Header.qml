/*
条目： 包含一个返回箭头、当前界面的名称
需要指定界面名称 title
信号 back 在返回箭头点击后释放
*/

import QtQuick

Rectangle {
    id: header
    required property string title

    signal back

    anchors.left: parent.left;  anchors.leftMargin: 2
    anchors.right: parent.right;anchors.rightMargin: 2
    height: 50
    // color: parent.color

    Icon {  // 返回箭头
        id: backIco
        anchors.left: parent.left;  anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        height: 30; width: 30

        ico: "picture/icons/back.png"

        onClicked: parent.back()
    }
    Text {  // 页面名称
        anchors.verticalCenter: backIco.verticalCenter
        anchors.left: backIco.right;    anchors.leftMargin: 30
        font.pixelSize: 22
        font.bold: true

        text: title
    }
}
