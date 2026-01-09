import QtQuick
import "./User"
import "./Post"

Window {
    width: 960
    height: 540
    visible: true
    title: qsTr("Community")

    // Avatar {
    //     id: avatar
    //     x: 10
    //     y: 20
    //     img: "picture/default/headPortrait.jpg"
    // }

    // Post {
    //     x: 200
    //     // width: 600
    //     anchors.top: parent.top;    anchors.bottom: parent.bottom
    // }

    WritePost {
        x: 200
        width: 600
        anchors.top: parent.top;    anchors.bottom: parent.bottom
    }
}
