#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./Transport/transport.h"
#include "./User/verifyuser.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Transport>("Community", 1, 0, "Transport");
    qmlRegisterType<VerifyUser>("Community", 1, 0, "VerifyUser");
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Community", "Community");

    return app.exec();
}
