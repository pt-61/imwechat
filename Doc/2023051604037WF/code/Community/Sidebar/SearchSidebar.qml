import QtQuick
import QtQuick.Controls
import "../Common"

Rectangle {
    id: rightSidebar

    anchors.right: parent.right
    anchors.top: parent.top;    anchors.bottom: parent.bottom
    border.color: "#e0e0e0"

    SearchHeader {
        id: header
    }

    property int currentPage: 0
    function showView(page)
    {
        console.log(page)
        switch(page)
        {
        case "home": {
            currentPage = 0
            break
        }
        case "community": {
            currentPage = 1
            break;
        }
        case "chat": {
            currentPage = 2
            break
        }
        }
    }

    Rectangle {
        id: ct
        anchors.left: parent.left;  anchors.leftMargin: 2
        anchors.right: parent.right;anchors.rightMargin: 2
        anchors.top: header.bottom; anchors.topMargin: 10
        anchors.bottom: parent.bottom
        clip: true

        ListView {
            id: home
            anchors.fill: parent
            opacity: currentPage === 0 ? 1 : 0

            spacing: 2
            model: 20
            delegate: Rectangle {
                required property int index
                color: "red"
                height: 30
                width: 100
            }
        }
        ListView {
            id: group
            anchors.fill: parent
            opacity: currentPage === 1 ? 1 : 0

            spacing: 2
            model: 20
            delegate: Rectangle {
                required property int index
                color: "red"
                height: 30
                width: 100
                Text {
                    anchors.centerIn: parent
                    text: index
                }
            }
        }
        ListView {
            id: friend
            anchors.fill: parent
            opacity: currentPage === 2 ? 1 : 0

            spacing: 2
            model: 5
            delegate: Rectangle {
                color: "blue"
                height: 50
                width: 100
            }
        }
    }



}
