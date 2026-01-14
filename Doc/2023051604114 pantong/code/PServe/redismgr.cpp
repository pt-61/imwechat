#include "redismgr.h"
RedisMgr::RedisMgr() {
    auto host = "127.0.0.1";
    auto port = "6379";
    auto pwd = nullptr;
    _con_pool.reset(new RedisConPool(5, host, atoi(port), pwd));
}

RedisMgr::~RedisMgr()
{
    Close();
}


bool RedisMgr::Get(const std::string& key, std::string& value)
{
    auto connect = _con_pool->getConnection();
    if (connect == nullptr) {
        return false;
    }
    auto reply = (redisReply*)redisCommand(connect, "GET %s", key.c_str());
    if (reply == NULL) {
        std::cout << "[ GET  " << key << " ] failed" << std::endl;
        freeReplyObject(reply);
        _con_pool->returnConnection(connect);
        return false;
    }

    if (reply->type != REDIS_REPLY_STRING) {
        std::cout << "[ GET  " << key << " ] failed" << std::endl;
        freeReplyObject(reply);
        _con_pool->returnConnection(connect);
        return false;
    }

    value = reply->str;
    freeReplyObject(reply);

    std::cout << "Succeed to execute command [ GET " << key << "  ]" << std::endl;
    _con_pool->returnConnection(connect);
    return true;
}

bool RedisMgr::Set(const std::string &key, const std::string &value){
    //执行redis命令行
    auto connect = _con_pool->getConnection();
    if (connect == nullptr) {
        return false;
    }
    auto reply = (redisReply*)redisCommand(connect, "SET %s %s", key.c_str(), value.c_str());

    //如果返回NULL则说明执行失败
    if (NULL == reply)
    {
        std::cout << "Execut command [ SET " << key << "  "<< value << " ] failure ! " << std::endl;
        freeReplyObject(reply);
        return false;
    }

    //如果执行失败则释放连接
    if (!(reply->type == REDIS_REPLY_STATUS && (strcmp(reply->str, "OK") == 0 || strcmp(reply->str, "ok") == 0)))
    {
        std::cout << "Execut command [ SET " << key << "  " << value << " ] failure ! " << std::endl;
        freeReplyObject(reply);
        return false;
    }

    //执行成功 释放redisCommand执行后返回的redisReply所占用的内存
    freeReplyObject(reply);
    std::cout << "Execut command [ SET " << key << "  " << value << " ] success ! " << std::endl;
    return true;
}

bool RedisMgr::Auth(const std::string &password)
{
    auto connect = _con_pool->getConnection();
    if (connect == nullptr) {
        return false;
    }
    auto reply = (redisReply*)redisCommand(connect, "AUTH %s", password.c_str());
    if (reply->type == REDIS_REPLY_ERROR) {
        std::cout << "认证失败" << std::endl;
        //执行成功 释放redisCommand执行后返回的redisReply所占用的内存
        freeReplyObject(reply);
        return false;
    }
    else {
        //执行成功 释放redisCommand执行后返回的redisReply所占用的内存
        freeReplyObject(reply);
        std::cout << "认证成功" << std::endl;
        return true;
    }
}



bool RedisMgr::ExistsKey(const std::string &key)
{
    auto connect = _con_pool->getConnection();
    if (connect == nullptr) {
        return false;
    }
    auto reply = (redisReply*)redisCommand(connect, "exists %s", key.c_str());
    if (reply == nullptr || reply->type != REDIS_REPLY_INTEGER ||reply->integer == 0) {
        std::cout << "Not Found [ Key " << key << " ]  ! " << std::endl;
        freeReplyObject(reply);
        return false;
    }
    std::cout << " Found [ Key " << key << " ] exists ! " << std::endl;
    freeReplyObject(reply);
    return true;
}

void RedisMgr::Close()
{
    _con_pool->Close();
}
