#pragma once

#include <QMainWindow>

#include <QJsonArray>
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

    void handleNewData();
    void handleImage(const QByteArray &imageData,
                     const QString &uid,
                     const QString &format);

private:
    Ui::Server *ui;
    QTcpServer *server {};
    QTcpSocket *client {};

    QByteArray m_buffer;     // TCP 缓冲区
    quint64 m_totalSize = 0; // 当前包的总大小

    int count {0};
    int totalImageNum {};
    int currentImageID {};
    QJsonArray imgs {};

    QString uid {};
    QString name {};
    QString socialName {};
};
