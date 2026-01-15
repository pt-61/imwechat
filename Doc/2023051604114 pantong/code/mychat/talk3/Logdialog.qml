import QtQuick
import QtQuick.Layouts
import QtQuick.Controls




Rectangle {
        height:300
        width:height
        signal zucebutton()
        Image {
            id:img
            height: parent.height/3
            anchors.top:parent.top
            anchors.left:parent.left
            }
    Rectangle{
        height: parent.height/6
        id:rec1
        anchors.top:img.bottom
        anchors.left: parent.left
        Text {
            id:yonghu
            text: qsTr("用户")
            anchors.left: parent.left
            anchors.top:parent.top
        }
        TextField{
            id:yonghufield
            anchors.left: yonghu.right
            placeholderText: "请输入"
            width: 200
            height: 20
        }
    }
    Rectangle{
        id:rec2
        height: parent.height/6
        anchors.left: parent.left
        anchors.top:rec1.bottom

        Text{
            id:mima
            text:qsTr("密码")
            anchors.left: parent.left
            anchors.top:parent.top
        }
        TextField{
            id:mimafield
            anchors.left: mima.right
            placeholderText: "请输入密码"
            width: 200
            height: 20
        }

    }

    Button{
        id:bu1
        anchors.top: rec2.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width/3
        text: {
            qsTr("登陆")
        }
        onClicked: {
            const username=yonghufield.text.trim()
            const password=mimafield.text.trim()
            register1.on_sure_login_cilcked(username,password)
        }
    }

    Button{
        id:bu2
        anchors.top: bu1.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width/3
        text: {
            qsTr("注册")
        }
        onClicked  : {
            zucebutton()
        }
    }
}

