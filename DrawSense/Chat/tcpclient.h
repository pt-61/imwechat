#pragma once

#include <QObject>
#include <QTcpSocket>
#include <QString>


class TcpClient : public QObject
{
    Q_OBJECT
    // 暴露连接状态给QML（true=已连接，false=未连接）
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)

public:
    explicit TcpClient(QObject *parent = nullptr);

    // 获取连接状态
    bool connected() const { return m_connected; }

public slots:
    // QML调用：连接服务器（固定IP=127.0.0.1，端口=8888）
    void connectServer();

    // QML调用：发送消息
    void sendMsg(QString msg);

signals:
    void connectedChanged(bool connected); // 连接状态变化
    void newMessage(QString msg);          // 收到新消息（转发给QML）

private:
    QTcpSocket *m_socket = nullptr;
    bool m_connected = false; // 连接状态标记
};
