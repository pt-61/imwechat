/*
帖子
展示帖子的详细内容：作者、内容、评论
还有各种附带的功能： 鼠标光标悬停在用户头像上，会弹出用户的信息卡片
*/
import QtQuick
import QtQuick.Controls
import "../User"
import "../Common"

Rectangle {
    id: post
    // post woner
    property string uid: "u000000520"
    // post id
    property string pid: "p000000001"

    // post show
    property string title: "Hello, I'm Niya"
    property string avatar: "../picture/default/headPortrait.jpg"
    property string name: "Niya"
    property string socialName: "@Niya"
    property string content: "This \n\nis \n\npost \n\ncontent\n\n\n\n\n\n\n\n\n\n\n\n\nE\nN\nD!"
    property var imgs: ["../picture/default/headPortrait.jpg", "../picture/default/headPortrait.jpg"]

    // info card show
    property bool isMe: false
    property bool followed: false
    property string userIntro: "Cute && Powerful\n\nAlways full of hope!"

    signal back
    signal wantToFollow(uid: string)
    signal cancelFollow(uid: string)
    signal seeUser(uid: string)

    function initPost(p)
    {
        uid = p.uid
        pid = p.pid
        title = p.title
        avatar = "../" + p.avatar           // ddddd/ ///////////////////////////////
        name = p.name
        socialName = p.socialName
        content = p.content
        // commentNum = p.commentNum
        // shareNum = p.shareNum
        // likesNum = p.likesNum
        // collectNum = p.collectNum

        isMe = p.isMe
        followed = p.followed
        userIntro = p.userIntro

        imgModel.clear()
        var arr = p.imgs.split(',')
        for (var val of arr)
        {
            console.log("Post get pic: ", val)
            imgModel.append({img: val});
        }
    }

    // anchors.fill: parent // 交给StackView控制
    color: "#fdfdfd"
    border.color: "#f6f6f6"
    border.width: 1

    BackHeader {
        id: header
        title: parent.title

        onBack: {
            parent.back()
        }
    }
    onBack:
        StackView.view.pop()

    ScrollView {
        anchors.top: header.bottom; anchors.topMargin: 20
        anchors.bottom: parent.bottom
        width: parent.width
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        clip: true

        Column {
            width: parent.width
            spacing: 20

            Rectangle {
                id: avator
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;anchors.rightMargin: 20
                height: 50

                Avatar {
                    id: av
                    anchors.verticalCenter: parent.verticalCenter
                    onEntered: {
                        if (!infoCard.visible)
                            infoCard.open()
                    }
                    onExited:
                    {
                        if (!inCard)
                        infoCard.close()
                    }
                    onClicked: seeUser(uid)

                    avatar: post.avatar
                }
                Text {
                    id: userName
                    anchors.left: av.right; anchors.leftMargin: 6
                    anchors.top: parent.top; anchors.topMargin: 4
                    font.pixelSize: 14
                    font.bold: true

                    text: name
                }
                Text {
                    id: usersname
                    anchors.left: av.right; anchors.leftMargin: 6
                    anchors.bottom: av.bottom; anchors.bottomMargin: 4
                    font.pixelSize: 14

                    text: socialName
                }
            }

            Text {
                id: postContent
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;anchors.rightMargin: 20

                text: content
                wrapMode: Text.Wrap
                font.pixelSize: 16
                color: "#303030"
            }

            Grid {
                id: grid
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.right: parent.right;
                columns: 2
                Component.onCompleted: {
                    imgSize = grid.width / 2
                }

                Repeater {
                    model: imgModel    // var 数组

                    delegate: Rectangle{
                        property string img: modelData
                        width: imgSize
                        height: imgSize
                        radius: width / 8
                        clip: true

                        Image {
                            height: parent.height - 5
                            width: parent.width - 5
                            anchors.centerIn: parent
                            smooth: true
                            source: parent.img
                        }
                    }
                }
            }
        }
    }
    property real imgSize
    ListModel {
        id: imgModel
    }


    // property bool showCard: false
    Timer {
        id: hoverTimer
        interval: 300   // leave 300ms
        repeat: false
        onTriggered: {
            infoCard.close()
        }
    }
    property bool inCard: false
    InfoCard {
        id: infoCard

        isMe: parent.isMe
        followed: parent.followed
        userIntro: parent.userIntro

        onEntered:  {
            inCard = true
            hoverTimer.stop()
        }
        onExited:
        {
            inCard = false
            hoverTimer.restart()
        }

        onWantToFollow: parent.wantToFollow(uid)
        onCancelFollow: parent.cancelFollow(uid)
        onSeeUser: parent.seeUser(uid)
    }
}
