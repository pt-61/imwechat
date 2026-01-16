import QtQuick
import QtQuick.Controls
import "../Common"

Rectangle {
    id: postList
    // anchors.fill: parent // 交给StackView控制

    property bool showSuspender: true

    // to outside
    signal seePost(post: var)
    signal wantToPost
    signal loadMore
    signal refresh

    // from outside
    signal getNew(post: var)

    onShowSuspenderChanged: {
        if (showSuspender) spd.open()
        else spd.close()
    }

    PostHeader {
        id: ph
        onWantToPost: parent.wantToPost()
    }

    ListView {
        id: view
        anchors.top: ph.bottom;
        anchors.left: parent.left;  anchors.right: parent.right
        anchors.bottom: parent.bottom

        model: 0
        delegate: PostItem {
            required property int index
            onClicked: {
                seePost(postModel.get(index))
            }
        }

        footer: Rectangle {
            id: tip
            property string tips: "~加载更多~"
            anchors.right: parent.right;    anchors.left: parent.left
            height: 50
            Text {
                anchors.centerIn: parent
                color: "#64B5F6"
                font.pixelSize: 16
                // font.italic: true
                font.bold: true
                text: tips
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Tip")
                }
            }

        }
    }

    ListModel {
        id: postModel

        ListElement {
            // post woner
            property string uid: "u000000520"

            // for post
            pid: "p000000001"
            title: "OvO"
            avatar: "picture/default/headPortrait.jpg"
            name: "Niya"
            socialName: "@niya"
            content: "This is content"
            date: 1704725594000     // ms
            imgs: '../picture/default/headPortrait.jpg,../picture/default/headPortrait.jpg'
            commentNum: 20
            shareNum: 20
            likesNum: 20
            collectNum: 20

            // for info card
            isMe: true
            followed: false
            userIntro: "Cute && Powerful\n\nAlways full of hope!"
        }
    }

    Suspender {
        id: spd
        x: (parent.width - width) / 10 * 9
        y: parent.height - height * 3

        str: "刷新"
        parentItem: parent

        onClicked: parent.refresh()
        onYChanged: {
          y = (y < 40) ? 40 : y
        }
    }

    onHeightChanged: {
        Qt.callLater(() => {
            spd.x = width - spd.width * 2
            spd.y = height - spd.height * 3
        })
    }

    Component.onCompleted: {
        view.model = postModel
        spd.open()
    }

    onGetNew: post => {
        postModel.append({
            uid: post.uid,
            pid: post.pid,
            title: post.title,
            avatar: post.avatar,
            name: post.name,
            socialName: post.socialName,
            content: post.content,
            date: post.date,
            imgs: post.imgs,
            commentNum: post.commentNum,
            shareNum: post.shareNum,
            likesNum: post.likesNum,
            collectNum: post.collectNum,

            isMe: post.isMe,
            followed: post.followed,
            userIntro: post.userIntro
        })
    }

}
