/*
  头像
  鼠标悬停时，光标变为手指
  鼠标点击时，释放信号 ==> 若不在用户的信息界面，应该跳转到其信息界面
*/
import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    property string avatar: "../picture/default/headPortrait.jpg"
    width: 50
    height: 50

    signal entered
    signal exited

    Image {
        id: avatar
        anchors.fill: parent
        source: parent.avatar
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: width / 2
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: avatar
        maskSource: mask
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onEntered: parent.entered()
      onExited: parent.exited()
    }
}

/*
|-User
 |-this file
|-picture
*/
