import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    anchors.fill: parent

    property string serverHost: "127.0.0.1"
    property int serverPort: 8888


    Component.onCompleted: {
        if (!tcpclient) {
            msgDisplay.append("客户端对象未初始化！");
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // 服务器信息 + 连接按钮
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            Label {
                text: "服务器：" + serverHost + ":" + serverPort
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                font.pointSize: 10
                color: "#666"
            }

            Button {

                text: tcpclient && tcpclient.connected ? "断开连接" : "连接服务器"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.preferredWidth: 100
                onClicked: {
                    if (!tcpclient) return;
                    if (tcpclient.connected) {
                        tcpclient.disconnectServer();
                    } else {
                        tcpclient.connectServer();
                    }
                }
            }
        }

        //  消息显示区域（
        TextArea {
            id: msgDisplay
            Layout.fillWidth: true
            Layout.fillHeight: true
            readOnly: true
            font.pointSize: 12
            color: "#333"
            placeholderText: "消息显示区...\n1. 点击【连接服务器】接入聊天\n2. 输入消息后点击【发送】或按回车"
            ScrollBar.vertical: ScrollBar {
                    id: scrollBar
                    policy: ScrollBar.AlwaysOn  // 始终显示滚动条
                }

                // 控制滚动条位置
                onTextChanged: {
                    scrollBar.position = 1.0;
                }
        }

        //  消息输入 + 发送按钮
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            spacing: 5

            TextField {
                id: msgInput
                Layout.fillWidth: true
                placeholderText: "输入聊天消息..."
                enabled: tcpclient && tcpclient.connected
                Keys.onEnterPressed: sendBtn.clicked()
                Keys.onReturnPressed: sendBtn.clicked()
            }

            Button {
                id: sendBtn
                text: "发送"
                Layout.preferredWidth: 70
                enabled: tcpclient && tcpclient.connected && msgInput.text.trim() !== ""
                onClicked: {
                    if (!tcpclient) return;
                    tcpclient.sendMsg(msgInput.text.trim());
                    msgDisplay.append("【我】：" + msgInput.text.trim());
                    msgInput.text = "";
                }
            }
        }
    }

    // 绑定tcpclient信号（安全判断）
    Connections {
        target: tcpclient
        enabled: !!tcpclient // 仅当tcpclient存在时启用

        function onNewMessage(msg) {
            msgDisplay.append(msg);
        }

        function onConnectedChanged(isConnected) {
            if (isConnected) {
                msgDisplay.append("已连接到 " + serverHost + ":" + serverPort);
            } else {
                msgDisplay.append("已断开与服务器的连接");
            }
        }
    }
}
