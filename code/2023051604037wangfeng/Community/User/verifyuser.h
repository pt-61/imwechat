#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

class VerifyUser : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit VerifyUser(QObject *parent = nullptr);

public:
    /// 获取用户账号数据，用于验证身份
    /// 注册后会存在本地，没有或不全就要求注册或登录
    Q_INVOKABLE void getUserData();

    /// 保存用户数据
    /// 注册或登录后，系统记录用户的账号数据到本地，方便读取验证
    Q_INVOKABLE void saveUserData(const QVariantMap& ud);


signals:
    /// 传递用户账号信息
    void userData(const QVariantMap& ud);
    /// ！没有用户数据
    void noUserData();
};
