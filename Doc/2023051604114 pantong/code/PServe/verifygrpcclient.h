#pragma once

#include <grpcpp/grpcpp.h>
#include "message.grpc.pb.h"
#include "const.h"
#include "Singleton.h"

using grpc::Channel;
using grpc::Status;
using grpc::ClientContext;

using message::GetVarifyReq;
using message::GetVarifyRsp;
using message::VarifyService;

class RPConPool
{
public:
    RPConPool(size_t poolSize, std::string host, std::string port)
        : poolSize_(poolSize)
        , host_(host)
        , port_(port)
        ,b_stop_(false)
    {
        //指向服务器的地址
        std::shared_ptr<Channel> channel = grpc::CreateChannel(host_ + ":" + port_, grpc::InsecureChannelCredentials());
        _connctions.push(VarifyService::NewStub(channel));
    }
    ~RPConPool()
    {
        //智能锁只有退出函数才销毁锁
        std::lock_guard<std::mutex> lock(mutex_);
        Close();
        while (!_connctions.empty()) {
            _connctions.pop();
        }
    }

    void Close()
    {
        b_stop_ = true;
        cond_.notify_all();
    }

    std::unique_ptr<VarifyService::Stub> getconnection()
    {
        //使用了智能锁
        std::unique_lock<std::mutex> lock(mutex_);
        //wait中开锁
        cond_.wait(lock, [this] {
            if (b_stop_) {
                return true;
            }
            return !_connctions.empty();
        });

        if (b_stop_ || _connctions.empty()) {
            return nullptr;
        }

        auto context = std::move(_connctions.front());
        _connctions.pop();
        return context;  // 使用移动语义返回
    }

    void returnconnection(std::unique_ptr<VarifyService::Stub>context){
        std::lock_guard<std::mutex> lock(mutex_);
        if (b_stop_) return ;

        _connctions.push(std::move(context));
        cond_.notify_one();
    }
private:
    //原子操作
    std::atomic<bool> b_stop_;
    size_t poolSize_;
    std::string host_;
    std::string port_;
    std::condition_variable cond_;
    std::mutex mutex_;
    std::queue<std::unique_ptr<VarifyService::Stub>> _connctions;
};


class VerifyGrpcClient:public Singleton<VerifyGrpcClient>
{
    friend class Singleton;
public:

    GetVarifyRsp GetVarifyCode(std::string email)
    {


        ClientContext context;
        GetVarifyRsp reply;
        GetVarifyReq request;
        //接收方邮箱
        request.set_email(email);
        auto stub = pool_->getconnection();
        Status staus = stub->GetVarifyCode(&context, request, &reply);
        if (staus.ok()) {
            pool_->returnconnection(std::move(stub));
            return reply;
        }
        else {
            std::cerr << "RPC调用失败："
                      << "错误码=" << staus.error_code()
                      << "，错误信息=" << staus.error_message()
                      << "，错误详情=" << staus.error_details() << std::endl;
            pool_->returnconnection(std::move(stub));
            reply.set_error(ErrorCodes::RPCFailed);
            std::cout << "mei you youxiang";
            return reply;
        }
    }

private:
    VerifyGrpcClient();
    std::unique_ptr<RPConPool> pool_;
};
