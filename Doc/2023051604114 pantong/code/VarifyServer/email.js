const nodemailer = require('nodemailer');
const config_module = require("./config")

/**
 * 创建发送邮件的代理
 */
let transport = nodemailer.createTransport({
    host: 'smtp.163.com',
    port: 465,
    secure: true,
    auth: {
        user: config_module.email_user, // 发送方邮箱地址
        pass: config_module.email_pass // 邮箱授权码或者密码
    }
});


// 测试邮件连接（启动时验证）
transport.verify((err, success) => {
    if (err) {
        console.error("邮箱服务器连接失败：", err);
    } else {
        console.log("邮箱服务器连接成功！");
    }
});
/**
 * 发送邮件的函数
 * @param {*} mailOptions_ 发送邮件的参数
 * @returns
 */
function SendMail(mailOptions_){
    return new Promise(function(resolve, reject){
        transport.sendMail(mailOptions_, function(error, info){
            if (error) {
                console.log(error);
                console.log('邮箱服务器连接shibai');
                reject(error);
            } else {
                console.log('邮件已成功发送：' + info.response);
                resolve(info.response)
            }
        });
    })

}

module.exports.SendMail = SendMail
