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

public slots:
    Q_INVOKABLE void connectServer();
    Q_INVOKABLE void deliverPost(const QVariantMap& post);

    /// @param id 若是用户id,则获取用户的;没有则为刷新操作,获取帖子
    Q_INVOKABLE void fetchPost(QString id = "");

signals:
    void connected();
    void newMessage(const QString& msg);
    void newPost(const QVariantMap& post);


private:
    QTcpSocket *socket {};
};
