#include<iostream>
#include"cserver.h"
#include"const.h"
#include"redismgr.h"
#include"verifygrpcclient.h"

#include"userrepository.h"

int main()
{

    try {
        unsigned short port = static_cast<unsigned short>(8080);
        unsigned short chat_port = static_cast<unsigned short>(8888);
        //一个ioc监听客户端
        net::io_context ioc{1};
        boost::asio::signal_set singls(ioc, SIGINT, SIGTERM);
        singls.async_wait([&ioc](const boost::system::error_code &error, int signals_number) {
            if (error) { return; }
            ioc.stop();
        });
        auto server = std::make_shared<CServer>(ioc, port, chat_port);
        server->StartChatAccept();
        server->Start();
        std::cout << "Gateserve listen on port:" << port << std::endl;
        ioc.run();
    } catch (std::exception const &e) {
        std::cerr << "error:" << e.what() << std::endl;
        return EXIT_FAILURE;
    }


    return 0;
}
