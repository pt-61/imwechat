cmake_minimum_required(VERSION 4.1.1)

#https://github.com/Kitware/CMake/blob/v4.1.1/Help/dev/experimental.rst

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
set(CMAKE_CXX_MODULE_STD ON)

project(talk3 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)




qt_add_executable(apptalk3)

qt_add_qml_module(apptalk3
    URI talk3
    VERSION 1.0
    SOURCES     main.cpp
    QML_FILES   Main.qml
    QML_FILES Logdialog.qml
    QML_FILES Register.qml
    SOURCES UserControl.h
    SOURCES UserControl.cpp
    SOURCES global.h global.cpp
    SOURCES singleton.h
    SOURCES httpmgr.h httpmgr.cpp
    RESOURCES config.ini
    SOURCES tcpclient.h tcpclient.cpp
    QML_FILES TcpClient.qml
)

target_sources(apptalk3
    PRIVATE
        #math.cpp                   # 实现单元
    PRIVATE FILE_SET cxx_modules TYPE CXX_MODULES  FILES
        #math.cppm                  # 接口单元
)

source_group("QML Files" FILES
    Main.qml
)

target_compile_features(apptalk3 PRIVATE cxx_std_23)

target_link_libraries(apptalk3
    PRIVATE
        Qt6::Quick
        Qt6::Network
)

set(CONFIG_FILE "${CMAKE_CURRENT_SOURCE_DIR}/config.ini")

# 仅当`config.ini`存在时执行拷贝（避免构建失败，友好提示）
if(EXISTS "${CONFIG_FILE}")
    add_custom_command(
        TARGET apptalk3
        POST_BUILD
        # 使用CMake内置命令（跨平台兼容，无Shell解析歧义，比直接cp更稳定）
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CONFIG_FILE}"
            "$<TARGET_FILE_DIR:apptalk3>/config.ini"
        # 移除COMMENT，彻底规避解析风险（如需保留，确保无隐形字符+手动输入）
        # COMMENT "Copying config.ini to executable directory"
    )
else()
    message(WARNING "config.ini not found at ${CONFIG_FILE} - please create the configuration file")
endif()

set_target_properties(apptalk3 PROPERTIES
    AUTORCC TRUE                              #  set(CMAKE_AUTORCC ON)
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apptalk3
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS apptalk3
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)



















































# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback behaviour of C++ standard
#qt_add_executable(talk3)  //Creates and finalizes an application target of a platform-specific type.
#This command performs the following tasks:
#    1. Create a CMake target of the appropriate type for the target platform.
#    2. Link the target to the Qt::Core library.
#    3. Handle finalization of the CMake target.

# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback behaviour of C++ standard

# qt_standard_project_setup()  #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)






# cmake_minimum_required(VERSION 3.16)
#
# project(talk3 VERSION 0.1 LANGUAGES CXX)
#
# @if !false
# set(CMAKE_AUTOMOC ON)
# @endif
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
#
# find_package(Qt6 REQUIRED COMPONENTS Quick)
#
# @if false
# @if false
# qt_standard_project_setup(REQUIRES 6.10)
# @else
# qt_standard_project_setup()
# @endif
# @endif
#
# qt_add_executable(apptalk3
#     main.cpp
# )
#
# qt_add_qml_module(apptalk3
#     URI talk3
#     VERSION 1.0
#     QML_FILES
#         Main.qml
# )
#
# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# # If you are developing for iOS or macOS you should consider setting an
# # explicit, fixed bundle identifier manually though.
# set_target_properties(apptalk3 PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apptalk3
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )
#
# target_link_libraries(apptalk3
#     PRIVATE Qt6::Quick
# )
#
# include(GNUInstallDirs)
# install(TARGETS apptalk3
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
