
const grpc=require('@grpc/grpc-js');
const message_proto =require('./proto');
const const_module= require('./const');
const{v4:uuidv4}=require('uuid');
const emailModule=require('./email');
const redis_module=require('./redis');

//call别人的邮箱在里面
async function GetVarifyCode(call, callback) {
    console.log("1");
    console.log("email is ", call.request.email)
    try{
        let query_res=await redis_module.GetRedis(call.request.email);
        console.log("query is :",query_res);
        let uniqueId=query_res;
        if(query_res==null){
            uniqueId=uuidv4();
            if(uniqueId.length>4){
                uniqueId=uniqueId.substring(0,4);
            }

            let bres=await redis_module.SetRedisExpire(call.request.email,uniqueId,600);
            if(!bres){
                callback(null,{
                    email:
                        call.request.email,error:const_module.Errors.RedisErr });
                return ;
            }
        }

        //uniqueId = uuidv4();
        console.log("uniqueId is ", uniqueId)
        let text_str =  '您的验证码'+ uniqueId +'请0分钟内完成注册'+'我是你的老爹'
        //发送邮件
        let mailOptions = {
            from: '13982164503@163.com',
            to: call.request.email,
            subject: '验证码',
            text: text_str,
        };

        let send_res = await emailModule.SendMail(mailOptions);
        console.log("send res is ", send_res)

        callback(null, { email:  call.request.email,
            error:const_module.Errors.Success
        });


    }catch(error){
        console.log("catch error is ", error)

        callback(null, { email:  call.request.email,
            error:const_module.Errors.Exception
        });
    }

}

function main() {

    //创建grpc服务器对象
    var server = new grpc.Server()

    //添加服务                                                  右边：proto的服务==左边是要在js中调用的函数
    server.addService(message_proto.VarifyService.service, { GetVarifyCode: GetVarifyCode })
    server.bindAsync('0.0.0.0:50051', grpc.ServerCredentials.createInsecure(), () => {
        server.start()
        console.log('grpc server started')
    })
}

main()
