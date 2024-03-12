cmake_minimum_required(VERSION 3.16)

project(UAV_SAR_UpperMonitor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)


set(FLUENTUI_BUILD_EXAMPLES OFF)
set(FLUENTUI_BUILD_STATIC_LIB OFF)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Multimedia)

# list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/.cmake/)
# include(GetGitRevisionDescription)

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES src/*.cpp src/*.h)
foreach(filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND src_files ${filename})
endforeach(filepath)


#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS qml/*.qml)
foreach(filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND ui_files ${filename})
endforeach(filepath)


qt_standard_project_setup()

qt_add_executable(UAV_SAR_UpperMonitor
    main.cpp
    ${src_files}
)

qt_add_qml_module(UAV_SAR_UpperMonitor
    URI UAV_SAR_UpperMonitor
    VERSION 1.0
    QML_FILES ${ui_files}
    RESOURCES res/img/favicon.ico
        res/img/bg_home_header.png
        res/font/SmileySans-Oblique.ttf
        qml/global/qmldir
        cfg/radar.json
    RESOURCE_PREFIX "/"
    )


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(UAV_SAR_UpperMonitor PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.UAV_SAR_UpperMonitor
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(UAV_SAR_UpperMonitor
    PRIVATE Qt6::Quick
    fluentuiplugin
    Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS UAV_SAR_UpperMonitor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

add_subdirectory(FluentUI)

