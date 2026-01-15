cmake_minimum_required(VERSION 4.1.1)

# C++20/23 模块实验性支持设置
# 注意：这是实验性功能，确保你的编译器支持
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
set(CMAKE_CXX_MODULE_STD ON)

# 修改项目名称为 PServe
project(PServe LANGUAGES CXX)

# 设置 C++ 标准属性
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ============================
# 1. 依赖库配置部分
# ============================


set(MySQLPP_INCLUDE_DIR "/usr/include")
set(MySQLPP_LIBRARY "mysqlpp")
# 查找必需的系统库
find_package(Threads REQUIRED)



# 查找 JSONCPP（用于 JSON 处理）
find_package(PkgConfig REQUIRED)
pkg_check_modules(JSONCPP REQUIRED jsoncpp)

# 查找 Boost（用于文件系统和系统功能）
find_package(Boost REQUIRED COMPONENTS filesystem system)

# 新增：通过 pkg-config 查找 hiredis 库
pkg_check_modules(HIREDIS REQUIRED hiredis)
message(STATUS "Found hiredis: ${HIREDIS_LIBRARIES}")

find_package(Qt6 REQUIRED COMPONENTS Core )

# 查找MySQL C客户端库
find_package(PkgConfig REQUIRED)


# 查找MySQL/MariaDB C客户端库
find_path(MYSQL_INCLUDE_DIR
    NAMES mysql.h
    PATHS /usr/include/mysql
          /usr/include/mariadb
          /usr/include
    PATH_SUFFIXES mysql
)

find_library(MYSQL_LIBRARY
    NAMES mariadb mysqlclient
    PATHS /usr/lib /usr/lib64
)

# 验证找到的头文件和库
if(NOT MYSQL_INCLUDE_DIR)
    message(FATAL_ERROR "mysql.h not found! Please install mariadb-connector-c")
endif()

if(NOT MYSQL_LIBRARY)
    message(FATAL_ERROR "MySQL C client library not found!")
endif()

message(STATUS "MySQL include dir: ${MYSQL_INCLUDE_DIR}")
message(STATUS "MySQL library: ${MYSQL_LIBRARY}")
# ============================================

# ============================
# 2. 创建可执行目标
# ============================

# 修改目标名称为 PServe
add_executable(PServe
    main.cpp
    cserver.h cserver.cpp
    const.h
    httpconnection.h httpconnection.cpp
    UserServerControl.h UserServerControl.cpp
    Singleton.h
    asioioservicepool.h asioioservicepool.cpp
    userrepository.h userrepository.cpp
    user.h user.cpp
    tcpchatsession.h tcpchatsession.cpp
)

# ============================
# 3. 目标属性配置
# ============================

# 启用 C++23 特性
target_compile_features(PServe PRIVATE cxx_std_23)

# 如果使用 C++20 模块，取消注释下面的部分
# target_sources(PServe
#     PRIVATE FILE_SET cxx_modules TYPE CXX_MODULES FILES
#         # math.cppm                  # 模块接口文件
#         # network.cppm
# )

# 设置编译器选项
# target_compile_options(PServe PRIVATE
#     -Wall -Wextra  # 启用警告
#     # -fmodules-ts  # 如果使用 C++20 模块，启用此选项
# )

# ============================
# 4. 头文件包含目录
# ============================

# 包含当前源文件目录（用于 .pb.h 和自定义头文件）
target_include_directories(PServe PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}  # 当前项目目录
    ${JSONCPP_INCLUDE_DIRS}      # JSONCPP 头文件
    ${HIREDIS_INCLUDE_DIRS}      # 新增：hiredis 头文件目录
    ${MYSQL_INCLUDE_DIR}
    ${MySQLPP_INCLUDE_DIRS}


)

# 注意：现代 CMake 推荐使用 target_link_libraries 自动传递包含目录
# 对于导入的目标（如 gRPC::grpc++），它们会自动设置包含目录

# ============================
# 5. 库链接配置
# ============================

# 设置链接变量
set(_PROTOBUF_LIBPROTOBUF protobuf::libprotobuf)
set(_REFLECTION gRPC::grpc++_reflection)
set(_GRPC_GRPCPP gRPC::grpc++)

# 链接所有必需的库
target_link_libraries(PServe PRIVATE


    # Boost 库
    Boost::filesystem     # 文件系统操作
    Boost::system         # 系统功能

    # JSONCPP
    ${JSONCPP_LIBRARIES}

    ${HIREDIS_LIBRARIES}
    ${MySQLPP_LIBRARIES}
    ${MYSQL_LIBRARY}
    # 系统库
    Threads::Threads      # 线程支持
    Qt6::Core
    mysqlpp           # ← 必须添加这一行
        mariadb
    # 可选：其他系统库
    dl                    # 动态加载库（Linux）
    m                     # 数学库
)

# 添加库搜索目录
target_link_directories(PServe PRIVATE ${JSONCPP_LIBRARY_DIRS}
                                        ${HIREDIS_LIBRARY_DIRS}  # 新增：hiredis 库搜索目录



)

# ============================
# 6. 输出和安装配置
# ============================

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# 设置目标属性
set_target_properties(PServe PROPERTIES
    OUTPUT_NAME "pserve"  # 修改可执行文件名称
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin

)

# 安装配置（可选）
# include(GNUInstallDirs)
# install(TARGETS PServe
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
# )

# ============================
# 7. 注意事项和调试信息
# ============================

# 打印配置信息
message(STATUS "项目配置完成:")
message(STATUS "  - C++ 标准: ${CMAKE_CXX_STANDARD}")
message(STATUS "  - 编译器: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  - Boost 版本: ${Boost_VERSION}")
message(STATUS "  - JSONCPP 库: ${JSONCPP_LIBRARIES}")
message(STATUS "  - hiredis 库: ${HIREDIS_LIBRARIES}")  # 新增：打印 hiredis 库信息

# ============================
# 9. 构建后检查
# ============================

# 添加构建后检查步骤
add_custom_command(TARGET PServe POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "构建完成: $<TARGET_FILE:PServe>"
    COMMAND ${CMAKE_COMMAND} -E echo "文件大小:"
    COMMAND ${CMAKE_COMMAND} -E env ls -lh $<TARGET_FILE:PServe>
)
