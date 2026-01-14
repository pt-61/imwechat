#include "httpconnection.h"
#include"UserServerControl.h"


HttpConnection::HttpConnection(boost::asio::io_context &ioc)
    : _socket(ioc)
{}

void HttpConnection::Start()
{
    auto self = shared_from_this();
    http::async_read(_socket, _buffer, _request, [self](beast::error_code ec, std::size_t bytes) {
        try {
            if (ec) {
                std::cout << "http read err is" << ec.what() << std::endl;
                return;
            }

            boost::ignore_unused(bytes);
            self->HandleReq();
            self->CheckDeadLine();
        }
        catch (std::exception& exp)
        {
            std::cout << "expection is" << exp.what() << std::endl;
        }
    });
}

void HttpConnection::CheckDeadLine()
{
    auto self = shared_from_this();
    deadline_.async_wait([self](beast::error_code ec) {
        if (!ec) { self->_socket.close(ec);
        }
    });
}

void HttpConnection::WriteResponse()
{
    auto self = shared_from_this();
    _response.content_length(_response.body().size());
    http::async_write(_socket, _response, [self](beast::error_code ec, std::size_t bytes) {
        self->_socket.shutdown(tcp::socket::shutdown_send, ec);
        self->deadline_.cancel();
    });
}

void HttpConnection::HandleReq()
{
    _response.version(_request.version());
    _response.keep_alive(false);

    if (_request.method() == http::verb::post) {
        bool success = UserServerControl::GetInstance()->HandlePost(_request.target(), shared_from_this());
        if (!success) {
            _response.result(http::status::not_found);
            _response.set(http::field::content_type, "text/plain");
            beast::ostream(_response.body()) << "url not found\n";
            WriteResponse();
            return;
        }

        _response.result(http::status::ok);
        _response.set(http::field::server, "Gate");
        WriteResponse();
        return;
    }
}

