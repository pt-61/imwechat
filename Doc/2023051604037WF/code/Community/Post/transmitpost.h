#pragma once

#include <QObject>
#include <QQmlEngine>

class TransmitPost : public QObject
{
    Q_OBJECT
    // Q_PROPERTY(PostItem post READ post WRITE setPost NOTIFY postChanged)
    QML_ELEMENT
public:
    explicit TransmitPost(QObject *parent = nullptr);

public:
    /// 要获取的内容
    enum Type
    {
        Post,       /// 帖子
        Comment,    /// 用户的自己评论
        Like,       /// 用户的自己喜欢
        Collect     /// 用户的自己收藏
    };
    Q_ENUM(Type)
    Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged)

    /// 帖子的结构
    struct PostItem
    {
        QString     ownerID     {};     /// 帖主的ID，注册后获得，唯一，不可更改
        QString     avatarImg   {};     /// 帖主头像，为空则可能为自己，用自定义头像，或未注册，用默认头像
        QString     userName    {};     /// 帖主昵称
        QString     socialName  {};     /// 帖主名称，唯一，用于@

        QString     postContent {};     /// 帖子内容
        QDateTime   postDate    {};     /// 发帖日期
        QStringList imgs        {};     /// 包含的图片
            int     commentNum  {};     /// 评论数量
            int     shareNum    {};     /// 分享数量
            int     likesNum    {};     /// 喜欢数量
            int     collectNum  {};     /// 收藏数量
        QString     id          {};     /// 帖子的ID，送到服务器后确定

           bool     liked       {};     /// 已喜欢
           bool     collected   {};     /// 已收藏
    };

    struct Comment
    {
        QString     objPostID   {};     /// 评论帖子的ID
        QString     objUserID   {};     /// 帖主的ID
        QString     objSName    {};     /// 帖主的名称, social name
        PostItem    content     {};     /// 评论内容
    };


public slots:
    /// 从服务器获取用户自己的帖子、评论、喜欢、收藏，一次10个
    /// @param t    帖子的类型
    Q_INVOKABLE void fetchMy(Type t);

    /// 从服务器获取新的帖子，加载到主界面
    /// 帖子相关的图片要放到本地相关文件夹下
    Q_INVOKABLE void fetchPosts();

    /// 从服务器获取对应帖子的评论，一次10个
    /// 评论相关的图片要放到本地相关文件夹下
    Q_INVOKABLE void fetchComments(QString id);

    /// 上传帖子
    /// 转为 json
    /// 若有图片，先上传图片，得到传回来的url后，将url添加到imgs，再上传
    Q_INVOKABLE void uploadPost(QVariant post);

signals:
    /// 从服务器得到用户自己的帖子、评论、喜欢、收藏，后面开始加载
    Q_INVOKABLE void gotMy(Type t, QVariant list);

    /// 删除自己帖子 操作的信号，直接传给服务器
    Q_INVOKABLE void deleteMy(QString id);

    /// 喜欢帖子 操作的信号，直接传给服务器
    Q_INVOKABLE void likePost(QString id);

    /// 取消喜欢帖子 操作的信号，直接传给服务器
    Q_INVOKABLE void unLikePost(QString id);

    /// 收藏帖子 操作的信号，直接传给服务器
    Q_INVOKABLE void collectPost(QString id);

    /// 取消收藏帖子 操作的信号，直接传给服务器
    Q_INVOKABLE void unCollectPost(QString id);

private:
    bool m_loading {};
    Type m_type {};
};
