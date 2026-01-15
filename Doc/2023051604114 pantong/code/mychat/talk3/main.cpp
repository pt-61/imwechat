#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include"UserControl.h"
#include"global.h"
#include"tcpclient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    UserControl register1;
    TcpClient tcpclient;
    engine.rootContext()->setContextProperty("register1", &register1);
    engine.rootContext()->setContextProperty("tcpclient", &tcpclient);
    const QUrl url(QStringLiteral("qrc:/talk3/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);




    return app.exec();
}
