#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

#include <QTcpSocket>
#include <QHostAddress>
#include <QVariant>

using vm = QVariantMap;

class Transport : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Transport(QObject *parent = nullptr);

private:
    void acceptNew();
    void readPost();
    QByteArray packImage(const QString& url);
    QByteArray packPost();

public slots:
    Q_INVOKABLE void connectServer();

    /// 将新的帖子发送到服务器
    /// 如果包含图片，先传送图片；没有则传送帖子内容
    /// @param post 要发布的帖子内容
    Q_INVOKABLE void deliverPostToServer(const QVariantMap& post);

    /// @param id 若是用户id,则获取用户的;没有则为刷新操作,获取帖子
    Q_INVOKABLE void fetchPost(QString id = "");

    void handleServerInfo();
    void handleImage(const QByteArray &imageData,
                     const QString &uid,
                     const QString &format);

signals:
    void connected();
    void disConnected();
    void newMessage(const QString& msg);
    void newPost(const QVariantMap& post);
    void getImageUrl(const QVariantList& urls);


private:
    QTcpSocket *socket {};
    QByteArray m_buffer {};

    int totalImageNum {};
    int currentImageID {};
    int orederID {};

    QString lastImages {};
    QString content {};
    QString title {};
    QString uid {};
};
