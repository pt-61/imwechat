import QtQuick

Rectangle {
    required property string ico
    signal clicked
    height: 24
    width: 24

    Image {
        anchors.fill: parent
        anchors.centerIn: parent
        source: "../" + ico
        fillMode: Image.PreserveAspectFit
    }
}

