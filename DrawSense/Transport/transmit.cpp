#include "transmit.h"

#include <QDir>
#include <QFile>
#include <QImage>
#include <QJsonObject>

Transmit::Transmit(QThread *parent)
    : QThread{parent}
{}

void Transmit::run()
{
    socket = new QTcpSocket();

    QString hostIP {"127.0.0.1"};
    quint16 port {52013};
    socket->connectToHost(QHostAddress(hostIP), port);

    connect(socket, &QTcpSocket::connected, this, &Transmit::connected);
    // connect(socket, &QTcpSocket::disconnected, this, [&](){emit disconnected();});
    connect(socket, &QTcpSocket::disconnected, this, &Transmit::disconnected);
}

void Transmit::transmitPost(const QVariantMap &post)
{
    qDebug() << post["title"].toString() << " " << post["content"].toString();
    QVariantList imgs = post["imgs"].toList();

    if (imgs.isEmpty())
    {
    }
    else
    {
        for (int i=0; i<imgs.length(); ++i)
        {
            QUrl url {imgs[i].toUrl()};
            // QByteArray tmp = packImage(url.toLocalFile());
            // if (tmp.isEmpty())
            //     continue;
            // else
            //     if (socket->isValid())
            //     socket->write(tmp);

            QFile img(url.toLocalFile());
            if (!img.open(QIODevice::ReadOnly))
            {
                qDebug() << "Error open img: " << url;
                // return QByteArray();
                img.close();
                continue;
            }
            QByteArray imageData {img.readAll()};
            img.close();

            QImage image {QImage::fromData(imageData)};
            QString savePath = QDir::currentPath() + "/images/";
            QDir().mkpath(savePath);

            QString fullPath = savePath + QString::number(QDateTime::currentMSecsSinceEpoch()) + ".png";
            if (!image.save(fullPath))
            {
                qWarning() << "Failed to save image:" << fullPath;
                return;
            }

            qDebug() << "Image saved:" << fullPath;

            qDebug() << "Write img";
        }
    }
}

void Transmit::transmitPicture(const QString &url, const QString &uid)
{
    QFile img(url);
    if (!img.open(QIODevice::ReadOnly))
    {
        qDebug() << "Error open img: " << url;
        return;
    }
    QByteArray imageData {img.readAll()};
    img.close();

    QJsonObject headerObj;
    headerObj["id"] = 1;
    headerObj["type"] = "image";
    headerObj["uid"] = uid;
    headerObj["format"] = url.split('.').last();

    QByteArray headerData = QJsonDocument(headerObj).toJson();

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_6_5);

    quint64 totalSize = sizeof(quint32) + headerData.size() + imageData.size();
    // size:
    out << totalSize;
    out << quint32(headerData.size());

    block.append(headerData);
    block.append(imageData);

    socket->write(block);
}

void Transmit::loadPicture(const QByteArray &image)
{

}
