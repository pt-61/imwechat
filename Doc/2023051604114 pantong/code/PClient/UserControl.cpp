 #include "UserControl.h"
#include"httpmgr.h"


UserControl::UserControl(QObject *parent)
    : QObject(parent)
{
    connect(Httpmgr::GetInstance().get(), &Httpmgr::sig_reg_finish, this, &UserControl::slot_red_finish);
     connect(Httpmgr::GetInstance().get(), &Httpmgr::sig_log_finish, this, &UserControl::slot_red_finish);
    initHttpHandlers();
}

void UserControl::on_get_code_cilcked(QString email)
{
    QJsonObject json_obj;
    json_obj["email"] = email;
    Httpmgr::GetInstance()->PostHttpReq(QUrl(gate_url_prefix+"/get_varifycode"),
                                        json_obj,
                                        ReqId::ID_GET_VARIFY_CODE,
                                        Moudles::REGISTERMOD);

}

void UserControl::on_sure_btn_cilcked(QString username,
                                        QString socialname,
                                         QString email,
                                         QString password,
                                         QString confirm,
                                         QString varifycode)
{
    QJsonObject json_obj;
    json_obj["username"] = username;
    json_obj["socialname"] = socialname;
    json_obj["email"] = email;
    json_obj["password"] = password;
    json_obj["confirm"] = confirm;
    json_obj["varifycode"] = varifycode;
    Httpmgr::GetInstance()->PostHttpReq(QUrl(gate_url_prefix + "/user_register"),
                                        json_obj,
                                        ReqId::ID_REG_USER,
                                        Moudles::REGISTERMOD);
}

void UserControl::on_sure_login_cilcked(QString socialname, QString password) {
    QJsonObject json_obj;
    json_obj["socialname"] = socialname;
    json_obj["password"] = password;
    Httpmgr::GetInstance()->PostHttpReq(QUrl(gate_url_prefix + "/user_login"),
                                        json_obj,
                                        ReqId::ID_LOGIN_USER ,
                                        Moudles::LOGINMOD);

}

void UserControl::slot_red_finish(ReqId id, QString res, ErrorCodes err)
{
    if (err != ErrorCodes::SUCCESS) { return; }
    //转换为json文档
    QJsonDocument jsonDoc = QJsonDocument::fromJson(res.toUtf8());
    if (jsonDoc.isNull()) return;

    if (!jsonDoc.isObject()) { return; }
    //object=转化为键值对，id查找map表中的对应请求
    _handlers[id](jsonDoc.object());
    return;
}

void UserControl::initHttpHandlers()
{
    _handlers.insert(ReqId::ID_GET_VARIFY_CODE, [this](const QJsonObject &jsonobj) {
        //取出err为0则成功
        int err = jsonobj["error"].toInt();
        if (err != ErrorCodes::SUCCESS) return;
         auto email = jsonobj["email"].toString();
         qDebug() << "emali is " << email;
    });

    _handlers.insert(ReqId::ID_REG_USER, [this](QJsonObject jsonObj){
        int error = jsonObj["error"].toInt();
        if(error != ErrorCodes::SUCCESS){
            return;
        }
        qDebug()<< " 注册成功 " ;
        emit registerSuccess();
    });

    _handlers.insert(ReqId::ID_LOGIN_USER, [this](QJsonObject jsonObj) {
        int error = jsonObj["error"].toInt();
        if (error != ErrorCodes::SUCCESS) { return; }
        qDebug() << " 登陆成功 ";
        emit loginSuccess();
    });

}
