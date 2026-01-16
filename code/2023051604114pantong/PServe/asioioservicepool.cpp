#include "asioioservicepool.h"

AsioIOServicePool::AsioIOServicePool(std::size_t size)
    : _ioservice(size)
    , _works(size)
    , _nextIOService(0)
{
    for (std::size_t i = 0; i < size; i++) {
        _works[i] = std::unique_ptr<Work>(new Work(_ioservice[i].get_executor()));
    }

    for (std::size_t i = 0; i < size; i++) {
        _thread.emplace_back([this, i]() { _ioservice[i].run(); });
    }
}

AsioIOServicePool::~AsioIOServicePool()
{
    stop();
    std::cout << "AsioIOServicePool destruct" << std::endl;
}

boost::asio::io_context &AsioIOServicePool::GetIOService()
{
    auto &serivce = _ioservice[_nextIOService++];
    if (_nextIOService == _ioservice.size()) { _nextIOService = 0; }
    return serivce;
}

void AsioIOServicePool::stop()
{
    for (auto &ioservice : _ioservice) {
        ioservice.stop();  // 对 io_context 调用 stop()
    }
    for (auto &work : _works) {

        work.reset();
    }
    for (auto &t : _thread) {
        t.join();
    }
}
