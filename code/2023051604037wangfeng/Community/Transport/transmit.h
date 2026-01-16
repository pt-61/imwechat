// 打包、传输和接收数据
#pragma once

#include <QThread>
#include <QTcpSocket>
#include <QVariant>

class Transmit : public QThread
{
    Q_OBJECT
public:
    explicit Transmit(QThread *parent = nullptr);

public:
    void run() override;

    void transmitPost(const QVariantMap& post);
    void transmitPicture(const QString& url, const QString& uid);
    void loadPicture(const QByteArray& image);

signals:
    void connected();
    void disconnected();

private:
    QTcpSocket *socket {};
    QString uid {};
};
