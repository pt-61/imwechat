import QtQuick
import QtQuick.Controls

import Community 1.0 as C

import "./User"
import "./Post"
import "./Sidebar"
import "./Common"

Window {
    id: root
    width: 960
    height: 540
    visible: true
    title: qsTr("画意")

    property string name: "Niya"
    property string uid: "u000000001"
    property string socialNmae: "@niya"
    property string avatar: "picture/default/headPortrait.jpg"

    // 验证用户信息
    C.VerifyUser {
        id: vu
        Component.onCompleted: {
            getUserData()
        }
        onNoUserData:
        {
            console.log("No user data")
        }
        onUserData: ud => {
            name = ud.name
            uid = ud.uid
            socialNmae = ud.socialNmae
        }
    }

    // 导航栏
    NavigationSidebar{
        id: leftSidebar
        width: parent.width / 5

        name: root.name
        socialName: root.socialNmae

        onToPage: page => {
            curPage = page
            rightSidebar.showView(page)
        }
    }
    // 右边栏
    SearchSidebar{
        id: rightSidebar
        width: parent.width / 5
    }

    // 中央内容
    property string curPage: "community"
    Rectangle {
        id: container
        anchors.top: parent.top;    anchors.bottom: parent.bottom
        anchors.left: leftSidebar.right;    anchors.right: rightSidebar.left

        Loader {
            id: pageLoader
            anchors.fill: parent
            source: "./Interface/PushInterface.qml" // 推送界面
        }

        Connections {
            target: pageLoader.item
            function onPiSeeUser(uid)
            {
                curPage = "user"
                if (uid === root.uid)
                {}
                else
                {}

                console.log(uid === root.uid)
            }
        }
    }

    property string lastPage: ""
    onCurPageChanged: {
        lastPage = curPage
        switch(curPage){
            case ("user"): pageLoader.setSource("./User/User.qml");break;
            case ("community"): pageLoader.setSource("./Post/PostList.qml");break;
            // case ("chat"): pageLoader.setSource();break;
        }
    }
}
