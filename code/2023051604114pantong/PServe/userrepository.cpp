#include"userrepository.h"

bool UserRepository::SaveUser(const User &user)
{
    std::string SocialName = user.socialName_;
    std::lock_guard<std::mutex>lock(UserMutex_);

    if (UserMap_.find(SocialName) != UserMap_.end()) {
        std::cout << "用户" << SocialName << "保存失败";
        return false;
    }

    UserMap_[SocialName] = user;
    return true;
}

bool UserRepository::IsValidUser(const std::string SocialName,const std::string password)
{
    std::lock_guard<std::mutex> lock (UserMutex_);
    auto it = UserMap_.find(SocialName);
    if (it == UserMap_.end()) {
        std::cout << "用户" << SocialName << "不存在";
        return false;
    }
    if (it->second.password_ != password) {
        std::cout << "用户密码错误";
        return false;
    }

    std::cout << "用户" << SocialName << "存在";
    return true;
}

bool UserRepository::Remove(const User &user)
{
    std::lock_guard<std::mutex>lock(UserMutex_);
    std::string SocialName = user.socialName_;
    if (UserMap_.find(SocialName) == UserMap_.end()) {
        std::cout << "用户" << SocialName << "不存在";
        return false;
    }
    UserMap_.erase(SocialName);
    std::cout << "用户" << SocialName << "删除";
    return true;
}

bool UserRepository::IsUser(const User &user)
{
    std::lock_guard<std::mutex>lock(UserMutex_);
    std::string SocialName = user.socialName_;
    auto it = UserMap_.find(SocialName);
    if (it == UserMap_.end()) {
        std::cout << "用户" << SocialName << "是新用户";
        return true;
    }
    std::cout << "用户" << SocialName << "是旧用户";
    return false;
}

std::string UserRepository::Username(const std::string SocialName)
{
    std::lock_guard<std::mutex> lock(UserMutex_);
    auto it = UserMap_.find(SocialName);
    if (it == UserMap_.end()) {
        std::cout << "用户" << SocialName << "不存在";
        return "";
    }
    std::string username = it->second.userName_;
    return username;
}

UserRepository::UserRepository() {

}
