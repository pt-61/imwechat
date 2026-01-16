#pragma once
#include <boost/asio.hpp>
#include <memory>
#include <unordered_set>
#include <iostream>
#include <string.h>
#include <mutex>

namespace asio = boost::asio;
namespace ip = asio::ip;
using tcp = ip::tcp;

class TcpChatSession : public std::enable_shared_from_this<TcpChatSession>
{
public:
    TcpChatSession(tcp::socket socket, std::unordered_set<std::shared_ptr<TcpChatSession>>& sessions, std::mutex& mutex)
        : m_socket(std::move(socket))
        , m_sessions(sessions)
        , m_mutex(mutex)
    {}


    void Start();

    void Send(const std::string& msg);
    void OnMessage(const std::string& msg);

    std::string GetClientAddr() const;

    tcp::socket& GetSocket() { return m_socket; }

private:
    void DoRead();
    tcp::socket m_socket; // 客户端套接字
    std::unordered_set<std::shared_ptr<TcpChatSession>>& m_sessions; // 所有会话
    std::mutex& m_mutex; // 会话锁
    char m_readBuf[1024] = {0}; // 接收缓冲区
};
