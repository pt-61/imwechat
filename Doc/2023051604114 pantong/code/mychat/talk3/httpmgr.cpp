#include "httpmgr.h"



Httpmgr::Httpmgr()
{
    //(2)
    connect(this, &Httpmgr::sig_http_finish, this, &Httpmgr::slot_http_finsh);
}

void Httpmgr::PostHttpReq(QUrl url, QJsonObject json, ReqId req_id, Moudles mod)
{
    //(1)将json转换为网络字节流
    QByteArray data = QJsonDocument(json).toJson();
    //创建请求单获取服务器地址url
    QNetworkRequest request(url);
    //向服务器发送传输的类型及长度
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setHeader(QNetworkRequest::ContentLengthHeader, QJsonDocument(json).toJson().length());
    //是std::enable_shared_from_thi是的成员函数，返回当前对象的指针
    auto self = shared_from_this();
    //通过qt的httpman将请求发出并返回 回执指针
    QNetworkReply *reply = _manager.post(request, data);
    //服务器发送信号触发槽
    QObject::connect(reply, &QNetworkReply::finished, [self, reply, req_id, mod]() {
        if (reply->error() != QNetworkReply::NoError) {
            qDebug() << reply->errorString();
            emit self->sig_http_finish(req_id, "", ErrorCodes::ERR_NETWORK, mod);
            reply->deleteLater();
            return;
        }
        //返回服务器的结果
        QString res = reply->readAll();
        emit self->sig_http_finish(req_id, res, ErrorCodes::SUCCESS, mod);
        reply->deleteLater();
        return;
    });
}

void Httpmgr::slot_http_finsh(ReqId id, QString res, ErrorCodes err, Moudles mod) {
    if(mod==Moudles::REGISTERMOD){
        //注册模块
        emit sig_reg_finish(id,res,err);
    }
    if (mod == Moudles::LOGINMOD) {
        //登陆模块
        emit sig_log_finish(id, res, err);
    }
}

Httpmgr::~Httpmgr() {

}
