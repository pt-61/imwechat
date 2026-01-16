#include "tcpchatsession.h"

void TcpChatSession::Start() {
     DoRead(); // 启动异步读消息
}

void TcpChatSession::Send(const std::string &msg) {
    std::shared_ptr<TcpChatSession> self = shared_from_this();

    auto& sessions = m_sessions;
    auto& mutex = m_mutex;


    asio::async_write(m_socket, asio::buffer(msg),
                      [self, &sessions, &mutex](boost::system::error_code ec, std::size_t len)
                      {
                          if (ec)
                          {
                              std::cerr << "[聊天] 发送失败[" << self->GetClientAddr() << "]: " << ec.message() << std::endl;
                              // 安全删除会话
                              std::lock_guard<std::mutex> lock(mutex);
                              auto it = sessions.find(self);
                              if (it != sessions.end()) {
                                  sessions.erase(it);
                              }
                              // 关闭socket释放资源
                              boost::system::error_code ignore_ec;
                              self->m_socket.shutdown(tcp::socket::shutdown_both, ignore_ec);
                              self->m_socket.close(ignore_ec);
                              return;
                          }
                          std::cout << "[聊天] 消息发送成功，长度：" << len << std::endl;
                      });
}
std::string TcpChatSession::GetClientAddr() const
{
    return m_socket.remote_endpoint().address().to_string() + ":" +
           std::to_string(m_socket.remote_endpoint().port());
}

void TcpChatSession::DoRead()
{

    std::shared_ptr<TcpChatSession> self = shared_from_this();

    auto& sessions = m_sessions;
    auto& mutex = m_mutex;
    char* readBuf = m_readBuf;


    m_socket.async_read_some(asio::buffer(readBuf, sizeof(m_readBuf)),
                             [self, &sessions, &mutex, readBuf](boost::system::error_code ec, std::size_t len)
                             {
                                 if (!ec && len > 0)
                                 {
                                     // 读取到消息，处理并转发
                                     std::string msg(readBuf, len);
                                     self->OnMessage(msg);

                                     // 清空缓冲区，继续读取下一条消息
                                     memset(readBuf, 0, sizeof(m_readBuf));
                                     self->DoRead(); // 递归调用，保持长连接
                                 }
                                 else
                                 {
                                     // 客户端断开连接 - 安全处理
                                     std::cout << "[聊天] 客户端[" << self->GetClientAddr() << "] 断开连接" << std::endl;


                                     std::lock_guard<std::mutex> lock(mutex);
                                     auto it = sessions.find(self);
                                     if (it != sessions.end()) {
                                         sessions.erase(it); // 用迭代器删除，STL安全写法
                                     }


                                     boost::system::error_code ignore_ec;
                                     self->m_socket.shutdown(tcp::socket::shutdown_both, ignore_ec);
                                     self->m_socket.close(ignore_ec);
                                 }
                             });
}

void TcpChatSession::OnMessage(const std::string& msg)
{
    // 构造带客户端标识的消息
    std::string sendMsg = "[" + GetClientAddr() + "]：" + msg;
    std::cout << "[聊天] 转发消息：" << sendMsg << std::endl;

    // 加锁遍历所有会话，转发消息（必须确保m_sessions是所有客户端的集合）
    std::lock_guard<std::mutex> lock(m_mutex);
    for (auto& session : m_sessions)
    {
        // 排除自己，转发给其他客户端
        if (session.get() != this)
        {
            session->Send(sendMsg);
        }
    }
}
