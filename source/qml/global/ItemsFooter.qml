pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView
    property var paneItemMenu

    id:footer_items

    FluPaneItemSeparator{}

    FluPaneItem{
        title:Lang.about
        icon:FluentIcons.Contact
        onTapListener:function(){
            FluApp.navigate("/about")
        }
    }

    FluPaneItem{
        title:Lang.settings
        menuDelegate: paneItemMenu
        icon:FluentIcons.Settings
        url:"qrc:/qml/window/SettingsWindow.qml"
        onTap:{
            navigationView.push(url)
        }
    }

}