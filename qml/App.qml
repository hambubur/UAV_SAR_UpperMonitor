import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI


Item {
    id: app

    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }

    Connections{
        target: FluApp
        function onUseSystemAppBarChanged(){
            SettingsHelper.saveUseSystemAppBar(FluApp.useSystemAppBar)
        }
    }

    Component.onCompleted: {
        FluNetwork.openLog = false
        FluNetwork.setInterceptor(function(param){
            param.addHeader("Token","000000000000000000000")
        })
        FluApp.init(app)
        FluApp.windowIcon = "qrc:/UAV_SAR_UpperMonitor/res/img/favicon.ico"
        FluApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.enableAnimation = true
        FluApp.routes = {
            // "/":"qrc:/example/qml/window/MainWindow.qml",
            // "/about":"qrc:/example/qml/window/AboutWindow.qml",
            // "/login":"qrc:/example/qml/window/LoginWindow.qml",
            // "/hotload":"qrc:/example/qml/window/HotloadWindow.qml",
            // "/singleTaskWindow":"qrc:/example/qml/window/SingleTaskWindow.qml",
            // "/standardWindow":"qrc:/example/qml/window/StandardWindow.qml",
            // "/singleInstanceWindow":"qrc:/example/qml/window/SingleInstanceWindow.qml",
            // "/pageWindow":"qrc:/example/qml/window/PageWindow.qml"
            "/":"qrc:/UAV_SAR_UpperMonitor/qml/window/MainWindow.qml",
            "/settings":"qrc:/UAV_SAR_UpperMonitor/qml/window/SettingsWindow.qml",
            "/cameraWindow":"qrc:/UAV_SAR_UpperMonitor/qml/window/PageWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
