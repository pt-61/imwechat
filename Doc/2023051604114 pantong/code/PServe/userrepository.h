#pragma once
#include <map>
#include <mutex>
#include <string>
#include "Singleton.h"
#include "user.h"
#include <iostream>

class UserRepository : public Singleton<UserRepository>
{
    friend class Singleton<UserRepository>;

public:
    bool SaveUser(const User &user);
     bool IsValidUser(const std::string SocialName,const std::string password);
    bool Remove(const User &user);
    bool IsUser(const User &user);
    std::string Uid(const std::string SocialName);
    std::string Username(const std::string SocialName);
private:
    UserRepository();
    std::map<std::string, User> UserMap_;
    std::mutex UserMutex_;
};
