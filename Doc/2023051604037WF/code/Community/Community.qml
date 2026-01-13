import QtQuick
import QtQuick.Controls

import Community 1.0 as C

import "./User"
import "./Post"
import "./Sidebar"
import "./Common"
// import "./Transport"

Window {
    width: 960
    height: 540
    visible: true
    title: qsTr("Community")

    // Text {
    //     id: name
    //     x: 10
    //     y: 10
    //     font.pixelSize: 30
    //     text: qsTr("TEXTXTXTXTXTXTXT")
    // }
    // Avatar {
    //     id: avatar
    //     x: 10
    //     y: 10
    //     img: "picture/default/headPortrait.jpg"
    // }

    // Post {
    //     x: 200
    //     // width: 600
    //     anchors.top: parent.top;    anchors.bottom: parent.bottom
    // }

    // WritePost {
    //     x: 200
    //     width: 600
    //     anchors.top: parent.top;    anchors.bottom: parent.bottom
    // }

    NavigationSidebar{
        id: leftSidebar
        width: parent.width / 5

        onToPage: page => {
            // console.log(page)
            rightSidebar.showView(page)
        }
    }
    SearchSidebar{
        id: rightSidebar
        width: parent.width / 5
    }

    Rectangle {
        id: container
        anchors.top: parent.top;    anchors.bottom: parent.bottom
        anchors.left: leftSidebar.right;    anchors.right: rightSidebar.left

        User {
            id: user
            onFetchPost: transport.fetchPost()
        }
        // Component.onCompleted: transport.connectServer()
        // Component.onCompleted: transport.fetchPost();
        Component.onCompleted: {
            transport.deliverPost({
                name: "ShaJian",
                socialName: "WoW",
                age: 100000
            })
        }
    }

    C.Transport {
        id: transport
        onConnected: {
            console.log("OK")
        }
        onNewMessage: msg => console.log(msg)

        onNewPost: post => user.addPost(post)
    }

    // signal ready
    // Timer {
    //     id: tm
    //     interval: 100
    //     onTriggered: parent.ready()
    // }

}
