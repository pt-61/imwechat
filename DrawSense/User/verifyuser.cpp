#include "verifyuser.h"

#include <QDir>
#include <QJsonObject>

VerifyUser::VerifyUser(QObject *parent)
    : QObject{parent}
{}

void VerifyUser::getUserData()
{
    QString filePath = QDir::current().filePath("user/verify/verify.json");
    QFile file(filePath);

    if (!file.exists()) {
        qWarning() << "verify.json not found";
        emit noUserData();
        return;
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file:" << filePath;
        emit noUserData();
        return;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonObject jo {QJsonDocument::fromJson(data).object()};
    if (jo["uid"].isNull() || jo["name"].isNull() || jo["socialName"].isNull())
        emit noUserData();
    else
        emit userData(jo.toVariantMap());
}

void VerifyUser::saveUserData(const QVariantMap &ud)
{
    QDir dir(QDir::currentPath());
    if (!dir.exists("user/verify")) {
        if (!dir.mkpath("user/verify")) {
            qWarning() << "Failed to create directory user/verify";
            return;
        }
    }

    QJsonObject jsonObj {QJsonObject::fromVariantMap(ud)};
    QJsonDocument doc(jsonObj);

    QString filePath = dir.filePath("user/verify/verify.json");
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        qWarning() << "Failed to open file:" << filePath;
        return;
    }

    file.write(doc.toJson(QJsonDocument::Indented));
    file.close();
}
