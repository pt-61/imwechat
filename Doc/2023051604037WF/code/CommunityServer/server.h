#pragma once

#include <QMainWindow>

#include <QTcpServer>
#include <QTcpSocket>

QT_BEGIN_NAMESPACE
namespace Ui {
class Server;
}
QT_END_NAMESPACE

class Server : public QMainWindow
{
    Q_OBJECT

public:
    Server(QWidget *parent = nullptr);
    ~Server();

private slots:
    void runOrStopServer();
    void handleNewConnection();

private:
    Ui::Server *ui;
    QTcpServer *server {};
    QTcpSocket *client {};
};
