// 推送界面，可以打开发帖界面
import QtQuick 2.15
import QtQuick.Controls
import Community 1.0 as C

import "../Post"

Rectangle {
    id: pi
    anchors.fill: parent
    clip: true

    property string uid: "u000000520"
    property string name: "Niya"
    property string socialName: "@niya"

    signal piLoadPost
    signal piRefresh
    signal piNewPost
    signal piSeeUser(uid: string)

    signal loadPost(var p)
    signal loadPostEdit

    StackView {
        id: sv
        anchors.fill: parent
        initialItem: PostList {
            onSeePost: p => loadPost(p)
            onWantToPost: loadPostEdit()

            showSuspender: parent.depth === 1
        }

        pushEnter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        pushExit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        popEnter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        popExit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
    }

    C.Transport {
        id: tp

        onConnected: console.log("Connect")
        onDisConnected: console("Disconnect")
    }

    Component.onCompleted: {
        tp.connectServer()
    }

    onLoadPost: p => {
        console.log(p.title)
        var page = sv.push(postPage)
        page.initPost(p)
    }

    onLoadPostEdit: {
        while (sv.depth !== 1)
            sv.pop()
        sv.push(writePostPage)
    }

    Component {
        id: writePostPage

        WritePost{
            onPost: p=> {
                // console.log("wp page", p.title)  // it will print twice
                tp.deliverPostToServer({
                        title: p.title,
                        content: p.content,
                        imgs: p.imgs,
                        uid: uid
                });
            }
        }
    }

    signal initPostPage(var p)
    onInitPostPage: p=> posta.initPost(p)
    Component {
        id: postPage

        Post {
            id: posta
            onSeeUser: uid=> {
                console.log("Post page:", uid)
                piSeeUser(uid)
            }
            onWantToFollow: uid => console.log(uid)
        }
    }
}
