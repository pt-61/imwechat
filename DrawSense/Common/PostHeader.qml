import QtQuick

Rectangle {
    id: postHeader

    signal wantToPost

    anchors.top: parent.top;
    anchors.left: parent.left;  anchors.leftMargin: 1
    anchors.right: parent.right;anchors.rightMargin: 1
    height: 40

    Text {
        id: label
        anchors.left: parent.left;  anchors.leftMargin: 40
        anchors.bottom: parent.bottom;  anchors.bottomMargin: 10

        font.bold: true
        font.pixelSize: 16
        text: qsTr("为您推荐")
    }
    Rectangle {
        id: furring
        height: 3
        width: label.width + 20
        anchors.bottom: parent.bottom;  anchors.bottomMargin: 1
        anchors.horizontalCenter: label.horizontalCenter

        color: "#64B5F6"
    }

    Icon {
        id: edit
        anchors.right: parent.right;    anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        ico: "edit.png"

        onClicked: wantToPost()
    }

    Rectangle {
        id: cutLine
        anchors.bottom: parent.bottom
        anchors.left: parent.left;  anchors.leftMargin: parent.width / 24
        anchors.right: parent.right;anchors.rightMargin: parent.width / 24

        height: 1
        color: "#c0c0c0"
    }
}
