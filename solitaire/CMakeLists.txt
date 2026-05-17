cmake_minimum_required(VERSION 3.16)

project(qml-solitaire VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appqml-solitaire
    main.cpp
)

qt_add_qml_module(appqml-solitaire
    URI qml-solitaire
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES card.h card.cpp
        SOURCES foundation.h foundation.cpp
        SOURCES draw.h draw.cpp
        SOURCES tableau.h tableau.cpp
        SOURCES waste.h waste.cpp
        SOURCES gamestate.h gamestate.cpp
        RESOURCES
            images/blueCardBack.svg
            images/clubs/0.svg
            images/diamonds/0.svg
            images/hearts/0.svg
            images/spades/0.svg
            images/clubs/1.svg
            images/diamonds/1.svg
            images/hearts/1.svg
            images/spades/1.svg
            images/clubs/2.svg
            images/diamonds/2.svg
            images/hearts/2.svg
            images/spades/2.svg
            images/clubs/3.svg
            images/diamonds/3.svg
            images/hearts/3.svg
            images/spades/3.svg
            images/clubs/4.svg
            images/diamonds/4.svg
            images/hearts/4.svg
            images/spades/4.svg
            images/clubs/5.svg
            images/diamonds/5.svg
            images/hearts/5.svg
            images/spades/5.svg
            images/clubs/6.svg
            images/diamonds/6.svg
            images/hearts/6.svg
            images/spades/6.svg
            images/clubs/7.svg
            images/diamonds/7.svg
            images/hearts/7.svg
            images/spades/7.svg
            images/clubs/8.svg
            images/diamonds/8.svg
            images/hearts/8.svg
            images/spades/8.svg
            images/clubs/9.svg
            images/diamonds/9.svg
            images/hearts/9.svg
            images/spades/9.svg
            images/clubs/10.svg
            images/diamonds/10.svg
            images/hearts/10.svg
            images/spades/10.svg
            images/clubs/11.svg
            images/diamonds/11.svg
            images/hearts/11.svg
            images/spades/11.svg
            images/clubs/12.svg
            images/diamonds/12.svg
            images/hearts/12.svg
            images/spades/12.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appqml-solitaire PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appqml-solitaire
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appqml-solitaire
    PRIVATE Qt6::Quick

)

include(GNUInstallDirs)
install(TARGETS appqml-solitaire
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
