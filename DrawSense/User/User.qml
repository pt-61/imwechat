import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import "../Post"

ListView {
    id: userView
    anchors.fill: parent

    // 获取帖子，每次获取10个 ==> loadPost(var postlist) 加载帖子
    signal fetchPost
    signal fetchComment
    signal fetchLike
    signal fetchCollect

    property bool allPost: false
    property bool allLike: false
    property bool allComment: false
    property bool allCollect: false

    spacing: 1
    clip: true

    header: InfoPage {
        id:info
        onSeePost: {
            console.log("see Post")
            // if (postModel.count === 0)
            //     view.fetchPost();
            userView.model = postModel
        }
        onSeeComment:  {
            console.log("see Comment")
            userView.model = commentModel
        }
        onSeeLike: {
            console.log("see Likes")
            userView.model = likeModel
        }
        onSeeCollect: {
            console.log("see Collect")
            userView.model = collectModel
        }
    }
    footer: Rectangle {
        id: tip
        property string tips: "~已经到底啦~"
        anchors.right: parent.right;    anchors.left: parent.left
        height: 50
        Text {
            anchors.centerIn: parent
            color: "#64B5F6"
            font.pixelSize: 16
            font.italic: true
            text: tips
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                userView.fetchPost()
            }
        }
    }
    Flickable {
        boundsBehavior: Flickable.StopAtBounds
    }

    /* very imporatnt */
    // 延迟加载model， 使 info 正常显示
    model: 0
    Component.onCompleted: {
        // console.log(headerItem.height)
        model = postModel
        // userView.fetchPost()
    }
    delegate: PostItem {}

/********************   posts  **********************/
    ListModel {
        id: postModel
        ListElement {
            avatar: "picture/default/headPortrait.jpg"
            name: "Niya"
            socialName: "@Niya"
            content: "The streets of Kheezwara are fairly safe, but not always clean"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
            collectNum: 20
        }
        ListElement {
            avatar: "picture/default/headPortrait.jpg"
            name: "Niya"
            socialName: "@Niyam"
            content: "The streets of Kheezwara are fairly safe, \n\n\nbut \nnot\n always \nclean"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
            collectNum: 20
        }
    }

    ListModel {
        id: commentModel

        ListElement {
            avatar: "picture/default/headPortrait.jpg"
            name: "Niya"
            socialName: "@Niya"
            content: "This is a comment"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
            collectNum: 20
        }
    }

    ListModel {
        id: likeModel

        ListElement {
            avatar: "picture/default/headPortrait.jpg"
            name: "Niya"
            socialName: "@Niya"
            content: "Hi, you!"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 20
            shareNum: 20
            likesNum: 20
            collectNum: 20
        }
    }

    ListModel {
        id: collectModel

        ListElement {
            avatar: "picture/default/headPortrait.jpg"
            name: "Niya"
            socialName: "@Niya"
            content: "Nice to meet you~\n\nI am always here for you~"

            // required property var tags
            // postDate: new Date("2026-01-08 20:13:14")

            commentNum: 5
            shareNum: 20
            likesNum: 1314
            collectNum: 20
        }
    }

/******************   functions  ********************/
    function loadPost(postlist)
    {
        for(var i=0; i<postlist.length; ++i)
        {
            console.log("post piece: ", i+1)
            var post = postlist[i]
            postModel.append({
                    avatar: post.avatar,
                    name: post.name,
                    socialName: post.socialName,
                    content: post.content,
                    // tags
                    // postDate
                    commentNum: post.commentNum,
                    shareNum: post.shareNum,
                    likesNum: post.likesNum
            })
        }
    }

    function addPost(post)
    {
        console.log(post.avatar)
        postModel.append({
            avatar: post.avatar,
            name: post.name,
            socialName: post.socialName,
            content: post.content,
            // tags
            // postDate
            commentNum: post.commentNum,
            shareNum: post.shareNum,
            likesNum: post.likesNum,
            collectNum: post.collectNum
        })
    }

    function loadComment(commentlist)
    {

    }

    function loadLike(likelist)
    {

    }

    function loadCollect(collectlist)
    {

    }
}
