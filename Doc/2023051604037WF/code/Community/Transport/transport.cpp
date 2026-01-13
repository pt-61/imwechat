#include "transport.h"

#include <QJsonObject>

Transport::Transport(QObject *parent)
    : QObject{parent}
{}

void Transport::acceptNew()
{
    // read new data
}

void Transport::readPost()
{
    // read post from data

}

void Transport::connectServer()
{
    socket = new QTcpSocket(this);

    QString hostIP {"127.0.0.1"};
    quint16 port {52013};
    socket->connectToHost(QHostAddress(hostIP), port);

    connect(socket, &QTcpSocket::connected, this, &Transport::connected);
}

void Transport::deliverPost(const QVariantMap& post)
{
    qDebug() << post["name"].toString() << " " << post["socialName"].toString()
             << post["age"].toInt();
    QJsonObject jo = QJsonObject::fromVariantMap(post);
    QJsonDocument jd {jo};
    QByteArray ba = jd.toJson();
    qDebug() << jo << '\n' << ba;

    QJsonDocument ja {QJsonDocument::fromJson(ba)};
    QJsonObject oo {ja.object()};
    qDebug() << oo;

    QVariantMap dd {oo.toVariantMap()};
    qDebug() << dd["name"].toString();
}

void Transport::fetchPost(QString id)
{
    QVariantMap post;
    post["avatar"] = "picture/default/headPortrait.jpg";
    post["name"] = "Niya";
    post["socialName"] = "@Niya";
    post["content"] = "WoW \nMoM \nAvA \nToT";
    post["commentNum"] = 6;
    post["shareNum"] = 6;
    post["likesNum"] = 6;

    emit newPost(post);
}
