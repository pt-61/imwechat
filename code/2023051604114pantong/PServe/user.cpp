#include "user.h"
#include "userrepository.h"
bool User::LoginUser(const std::string SocialName,const std::string password)
{
    bool isuser = UserRepository::GetInstance()->IsValidUser(SocialName, password);
    if (isuser) {
        std::cout << "登陆成功" << std::endl;
        return true;
    } else {
        std::cout << "登陆失败" << std::endl;
        return false;
    }
}

bool User::RegisterUser(const User &user)
{
    bool isuser = UserRepository::GetInstance()->IsUser(user);
    if (isuser) {
        isuser = UserRepository::GetInstance()->SaveUser(user);
        if (isuser) {
            std::cout << "注册成功" << std::endl;
            return true;
        }
    }
    std::cout << "注册失败" << std::endl;
    return false;
}

std::string User::FindUsername(std::string SocialName)
{
    std::string username = UserRepository::GetInstance()->Username(SocialName);
    return username;
}
