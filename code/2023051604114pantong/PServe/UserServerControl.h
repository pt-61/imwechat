#pragma once
#include "const.h"

class HttpConnection;
typedef std::function<void(std::shared_ptr<HttpConnection>)> HttpHanlder;

class UserServerControl : public Singleton<UserServerControl>
{
    friend class Singleton<UserServerControl>;

public:
    ~UserServerControl();
    void RegPost(std::string url, HttpHanlder handler);
    bool HandlePost(std::string,std::shared_ptr<HttpConnection>);
private:
    UserServerControl();
    std::map<std::string, HttpHanlder> _post_handles;
};
