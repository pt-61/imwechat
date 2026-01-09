/*
帖子列表
展现不同的帖子，展示帖子的大概信息
*/
import QtQuick

Rectangle {
    id: postList
    width: 450
    clip: true
    border.color: "#f2f2f2"
    border.width: 1

    ListView {
        id: view
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        model: model
        spacing: 1

        delegate: PostItem {}
    }

    ListModel {
        id: model
        ListElement {
            avatarImg: "picture/default/headPortrait.jpg"
            userName: "ShaJian"
            userEmail: "2020520@qq.com"
            postContent: "The streets of Kheezwara are fairly safe, but not always clean"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
        }
        ListElement {
            avatarImg: "picture/default/headPortrait.jpg"
            userName: "ANIKI"
            userEmail: "fightpower66@xm.com"
            postContent: "The streets of Kheezwara are fairly safe, but not always clean"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
        }
        ListElement {
            avatarImg: "picture/default/headPortrait.jpg"
            userName: "ANIKI"
            userEmail: "fightpower66@xm.com"
            postContent: "The streets of Kheezwara are fairly safe, \n\n\nbut \nnot\n always \nclean"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
        }
        ListElement {
            avatarImg: "picture/default/headPortrait.jpg"
            userName: "ANIKI"
            userEmail: "fightpower66@xm.com"
            postContent: "The streets of Kheezwara are fairly safe, but not always clean"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
        }
    }

}
