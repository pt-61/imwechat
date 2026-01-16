#include "transmitpost.h"

TransmitPost::TransmitPost(QObject *parent)
    : QObject{parent}
{
    // 连接：从服务器获得数据后，通过信号 gotnew 送出去
    // TODO
}

void TransmitPost::fetchMy(Type t)
{
    // 向服务器请求数据
    // TODO
    m_type = t;
    m_loading = false;
}

void TransmitPost::fetchPosts()
{

}

void TransmitPost::fetchComments(QString id)
{

}

void TransmitPost::uploadPost(QVariant post)
{

}

