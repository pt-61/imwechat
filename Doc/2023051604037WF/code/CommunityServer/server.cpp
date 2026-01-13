#include "server.h"
#include "./ui_server.h"

#include <QDateTime>

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
        ui->state->setText("未运行");
    }
    else
    {
        quint16 port = ui->port->text().toInt();
        if (server->listen(QHostAddress::Any, port))
        {
            connect(server, &QTcpServer::newConnection, this, &Server::handleNewConnection);
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

    ui->clientList->addItem(clientIP + " " + clientPort + dt.toString("yy-MM-dd hh:mm:ss"));
}
