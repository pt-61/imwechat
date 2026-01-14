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

    // 获取程序目录 + 拼接config.ini路径（跨平台兼容）
    QString config_path = QDir::toNativeSeparators(
        QCoreApplication::applicationDirPath() + QDir::separator() + "config.ini"
        );

    // 读取INI配置并拼接URL
    QSettings settings(config_path, QSettings::IniFormat);
    QString gate_host = settings.value("GateServer/host").toString().trimmed();
    QString gate_port = settings.value("GateServer/port").toString().trimmed();

    // 核心校验：避免空值拼接无效URL
    if (!gate_host.isEmpty() && !gate_port.isEmpty()) {
        gate_url_prefix = QString("http://%1:%2").arg(gate_host).arg(gate_port);
    }


    return app.exec();
}
