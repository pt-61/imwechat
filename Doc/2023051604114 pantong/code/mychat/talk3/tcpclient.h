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
    explicit TcpClient(QObject *parent = nullptr) : QObject(parent) {

        m_socket = new QTcpSocket(this);
        // 绑定Socket关键信号
        connect(m_socket, &QTcpSocket::connected, this, [=]() {
            m_connected = true;
            emit connectedChanged(true);
            emit newMessage("连接服务器成功！");
        });
        connect(m_socket, &QTcpSocket::disconnected, this, [=]() {
            m_connected = false;
            emit connectedChanged(false);
            emit newMessage("与服务器断开连接！");
        });
        connect(m_socket, &QTcpSocket::readyRead, this, [=]() {
            // 读取服务器消息并转发给QML
            QString msg = QString::fromUtf8(m_socket->readAll());
            emit newMessage(msg);
        });
        connect(m_socket, QOverload<QTcpSocket::SocketError>::of(&QTcpSocket::errorOccurred),
                this, [=](QTcpSocket::SocketError err) {
                    emit newMessage("错误：" + m_socket->errorString());
                    m_connected = false;
                    emit connectedChanged(false);
                });
    }

    // 获取连接状态
    bool connected() const { return m_connected; }

public slots:
    // QML调用：连接服务器（固定IP=127.0.0.1，端口=8888）
    void connectServer() {
        if (m_connected) m_socket->disconnectFromHost();
        m_socket->connectToHost("127.0.0.1", 8888);
    }

    // QML调用：发送消息
    void sendMsg(QString msg) {
        if (!m_connected || msg.trimmed().isEmpty()) return;
        m_socket->write(msg.trimmed().toUtf8()); // 发送UTF-8编码消息
    }

signals:
    void connectedChanged(bool connected); // 连接状态变化
    void newMessage(QString msg);          // 收到新消息（转发给QML）

private:
    QTcpSocket *m_socket = nullptr;
    bool m_connected = false; // 连接状态标记
};
