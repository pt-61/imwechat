#pragma once
#include<QString>
#include"const.h"
class UserRepository;

class User
{
    friend class UserRepository;
public:
    User() = default;
    User(std::string socialName, std::string userName,const std::string password)
        : socialName_(socialName)
        , userName_(userName)
        , password_(password)
    {}

    bool isValidUser() const {
         return !userName_.empty() && !socialName_.empty() && password_.length() >= 6;
    }
    bool LoginUser(const std::string SocialName,std::string password);
    bool RegisterUser(const User &user);
    std::string FindUsername(const std::string SocialName);

private:
    std::string userName_;
    std::string socialName_;
    std::string password_;
};
