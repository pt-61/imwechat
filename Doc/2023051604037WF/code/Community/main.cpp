#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./Transport/transport.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Transport>("Community", 1, 0, "Transport");
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
