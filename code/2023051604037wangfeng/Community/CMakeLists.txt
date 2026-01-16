cmake_minimum_required(VERSION 3.16)

project(Community VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Network)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCommunity
    main.cpp
)

qt_add_qml_module(appCommunity
    URI Community
    VERSION 1.0

    QML_FILES
    Community.qml

    Sidebar/NavigationSidebar.qml
    Sidebar/SearchSidebar.qml
    Sidebar/ChatterSidebar.qml

    User/Avatar.qml
    User/InfoCard.qml
    User/InfoPage.qml
    User/User.qml

    Post/PostItem.qml
    Post/Post.qml
    Post/WritePost.qml
    Post/PostList.qml

    Common/BackHeader.qml
    Common/Icon.qml
    Common/SearchHeader.qml
    Common/ImageCrop.qml
    Common/Suspender.qml
    Common/PostHeader.qml

    Interface/PushInterface.qml

    RESOURCES
    picture/default/headPortrait.jpg
    picture/icons/booktag.png picture/icons/comments.png
    picture/icons/export.png picture/icons/likes.png
    picture/icons/search.png picture/icons/link.png
    picture/icons/back.png
    picture/icons/picture.png
    picture/icons/apply.png picture/icons/back.png
    picture/icons/booktag.png picture/icons/chat.png
    picture/icons/comments.png picture/icons/export.png
    picture/icons/invisible.png picture/icons/letter.png
    picture/icons/likes.png picture/icons/picture.png
    picture/icons/search.png picture/icons/link.png
    picture/icons/user.png picture/icons/visible.png
    picture/icons/apply.png picture/icons/back.png
    picture/icons/booktag.png picture/icons/chat.png
    picture/icons/comments.png picture/icons/community.png
    picture/icons/draw.png
    picture/icons/export.png picture/icons/friends.png
    picture/icons/invisible.png picture/icons/letter.png
    picture/icons/likes.png picture/icons/picture.png
    picture/icons/post.png picture/icons/search.png
    picture/icons/link.png picture/icons/trade.png
    picture/icons/user.png picture/icons/visible.png
    picture/default/background.jpg picture/icons/edit.png
    picture/icons/cancel.png picture/icons/refresh.png
    picture/icons/share.png picture/icons/ellipsis.png
    picture/icons/report.png

    QML_FILES
    scripts/TextUtils.js

    SOURCES
    Struct/exchange.h
    Transport/transport.h Transport/transport.cpp
    Transport/transmit.h Transport/transmit.cpp
    User/verifyuser.h User/verifyuser.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCommunity PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCommunity
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCommunity
    PRIVATE
    Qt6::Quick
    Qt6::Network
    Qt6::Core
)

target_include_directories(appCommunity
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/Transport
        ${CMAKE_CURRENT_SOURCE_DIR}/User
)

include(GNUInstallDirs)
install(TARGETS appCommunity
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
