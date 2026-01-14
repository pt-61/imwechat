#include "UserServerControl.h"
#include "httpconnection.h"
#include"verifygrpcclient.h"
#include"redismgr.h"
#include"user.h"
#include"userrepository.h"

UserServerControl::~UserServerControl() {}


void UserServerControl::RegPost(std::string url, HttpHanlder handler)
{
    _post_handles.insert(make_pair(url, handler));
}

bool UserServerControl::HandlePost(std::string path, std::shared_ptr<HttpConnection> connection) {
    if (_post_handles.find(path) == _post_handles.end()) { return false; }
    _post_handles[path](connection);
    return true;
}

UserServerControl::UserServerControl()
{
    //验证
    RegPost("/get_varifycode", [](std::shared_ptr<HttpConnection> connection) {
        //读出客户端的写的内容
        auto body_str = boost::beast::buffers_to_string(connection->_request.body().data());
        std::cout << "recive body is" << body_str << std::endl;
        //告诉对方传输格式
        connection->_response.set(http::field::content_type, "text/json");

        Json::Value root;//回复客户的值
        Json::Reader reader;//解析器
        Json::Value src_root;//存放值

        //解析对面的值
        bool parse_success = reader.parse(body_str, src_root);
        if (!parse_success) {
            std::cout << "Failed to parse Json Data" << std::endl;
            root["error"] = ErrorCodes::Error_Json;
            std::string jsonstr = root.toStyledString();//转化json字符
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }
        if (!src_root.isMember("email")) {//是否有“邮箱”字段
            std::cout << "Failed to parse Json Data" << std::endl;
            root["error"] = ErrorCodes::Error_Json;
            std::string jsonstr = root.toStyledString();
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }

        //取出邮箱的值
        auto email = src_root["email"].asString();
        //调用验证码函数
       VerifyGrpcClient::GetInstance()->GetVarifyCode(email);

        std::cout << "email is" << email<<std::endl;
        root["error"] = 0;
        root["email"] = src_root["email"];
        std::string jsonstr = root.toStyledString();
        beast::ostream(connection->_response.body()) << jsonstr;
        return true;

    });

    //注册
    RegPost("/user_register", [](std::shared_ptr<HttpConnection> connection) {
        auto body_str = boost::beast::buffers_to_string(connection->_request.body().data());
        std::cout << "receive body is " << body_str << std::endl;
        connection->_response.set(http::field::content_type, "text/json");
        Json::Value root;
        Json::Reader reader;
        Json::Value src_root;
        bool parse_success = reader.parse(body_str, src_root);
        if (!parse_success) {
            std::cout << "Failed to parse JSON data!" << std::endl;
            root["error"] = ErrorCodes::Error_Json;
            std::string jsonstr = root.toStyledString();
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }
        if (!src_root.isMember("email") || !src_root.isMember("varifycode")) {
            std::cout << "缺少邮箱或验证码字段！" << std::endl;
            root["error"] = ErrorCodes::Error_Json;
            beast::ostream(connection->_response.body()) << root.toStyledString();
            return true;
        }
        //先查找redis中email对应的验证码是否合理
        std::string  varify_code;
        bool b_get_varify = RedisMgr::GetInstance()->Get(src_root["email"].asString(), varify_code);
        if (!b_get_varify) {
            std::cout << " get varify code expired" << std::endl;
            root["error"] = ErrorCodes::VarifyExpired;
            std::string jsonstr = root.toStyledString();
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }
        std::cout << varify_code;

        if (varify_code != src_root["varifycode"].asString()) {
            std::cout << " varify code error" << std::endl;
            root["error"] = ErrorCodes::VarifyCodeErr;
            std::string jsonstr = root.toStyledString();
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }

        //访问redis查找
        bool b_usr_exist = RedisMgr::GetInstance()->ExistsKey(src_root["username"].asString());
        if (b_usr_exist) {
            std::cout << " user exist" << std::endl;
            root["error"] = ErrorCodes::UserExist;
            std::string jsonstr = root.toStyledString();
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }

        //查找数据库判断用户是否存在

        std::string socialname = src_root["socialname"].asString();
        std::string username = src_root["username"].asString();
        std::string password = src_root["password"].asString();

       User user(socialname, username, password);
        bool isExist = user.RegisterUser(user);
        if (isExist) { std::cout << "注册成功" << std::endl;
        }

        root["error"] = 0;
        root["email"] = src_root["email"];
        root ["username"]= src_root["username"].asString();
        root["confirm"] = src_root["confirm"].asString();
        std::string jsonstr = root.toStyledString();
        beast::ostream(connection->_response.body()) << jsonstr;
        return true;
    });

    RegPost("/user_login", [](std::shared_ptr<HttpConnection> connection) {
        auto body_str = boost::beast::buffers_to_string(connection->_request.body().data());
        std::cout << "receive body is " << body_str << std::endl;
        connection->_response.set(http::field::content_type, "text/json");
        Json::Value root;
        Json::Value src_root;
        Json::Reader reader;
        bool parse_success = reader.parse(body_str, src_root);
        if (!parse_success) {
            std::cout << "Failed to parse JSON data!" << std::endl;
            root["error"] = ErrorCodes::Error_Json;
            std::string jsonstr = root.toStyledString();
            beast::ostream(connection->_response.body()) << jsonstr;
            return true;
        }
        std::string socialname = src_root["socialname"].asString();
        std::string password = src_root["password"].asString();

        User empty;
        std::string username = empty.FindUsername(socialname);
        if (username == "") {
            std::cout << "查无此人" << std::endl;
            return true;
        }
        bool Iiexist = empty.LoginUser(socialname, password);
        if (!Iiexist) {
            std::cout << "登陆失败" << std::endl;
            return true;
        }
        User *user = new User(socialname, username, password);
        root["error"] = 0;
        std::string jsonstr = root.toStyledString();
        beast::ostream(connection->_response.body()) << jsonstr;
        return true;
    });
}
