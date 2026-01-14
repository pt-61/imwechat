#include "verifygrpcclient.h"


VerifyGrpcClient::VerifyGrpcClient() {
    std::string host = "127.0.0.1";
    std::string port = "50051";
    pool_.reset(new RPConPool(5, host, port));
}
