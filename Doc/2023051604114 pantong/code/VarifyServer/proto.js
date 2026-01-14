//引入Node.js的“路径工具”——就像咱们认路的“导航”
const path =require('path')
//2. 引入gRPC的核心工具——就像“开店的基础工具”
const grpc=require('@grpc/grpc-js')
// 3. 引入proto文件的“翻译工具”——专门翻译“规则纸”的
const protoLoader =require('@grpc/proto-loader')

//查找proto路径
const PROTO_PATH=path.join(__dirname,'message.proto')
//解析proto规则
const packageDefinition =protoLoader.loadSync(PROTO_PATH,{keepCase:true,longs:String,enum:String,defaults:true,oneofs:true})
// 6. 把翻译后的内容，交给gRPC再加工——整理成服务能用的格式
const protoDescriptor=grpc.loadPackageDefinition(packageDefinition)
// 7. 挑出咱们需要的“message”部分——只拿有用的
const message_proto=protoDescriptor.message
//打包给其他文件用
module.exports=message_proto
