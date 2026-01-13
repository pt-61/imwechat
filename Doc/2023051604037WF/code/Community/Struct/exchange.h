/*
 * 本文件包含 社区交流 会用到的所有 数据结构定义
 */
#pragma once

#include <QString>

struct SPost
{
    QString     avatar      {};
    QString     name        {};
    QString     socialName  {};
    QString     content     {};

    int         commentNum  {};
    int         shareNum  {};
    int         likeNum     {};
    // int         collectNum  {};
};
