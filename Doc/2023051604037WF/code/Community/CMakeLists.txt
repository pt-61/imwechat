cmake_minimum_required(VERSION 3.16)

project(Community VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCommunity
    main.cpp
)

qt_add_qml_module(appCommunity
    URI Community
    VERSION 1.0

    QML_FILES
    Community.qml
    User/Avatar.qml
    Post/PostItem.qml
    Post/Icon.qml
    Post/PostList.qml
    Post/Post.qml
    Post/WritePost.qml
    User/InfoCard.qml
    Post/Header.qml

    RESOURCES
    picture/default/headPortrait.jpg
    picture/icons/booktag.png picture/icons/comments.png
    picture/icons/export.png picture/icons/likes.png
    picture/icons/search.png picture/icons/share.png
    picture/icons/back.png
    picture/icons/picture.png

    QML_FILES
    scripts/TextUtils.js
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
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appCommunity
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
