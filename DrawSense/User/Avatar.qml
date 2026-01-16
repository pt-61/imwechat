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
    signal clicked

    Image {
        id: av
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
        source: av
        maskSource: mask
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onEntered: enterTimer.restart()
      onExited: leaveTimer.restart()
      onClicked: parent.clicked()
    }


    // property bool inHere: false
    Timer {
        id: enterTimer
        interval: 1000   // 悬停 1500ms
        repeat: false
        onTriggered: {
          parent.entered()
        }
    }
    Timer {
        id: leaveTimer
        interval: 300   // leave 300ms
        repeat: false
        onTriggered: {
          parent.exited()
        }
    }
}

/*
|-User
 |-this file
|-picture
*/
