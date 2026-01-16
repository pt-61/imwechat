#include "transport.h"

#include <QDir>
#include <QFile>
#include <QImage>
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

QByteArray Transport::packImage(const QString &url)
{
    QFile img(url);
    if (!img.open(QIODevice::ReadOnly))
        return {};

    QByteArray imageData = img.readAll();

    QJsonObject headerObj{
        {"id", ++orederID},
        {"type", "image"},
        {"uid", "u000000520"},
        {"format", url.split('.').last()},
        {"total", totalImageNum},
        {"current", ++currentImageID}
    };
    QByteArray headerData = QJsonDocument(headerObj).toJson(QJsonDocument::Compact);

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_6_5);

    quint64 totalSize =
        sizeof(quint32) + headerData.size() + imageData.size();

    out << totalSize;
    out << quint32(headerData.size());
    out.writeRawData(headerData.constData(), headerData.size());
    out.writeRawData(imageData.constData(), imageData.size());

    return block;
}

QByteArray Transport::packPost()
{
    QByteArray post {};
    return post;
    QJsonObject headerObj{
        {"id", ++orederID},
        {"type", "post"},
        {"uid", uid},
        {"title", title},
        {"content", content},
    };
    QByteArray headerData = QJsonDocument(headerObj).toJson(QJsonDocument::Compact);

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_6_5);

    quint64 totalSize =
        sizeof(quint32) + headerData.size() + QByteArray().size();
    qDebug() << QByteArray().size();

    out << totalSize;
    out << quint32(headerData.size());
    out.writeRawData(headerData.constData(), headerData.size());
    out.writeRawData(QByteArray(), QByteArray().size());

    return block;
}


void Transport::connectServer()
{
    socket = new QTcpSocket(this);

    QString hostIP {"127.0.0.1"};
    quint16 port {52013};
    socket->connectToHost(QHostAddress(hostIP), port);

    connect(socket, &QTcpSocket::connected, this, &Transport::connected);
    connect(socket, &QTcpSocket::disconnected, this, [&](){emit disConnected();});
    connect(socket, &QTcpSocket::readyRead, this, &Transport::handleServerInfo);
}

void Transport::deliverPostToServer(const QVariantMap& post)
{
    // qDebug() << post["title"].toString() << " " << post["content"].toString();
    QString imgs {post["imgs"].toString()};
    if (lastImages == imgs)     // QML坑太多了，fuck，去掉重复操作
        return;

    lastImages = imgs;
    QStringList arr {imgs.split(',')};
    uid = post["uid"].toString();
    content = post["content"].toString();
    title = post["title"].toString();
    // qDebug () << arr;

    if (imgs.isEmpty())
    {
    }
    else
    {
        currentImageID = 0;
        totalImageNum = arr.length();
        for (int i=0; i<totalImageNum; ++i)
        {
            QUrl url {arr[i]};
            QByteArray tmp = packImage(url.toLocalFile());
            if (tmp.isEmpty())
                continue;
            else
            {
                socket->write(tmp);
            }
            qDebug() << "Write img";
        }
    }
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
    post["collectNum"] = 6;

    emit newPost(post);
}

void Transport::handleServerInfo()
{
    qDebug() << socket->readAll();
    return;

    m_buffer.append(socket->readAll());

    while (true)
    {
        if (m_buffer.size() < sizeof(quint64))
            return;

        QDataStream in(m_buffer);
        in.setVersion(QDataStream::Qt_6_5);

        quint64 totalSize;
        in >> totalSize;

        if (m_buffer.size() < sizeof(quint64) + totalSize)
            return;

        quint32 headerSize;
        in >> headerSize;

        QByteArray headerData(headerSize, Qt::Uninitialized);
        in.readRawData(headerData.data(), headerSize);

        QJsonObject headerObj =
            QJsonDocument::fromJson(headerData).object();

        if (headerObj["type"].toString() == "image")
        {
            QByteArray imageData(
                totalSize - sizeof(quint32) - headerSize,
                Qt::Uninitialized);
            in.readRawData(imageData.data(), imageData.size());
            handleImage(imageData,
                        headerObj["uid"].toString(),
                        headerObj["format"].toString());
        }
        else if(headerObj["type"].toString() == "imgurl")
        {
            QByteArray imgurl(
                totalSize - sizeof(quint32) - headerSize,
                Qt::Uninitialized);
            in.readRawData(imgurl.data(), imgurl.size());
        }
        else
        {
            qDebug() << "no image";
        }

        m_buffer.remove(0, sizeof(quint64) + totalSize);
    }
}

void Transport::handleImage(const QByteArray &imageData, const QString &uid, const QString &format)
{

}
