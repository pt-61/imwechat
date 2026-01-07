import QtQuick
import "./User"
import "./Post"

Window {
    width: 960
    height: 540
    visible: true
    title: qsTr("Community")

    Avatar {
        id: avatar
        x: 10
        y: 20
        img: "picture/default/headPortrait.jpg"
    }

    PostItem {
        x: 100
        y: 100
        color: "#f0f0f0"
        avatarImg: "picture/default/headPortrait.jpg"
        userName: "ShaJian"
        userEmail: "2020520@qq.com"
        postContent: "The streets of Kheezwara are fairly safe, but not always clean"

        // required property var tags
        postDate: new Date("2026-01-08 20:13:14")

        commentNum: 20
        shareNum: 20
        likesNum: 20
    }
}
