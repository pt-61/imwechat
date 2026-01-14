#pragma once
#include"const.h"

class HttpConnection:public std::enable_shared_from_this<HttpConnection>
{
public:
    friend class UserServerControl;
    HttpConnection(boost::asio::io_context &ioc);
    void Start();
    tcp::socket &GetSocket() { return _socket;
    }
private:
    void CheckDeadLine();
    void WriteResponse();
    void HandleReq();

    tcp::socket _socket;
    beast::flat_buffer _buffer{8192};

    http::request<http::dynamic_body> _request;//客户端
    http::response<http::dynamic_body> _response;//服务端

    net::steady_timer deadline_ { _socket.get_executor(), std::chrono::seconds(60) };
    std::string _get_url;

};
