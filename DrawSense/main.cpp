#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./Transport/transport.h"
#include "./User/verifyuser.h"

#include "./Chat/UserControl.h"
#include "./Chat/global.h"
#include "./Chat/tcpclient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Transport>("Community", 1, 0, "Transport");
    qmlRegisterType<VerifyUser>("Community", 1, 0, "VerifyUser");

    QQmlApplicationEngine engine;
    UserControl register1;
    TcpClient tcpclient;
    engine.rootContext()->setContextProperty("register1", &register1);
    engine.rootContext()->setContextProperty("tcpclient", &tcpclient);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Community", "Community");

    return app.exec();
}
