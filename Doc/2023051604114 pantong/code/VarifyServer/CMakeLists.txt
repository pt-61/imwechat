cmake_minimum_required(VERSION 3.10)  # 使用较新版本避免兼容性问题

project(VarifyServer LANGUAGES CXX)

# ============================
# 1. C++ 标准配置
# ============================

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ============================
# 2. Node.js 和 npm 查找配置
# ============================

find_program(NODE_EXECUTABLE node
    HINTS
        "/usr/local/bin"
        "/usr/bin"
        "/opt/homebrew/bin"
        "$ENV{NODE_HOME}/bin"
        "$ENV{ProgramFiles}/nodejs"
    REQUIRED
)

find_program(NPM_EXECUTABLE npm
    HINTS
        "/usr/local/bin"
        "/usr/bin"
        "/opt/homebrew/bin"
        "$ENV{NODE_HOME}/bin"
        "$ENV{ProgramFiles}/nodejs"
    REQUIRED
)

message(STATUS "Found Node.js: ${NODE_EXECUTABLE}")
message(STATUS "Found npm: ${NPM_EXECUTABLE}")

# ============================
# 3. Node.js 项目配置和依赖安装
# ============================

set(NODEJS_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(NODEJS_BUILD_DIR "${CMAKE_BINARY_DIR}")

if(EXISTS "${NODEJS_SOURCE_DIR}/package.json")
    message(STATUS "Found Node.js package.json in ${NODEJS_SOURCE_DIR}")

    # 复制 package.json
    add_custom_command(
        OUTPUT ${NODEJS_BUILD_DIR}/package.json
        COMMAND ${CMAKE_COMMAND} -E make_directory ${NODEJS_BUILD_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy
            ${NODEJS_SOURCE_DIR}/package.json
            ${NODEJS_BUILD_DIR}/package.json
        COMMENT "Copying package.json to build directory"
    )

    # 复制所有.js文件
    file(GLOB JS_FILES "${NODEJS_SOURCE_DIR}/*.js")
    foreach(JS_FILE ${JS_FILES})
        get_filename_component(JS_FILENAME ${JS_FILE} NAME)
        add_custom_command(
            OUTPUT ${NODEJS_BUILD_DIR}/${JS_FILENAME}
            COMMAND ${CMAKE_COMMAND} -E copy
                ${JS_FILE}
                ${NODEJS_BUILD_DIR}/${JS_FILENAME}
            DEPENDS ${JS_FILE}
            COMMENT "Copying ${JS_FILENAME} to build directory"
        )
    endforeach()

    # 复制所有.proto文件
    file(GLOB PROTO_FILES "${NODEJS_SOURCE_DIR}/*.proto")
    foreach(PROTO_FILE ${PROTO_FILES})
        get_filename_component(PROTO_FILENAME ${PROTO_FILE} NAME)
        add_custom_command(
            OUTPUT ${NODEJS_BUILD_DIR}/${PROTO_FILENAME}
            COMMAND ${CMAKE_COMMAND} -E copy
                ${PROTO_FILE}
                ${NODEJS_BUILD_DIR}/${PROTO_FILENAME}
            DEPENDS ${PROTO_FILE}
            COMMENT "Copying ${PROTO_FILENAME} to build directory"
        )
    endforeach()

    # 安装 npm 依赖的自定义目标
    add_custom_target(install_npm_deps
        COMMAND ${NPM_EXECUTABLE} install
        WORKING_DIRECTORY ${NODEJS_BUILD_DIR}
        DEPENDS ${NODEJS_BUILD_DIR}/package.json
        COMMENT "Installing Node.js dependencies with npm"
    )

    # 安装 gRPC-js 和其他必要包
    add_custom_target(install_grpc_js
        COMMAND ${NPM_EXECUTABLE} install @grpc/grpc-js @grpc/proto-loader nodemailer
        WORKING_DIRECTORY ${NODEJS_BUILD_DIR}
        DEPENDS install_npm_deps
        COMMENT "Installing gRPC-js and required packages"
    )

    # 验证安装的包
    add_custom_target(verify_npm_packages
        COMMAND ${NPM_EXECUTABLE} list @grpc/grpc-js @grpc/proto-loader nodemailer
        WORKING_DIRECTORY ${NODEJS_BUILD_DIR}
        DEPENDS install_grpc_js
        COMMENT "Verifying installed Node.js packages"
    )

    message(STATUS "Node.js verification server will be built in: ${NODEJS_BUILD_DIR}")

else()
    message(WARNING "Node.js package.json not found in ${NODEJS_SOURCE_DIR}")
    message(STATUS "Please create a VarifyServer directory with Node.js files")
endif()

# ============================
# 4. C++ 可执行目标配置
# ============================

add_executable(VarifyServer
    main.cpp
    message.proto
    package.json
    package-lock.json
    proto.js
    config.json
    const.js
    config.js
    email.js
    server.js
    redis.js
    # 添加其他 C++ 源文件
)

target_compile_features(VarifyServer PRIVATE cxx_std_23)

# ============================
# 5. 构建后操作 - 启动 Node.js 服务
# ============================

add_custom_command(TARGET VarifyServer POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Node.js Verification Server setup:"
    COMMAND ${CMAKE_COMMAND} -E echo "  - Source directory: ${NODEJS_SOURCE_DIR}"
    COMMAND ${CMAKE_COMMAND} -E echo "  - Build directory: ${NODEJS_BUILD_DIR}"
    COMMAND ${CMAKE_COMMAND} -E echo "  - Node.js executable: ${NODE_EXECUTABLE}"
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "To start the Node.js verification server:"
    COMMAND ${CMAKE_COMMAND} -E echo "  cd ${NODEJS_BUILD_DIR}"
    COMMAND ${CMAKE_COMMAND} -E echo "  ${NODE_EXECUTABLE} verify_server.js"
    COMMENT "Node.js verification server setup instructions"
)

# ============================
# 6. 运行目标（可选）
# ============================

if(EXISTS "${NODEJS_SOURCE_DIR}/package.json")
    add_custom_target(run_node_server
        COMMAND ${NODE_EXECUTABLE} verify_server.js
        WORKING_DIRECTORY ${NODEJS_BUILD_DIR}
        DEPENDS verify_npm_packages
        COMMENT "Starting Node.js verification server"
    )
endif()

# ============================
# 7. 打印配置信息
# ============================

message(STATUS "==========================================")
message(STATUS "VarifyServer Configuration:")
message(STATUS "  - C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  - Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  - Node.js: ${NODE_EXECUTABLE}")
message(STATUS "  - npm: ${NPM_EXECUTABLE}")
message(STATUS "  - Node.js Source: ${NODEJS_SOURCE_DIR}")
message(STATUS "  - Node.js Build: ${NODEJS_BUILD_DIR}")
message(STATUS "==========================================")
