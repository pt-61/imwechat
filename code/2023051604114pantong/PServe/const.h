#pragma once

#include<memory>
#include<iostream>
#include"Singleton.h"
#include<map>

#include <boost/beast/http.hpp>
#include <boost/beast.hpp>
#include <boost/asio.hpp>
#include<json/json.h>
#include<json/value.h>
#include<json/reader.h>
#include<boost/filesystem.hpp>
#include<boost/property_tree/ptree.hpp>
#include<boost/property_tree/ini_parser.hpp>
#include<atomic>
#include<mutex>
#include<queue>
#include"hiredis.h"
#include<cassert>
#include <mysql.h>
#include <mysql++/mystring.h>
#include <mysql++/mysql++.h> // 再包含主头文
#include <unordered_set>

namespace beast = boost::beast;
namespace http = beast::http;
namespace net = boost::asio;
using tcp = boost::asio::ip::tcp;

enum ErrorCodes{
    success=0,
    Error_Json=1001, //json解析失败
    RPCFailed=1002,  //rpc请求c错误
    VarifyExpired=1003,//验证码过期
    UserExist=1005,     //用户已存在
    VarifyCodeErr=1004, //验证码错误
    PasswdErr=1006, //密码错误
    EmailNotMatch=1007, //邮箱不匹配
    UserInVaild=1008,
    DBError=1009,
};
#define CODEPrefix "code_"
