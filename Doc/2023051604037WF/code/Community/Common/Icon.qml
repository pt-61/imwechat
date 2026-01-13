/*
图标
需要指定图标的文件资源
默认大小为 24 x 24
图标被点击后，会释放一个信号 clicked
*/
import QtQuick

Image {
    required property string ico

    signal clicked

    height: 24
    width: 24
    source: "../picture/icons/" + ico
    fillMode: Image.PreserveAspectFit

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}

