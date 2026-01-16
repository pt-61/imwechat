#include "tcpclient.h"



TcpClient::TcpClient(QObject *parent) : QObject(parent) {

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

void TcpClient::connectServer() {
    if (m_connected) m_socket->disconnectFromHost();
    m_socket->connectToHost("127.0.0.1", 8888);
}

void TcpClient::sendMsg(QString msg) {
    if (!m_connected || msg.trimmed().isEmpty()) return;
    m_socket->write(msg.trimmed().toUtf8()); // 发送UTF-8编码消息
}
