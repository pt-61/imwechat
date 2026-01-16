#pragma once
#include"const.h"
#include"tcpchatsession.h"
class CServer:public std::enable_shared_from_this<CServer>
{
public:
    CServer(boost::asio::io_context &ioc, unsigned short &port,unsigned short chat_port);
    void Start();
    void StartChatAccept();
private:
    tcp::acceptor _acceptor;
    net::io_context &_ioc;
    tcp::acceptor _chat_acceptor;            // 聊天监听
    std::unordered_set<std::shared_ptr<TcpChatSession>> m_chatSessions; // 聊天会话
    std::mutex m_chatMutex;
};
