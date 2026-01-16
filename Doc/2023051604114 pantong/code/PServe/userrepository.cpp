#include"userrepository.h"

bool UserRepository::SaveUser(const User &user)
{
    std::string uid = user.uid_;
     std::string SocialName = user.socialName_;
    std::lock_guard<std::mutex>lock(UserMutex_);

    if (UserMap_.find(uid) != UserMap_.end()) {
        std::cout << "用户" << SocialName << "保存失败";
        return false;
    }
    std::cout << uid;
    UserMap_[uid] = user;
    return true;
}

bool UserRepository::IsValidUser(const std::string SocialName,const std::string password)
{
    std::lock_guard<std::mutex> lock (UserMutex_);

    for (auto it = UserMap_.cbegin(); it != UserMap_.cend(); ++it) {
        if (it->second.socialName_ == SocialName) {
            std::string uid = it->first;
            if (it->second.password_ != password) {
                std::cout << "用户密码错误";
                return false;
            }
            std::cout << "用户" << SocialName << "存在";
            return true;
        }
    }
        std::cout << "用户" << SocialName << "不存在";
        return false;
}

bool UserRepository::Remove(const User &user)
{
    std::lock_guard<std::mutex>lock(UserMutex_);
    std::string uid = user.uid_;
    if (UserMap_.find(uid) == UserMap_.end()) {
        std::cout << "用户不存在";
        return false;
    }
    std::string SocialName = user.socialName_;
    UserMap_.erase(uid);
    std::cout << "用户" << SocialName << "删除";
    return true;
}

bool UserRepository::IsUser(const User &user)
{
    std::lock_guard<std::mutex>lock(UserMutex_);
    std::string uid = user.uid_;
    std::string SocialName = user.socialName_;
    auto it = UserMap_.find(uid);
    if (it == UserMap_.end()) {
        std::cout << "用户" << SocialName  << "是新用户";
        return true;
    }
    std::cout << "用户" << SocialName << "是旧用户";
    return false;
}

std::string UserRepository::Uid(const std::string SocialName) {
    std::lock_guard<std::mutex> lock(UserMutex_);
    for (auto it = UserMap_.cbegin(); it != UserMap_.cend(); ++it) {
        if (it->second.socialName_ == SocialName) {

            return it->first;
        }

    }
    std::cout << "用户不存在";
    return "";
}

std::string UserRepository::Username(const std::string SocialName)
{
    std::lock_guard<std::mutex> lock(UserMutex_);
    for (auto it = UserMap_.cbegin(); it != UserMap_.cend(); ++it) {
        if (it->second.socialName_ == SocialName) {
            std::string username = it->second.userName_;
            return username;
        }
    }
    std::cout << "用户不存在";
    return "";
}

UserRepository::UserRepository() {

}
