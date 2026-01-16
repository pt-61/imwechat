#pragma once
#include <QObject>
#include"global.h"

class UserControl : public QObject
{
    Q_OBJECT
public:
    explicit UserControl(QObject *parent = nullptr);

    Q_INVOKABLE void on_sure_btn_cilcked(QString username,
                                         QString socialname,
                                         QString email,
                                         QString password,
                                         QString confirm
                                        );
    Q_INVOKABLE void on_sure_login_cilcked(QString socialname, QString password);

private slots:
    void slot_red_finish(ReqId id, QString res, ErrorCodes err);

signals:
    // 注册成功信号（可以带参数，比如提示文字）
    void registerSuccess();
    void loginSuccess(QVariantMap vm);
private:
    void initHttpHandlers();
    QMap<ReqId, std::function<void(const QJsonObject &)>> _handlers;
};
