#pragma once
#include "QtWidgets/qwidget.h"
#include<memory>
#include<iostream>
#include<mutex>
#include<qbytearray.h>
#include<qnetworkreply.h>
#include<QJsonObject>
#include<QDir>
#include<QSettings>

extern std::function<void(QWidget *)> repolish;

enum ReqId{
    ID_GET_VARIFY_CODE=1001,//验证码
    ID_REG_USER=1002,//注册
    ID_LOGIN_USER=1003,
};

enum Moudles{
    REGISTERMOD=0,
    LOGINMOD=1,
};

enum ErrorCodes {
    SUCCESS = 0,
    ERR_JSON = 1,
    ERR_NETWORK = 2,
};


