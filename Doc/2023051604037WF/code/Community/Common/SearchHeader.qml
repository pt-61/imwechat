import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Rectangle {
    id: searchHeader

    signal search(string msg)

    anchors.top: parent.top;    anchors.topMargin: 4
    anchors.left: parent.left;  anchors.leftMargin: 1
    anchors.right: parent.right;anchors.rightMargin: 1
    height: 32

    Icon {
        id: searchIcon

        anchors.left: parent.left;  anchors.leftMargin: 9
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.6

        ico: "search.png"

        // onClicked: parent.search()
    }

    TextArea {
        id: textArea
        anchors.left: searchIcon.right;  anchors.leftMargin: 10
        anchors.right: parent.right;anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        height: 30

        clip: true
        cursorVisible: activeFocus  // 只在获得焦点时显示光标

        font.pixelSize: 14
        color: "#303133"
        selectionColor: "#cce5ff"
        selectedTextColor: "#303133"
        wrapMode: TextEdit.NoWrap

        placeholderText: "搜索"

        background: Rectangle {
            anchors.fill: parent
            radius: 10
            color: "#f9f9f9"
            border.width: 1
            border.color: textArea.activeFocus ? "#409eff" : "#dcdfe6"
        }

        // 回车开始搜索
        Keys.onReturnPressed: {
            if (textArea.length !== 0)
                searchHeader.search(textArea.getText(0, textArea.length-1))
            textArea.focus = false
            event.accepted = true
        }
    }
}
