const config_modules=require('./config')
const Redis=require('ioredis')

const RedisCli =new Redis({
    host:config_modules.redis_host,
    port:config_modules.redis_port,
    password:config_modules.redis_passwd,
});


RedisCli.on("error",function(err){
    console.log("RedisCli connect error",err);
    //RedisCli.quit();
});

RedisCli.on("connect", function() {
    console.log("RedisCli连接成功！");
});
async function GetRedis(key){
    try{
        const result= await RedisCli.get(key)
        console.log(`GetRedis ${key}：`, result); // 详细日志
        if(result==null){
            console.log('result:','<'+result+'>','this key can not find');
            return null;
        }
        console.log('Result:','<'+result+'>','Get key success!...');
                return result;
    }catch(error){
        console.log('GetRedis error is', error);
        return null;
    }
}


async function QueryRedis(key){
    try{
        const result=await RedisCli.exists(key);
        if(result==0){
            console.log('result','<'+result+'>','this key is null');
            return null;
        }
        console.log('result','<'+result+'>','this key is not null');
        return result;
    }catch(error){
        console.log('Query error is :',error);
        return null;
    }
}

async function SetRedisExpire(key,value,exptime){
    try{
    await RedisCli.set(key,value);
    await RedisCli.expire(key,exptime);
        console.log(`SetRedisExpire ${key}=${value}，过期时间${exptime}秒`);
        return true;
    }catch(error){
        console.log('SetQueryExpire error is :',error);
        return false;
        }
}

function Quit(){
    RedisCli.quit();
}

module.exports={GetRedis,QueryRedis,SetRedisExpire,Quit};
