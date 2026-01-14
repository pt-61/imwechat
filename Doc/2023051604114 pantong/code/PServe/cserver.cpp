#include "cserver.h"
#include"httpconnection.h"
#include"asioioservicepool.h"

CServer::CServer(boost::asio::io_context &ioc, unsigned short &port,unsigned short chat_port)
    : _ioc(ioc)
    , _acceptor(ioc, tcp::endpoint(tcp::v4(), port))
    ,_chat_acceptor(ioc, tcp::endpoint(tcp::v4(), chat_port))
    , m_chatMutex()
{

}

void CServer::Start()
{
    auto self = shared_from_this();
    auto &io_context = AsioIOServicePool ::GetInstance()->GetIOService();
    std::shared_ptr<HttpConnection> new_con = std::make_shared<HttpConnection>(io_context);
    _acceptor.async_accept(new_con->GetSocket(), [self,new_con](beast::error_code ec) {
        try {
            if (ec) {
                self->Start();
                return;
            }
            new_con->Start();
            //创建新连接，并创建httpconnection类管理这个链接
            //std::make_shared<HttpConnection>(std::move(self->_socket))->Start();
            self->Start();
        }catch(std::exception &exp){

        }
    });
}

void CServer::StartChatAccept()
{
    auto self = shared_from_this();
    auto &io_context = AsioIOServicePool ::GetInstance()->GetIOService();
    std::shared_ptr<TcpChatSession> new_chat_session = std::make_shared<TcpChatSession>(tcp::socket(io_context),
                                                                                        self->m_chatSessions,
                                                                                        self->m_chatMutex);

    _chat_acceptor.async_accept(new_chat_session->GetSocket(), [self, new_chat_session](boost::beast::error_code ec) {
        try {
            if (ec) {
                std::cerr << "[聊天] 接收连接失败: " << ec.message() << std::endl;
                self->StartChatAccept();
                return;
            }

            // 加入会话集合，启动聊天
            std::lock_guard<std::mutex> lock(self->m_chatMutex);
            self->m_chatSessions.insert(new_chat_session);
            new_chat_session->Start();

            self->StartChatAccept();
        } catch (std::exception &exp) {
            std::cerr << "[聊天] 连接异常：" << exp.what() << std::endl;
        }
    });
}
