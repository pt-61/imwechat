import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Rectangle {
    height: 500
    width: 500
    color: "#f5f5f5"

    Connections{
        target: register1
        function onLoginSuccess(vm){
            const username= vm.username
            const socialname=vm.socialname
            console.log(username,socialname)
        }
    }
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 40
        height: 30
        color: "#ffebee"
        radius: 4

        Text {
            id: error
            anchors.centerIn: parent
            text: qsTr("错误提示")
            color: "#b71c1c"
            visible: false
            font.pixelSize: 14
        }
    }


    ColumnLayout {
        anchors.top: error.parent.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20  // 元素间距
        width: parent.width - 80  // 表单宽度

        // 用户名行
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            Text {
                id: yh
                text: qsTr("用户：")
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }
            TextField {
                id: yhfield
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                height: 30
                placeholderText: qsTr("请输入用户名")
                font.pixelSize: 14
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            Text {
                id: sc
                text: qsTr("唯一名：")
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }
            TextField {
                id: scfield
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                height: 30
                placeholderText: qsTr("请输入唯一名")
                font.pixelSize: 14
            }
        }

        // 邮箱行
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            Text {
                id: yt1
                text: qsTr("邮箱：")
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }
            TextField {
                id: youxiangfield
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                height: 30
                placeholderText: qsTr("请输入邮箱")
                font.pixelSize: 14
            }
        }

        // 密码行
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            Text {
                id: mt
                text: qsTr("密码：")
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }
            TextField{
                id:mimafield
                placeholderText: "请输入密码"
                echoMode: TextField.Password
            }
        }

        // 确认密码行
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            Text {
                id: qt1
                text: qsTr("确认：")
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }
            TextField{
                id:querenfield
                placeholderText: "请输入密码"
                width: 200
                height: 20
                echoMode: TextField.Password
                    }
        }


        // 按钮行
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 20

            Button {
                id: bu1
                text: qsTr("确定")
                width: 80
                height: 35
                onClicked: {
                    error.visible = false

                    // 1. 去除所有输入框的首尾空格
                    const username = yhfield.text.trim()
                    const password = mimafield.text.trim()
                    const confirmPwd = querenfield.text.trim()
                    const email = youxiangfield.text.trim()
                    const socialname=scfield.text.trim()

                    // 2. 逐个校验空值
                    if (username === "") {
                        error.text = qsTr("用户名不能为空！")
                        error.visible = true
                        return
                    }
                    if (email === "") {
                        error.text = qsTr("邮箱不能为空！")
                        error.visible = true
                        return
                    }
                    if (password === "") {
                        error.text = qsTr("密码不能为空！")
                        error.visible = true
                        return
                    }
                    if (confirmPwd === "") {
                        error.text = qsTr("确认密码不能为空！")
                        error.visible = true
                        return
                    }



                    if (password !== confirmPwd) {
                        error.text = qsTr("两次输入的密码不一致！")
                        error.visible = true
                        return
                    }


                    register1.on_sure_btn_cilcked(username,socialname,email,password,confirmPwd)
                    console.log("提交注册：", {
                        username: username,
                        email: email,
                        password: password,
                    })
                    error.text = qsTr("注册成功！")
                    error.color = "#e8f5e9"
                    error.visible = true

                }
            }

            Button {
                id: bu2
                text: qsTr("取消")
                width: 80
                height: 35
                onClicked: {
                    yhfield.text = ""
                    youxiangfield.text = ""
                    mimafield.text = ""
                    querenfield.text = ""
                    error.visible = false
                    log1.visible = true
                     re1.visible = false
                    console.log("取消注册")
                }
            }
        }
    }
}
