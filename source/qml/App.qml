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

    Connections{
        target: TranslateHelper
        function onCurrentChanged(){
            SettingsHelper.saveLanguage(TranslateHelper.current)
        }
    }

    Component.onCompleted: {
        FluNetwork.openLog = false
        FluNetwork.setInterceptor(function(param){
            param.addHeader("Token","000000000000000000000")
        })
        FluApp.init(app,Qt.locale(TranslateHelper.current))
        FluApp.windowIcon = "qrc:/res/image/favicon.ico"
        FluApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.enableAnimation = true
        FluApp.routes = {
            "/":"qrc:/qml/window/MainWindow.qml"
        }
        var args = Qt.application.arguments
        if(args.length>=2 && args[1].startsWith("-crashed=")){
            FluApp.navigate("/crash",{crashFilePath:args[1].replace("-crashed=","")})
        }else{
            FluApp.navigate("/")
        }
    }
}
