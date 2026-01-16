#include "server.h"
#include "./ui_server.h"

#include <QDateTime>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

Server::Server(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::Server)
{
    ui->setupUi(this);
    server = new QTcpServer(this);

    connect(ui->switchButton, &QPushButton::clicked, this, &Server::runOrStopServer);
}

Server::~Server()
{
    delete ui;
    delete server;
}

void Server::runOrStopServer()
{
    if (server->isListening())
    {
        server->close();
        ui->switchButton->setText("开启服务器");
        ui->state->setText("未运行");
    }
    else
    {
        quint16 port = ui->port->text().toInt();
        if (server->listen(QHostAddress::Any, port))
        {
            connect(server, &QTcpServer::newConnection, this, &Server::handleNewConnection);
            ui->switchButton->setText("关闭服务器");
            ui->state->setText("正在运行");
        }
    }
}

void Server::handleNewConnection()
{
    // QTcpSocket *client = server->nextPendingConnection();
    client = server->nextPendingConnection();
    QString clientIP {client->peerAddress().toString()};
    QString clientPort {QString::number(client->peerPort())};

    QDateTime dt {QDateTime::currentDateTime()};

    ui->clientList->addItem(clientIP + "\t" + clientPort + dt.toString("  yy-MM-dd hh:mm:ss"));

    connect(client, &QTcpSocket::readyRead, this, &Server::handleNewData);
}

void Server::handleNewData()
{
    // 把新数据追加到缓冲区
    m_buffer.append(client->readAll());

    // 只要缓冲区有数据，就尝试解析完整包
    while (true)
    {
        // -------------------------
        // 1 totalSize 是否已知
        // -------------------------
        if (m_totalSize == 0)
        {
            if (m_buffer.size() < sizeof(quint64))
                return; // 数据不够，等待下次

            // 读取 totalSize
            QDataStream sizeStream(m_buffer);
            sizeStream.setVersion(QDataStream::Qt_6_5);
            sizeStream >> m_totalSize;
        }

        // -------------------------
        // 2 检查整个包是否到齐
        // -------------------------
        if (m_buffer.size() < sizeof(quint64) + m_totalSize)
            return; // 数据不够，等下一次

        // -------------------------
        // 3️ 解析完整包
        // -------------------------
        QByteArray packetData = m_buffer.mid(sizeof(quint64), m_totalSize);
        QDataStream in(packetData);
        in.setVersion(QDataStream::Qt_6_5);

        // 读取 headerSize
        quint32 headerSize = 0;
        in >> headerSize;

        // 读取 header JSON
        QByteArray headerData(headerSize, Qt::Uninitialized);
        if (headerSize > 0)
            in.readRawData(headerData.data(), headerSize);

        QJsonObject headerObj;
        if (!headerData.isEmpty())
            headerObj = QJsonDocument::fromJson(headerData).object();

        QString uid    = headerObj.value("uid").toString();
        QString format = headerObj.value("format").toString();
        QString type   = headerObj.value("type").toString();

        // 读取剩余的 image 数据，如果有
        QByteArray imageData;
        int remaining = packetData.size() - sizeof(quint32) - headerSize;
        if (remaining > 0)
            imageData = packetData.mid(sizeof(quint32) + headerSize, remaining);

        // -------------------------
        // 4 移除已处理的数据
        // -------------------------
        m_buffer.remove(0, sizeof(quint64) + m_totalSize);
        m_totalSize = 0;

        // -------------------------
        // 5️ 处理数据
        // -------------------------
        if (type == "image" && !imageData.isEmpty())
        {
            totalImageNum = headerObj["total"].toInt();
            currentImageID = headerObj["current"].toInt();

            handleImage(imageData, uid, format);
        }
        else
        {
            qDebug() << "Received header only or unknown type:" << headerObj;   // 只有头，或者未知类型
        }
    }
}

void Server::handleImage(const QByteArray &imageData,
                         const QString &uid,
                         const QString &format)
{
    QImage image {QImage::fromData(imageData)};
    QString savePath = QDir::currentPath() + "/images/" + uid;
    QDir().mkpath(savePath);

    QString imgid {QString::number(QDateTime::currentMSecsSinceEpoch())};
    // imgs["imgs"].append
    imgs.append(imgid);
    QString fullPath = savePath + "./" + imgid + "." + format;
    if (!image.save(fullPath))
    {
        qWarning() << "Failed to save image:" << fullPath;
        return;
    }
    qDebug() << "save img ok: " << fullPath;

    if (currentImageID == totalImageNum)
    {
        QJsonObject jo {
            {"id", 10},
            {"type","imgurl"},
            {"imgs", imgs}
        };
        QByteArray ba = QJsonDocument(jo).toJson();
        client->write(ba);
        imgs = QJsonArray();
    }
}



