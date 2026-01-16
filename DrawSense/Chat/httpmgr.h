#pragma once
#include"./Chat/singleton.h"
#include<QObject>
#include<qurl.h>
#include<qnetworkaccessmanager.h>
#include<QJsonObject>
#include<QJsonDocument>

class Httpmgr:public QObject,public Singleton<Httpmgr>,public std::enable_shared_from_this<Httpmgr>
{
    Q_OBJECT
public:
    ~Httpmgr();
    void PostHttpReq(QUrl url, QJsonObject json, ReqId req_id, Moudles mod);
private:
    friend class Singleton<Httpmgr>;
    Httpmgr();
    QNetworkAccessManager _manager;


private slots:
    void slot_http_finsh(ReqId id, QString res, ErrorCodes err, Moudles mod);
signals:
    void sig_http_finish(ReqId id, QString res, ErrorCodes err, Moudles mod);
    void sig_reg_finish(ReqId id, QString res, ErrorCodes err);
    void sig_log_finish(ReqId id, QString res, ErrorCodes err);
};
