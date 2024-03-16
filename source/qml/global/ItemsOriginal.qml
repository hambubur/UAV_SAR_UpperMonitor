pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView
    property var paneItemMenu

    function rename(item, newName){
        if(newName && newName.trim().length>0){
            item.title = newName;
        }
    }

    // 首页
    FluPaneItem{
        id:item_home
        count: 0
        title:Lang.home
        menuDelegate: paneItemMenu
        infoBadge:FluBadge{
            count: item_home.count
        }
        icon:FluentIcons.Home
        url:"qrc:/qml/page/HomePage.qml"
        onTap:{
            if(navigationView.getCurrentUrl()){
                item_home.count = 0
            }
            navigationView.push(url)
        }
    }

    //参数配置
    FluPaneItemExpander{
        id:item_configuration
        title:Lang.configuration
        icon:FluentIcons.CheckboxComposite

        //雷达
        FluPaneItem{
            id:item_cfg_radar
            count: 0
            infoBadge:FluBadge{
                count: item_cfg_radar.count
            }
            title: qsTr("Radar Parameters")
            menuDelegate: paneItemMenu
            url:"qrc:/qml/page/configuration/radar_parameters.qml"
            onTap:{
                item_cfg_radar.count = 0
                navigationView.push(url)
            }
        }

        //通信
        FluPaneItem{
            id:item_cfg_file
            count: 0
            infoBadge:FluBadge{
                count: item_cfg_file.count
            }
            title:"Communication Parameters"
            menuDelegate: paneItemMenu
            url:"qrc:/qml/page/configuration/communication_parameters.qml"
            onTap:{
                item_cfg_file.count = 0
                navigationView.push(url)
            }
        }

        //摄像头
        FluPaneItem{
            id:item_cfg_camera
            count: 0
            infoBadge:FluBadge{
                count: item_cfg_radar.count
            }
            title: qsTr("Camera Parameters")
            menuDelegate: paneItemMenu
            url:"qrc:/qml/page/configuration/camera_parameters.qml"
            onTap:{
                item_cfg_radar.count = 0
                navigationView.push(url)
            }
        }
    }

    //数据录制
    FluPaneItem{
        id:item_recorder
        count: 0
        title: qsTr("Data Recorder")
        menuDelegate: paneItemMenu
        infoBadge:FluBadge{
            count: item_recorder.count
        }
        icon:FluentIcons.TVMonitor
        url:"qrc:/qml/page/RecordPage.qml"
        onTap:{
            if(navigationView.getCurrentUrl()){
                item_recorder.count = 0
            }
            navigationView.push(url)
        }
    }

    //数据处理
    FluPaneItem{
        id:item_processor
        count: 0
        title: qsTr("Data Processor")
        menuDelegate: paneItemMenu
        infoBadge:FluBadge{
            count: item_processor.count
        }
        icon:FluentIcons.GridView
        url:"qrc:/qml/page/ProcessPage.qml"
        onTap:{
            if(navigationView.getCurrentUrl()){
                item_processor.count = 0
            }
            navigationView.push(url)
        }
    }

    //其他
    FluPaneItemExpander{
        id:item_other
        title:Lang.other
        icon:FluentIcons.Shop

        FluPaneItem{
            title:"Timeline"
            menuDelegate: paneItemMenu
            url:"qrc:/qml/page/T_Timeline.qml"
            onTap:{ navigationView.push(url) }
        }

    }

    function getRecentlyAddedData(){
        var arr = []
        for(var i=0;i<children.length;i++){
            var item = children[i]
            if(item instanceof FluPaneItem && item.recentlyAdded){
                arr.push(item)
            }
            if(item instanceof FluPaneItemExpander){
                for(var j=0;j<item.children.length;j++){
                    var itemChild = item.children[j]
                    if(itemChild instanceof FluPaneItem && itemChild.recentlyAdded){
                        arr.push(itemChild)
                    }
                }
            }
        }
        arr.sort(function(o1,o2){ return o2.order-o1.order })
        return arr
    }

    function getRecentlyUpdatedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.recentlyUpdated){
                arr.push(item)
            }
        }
        return arr
    }

    function getSearchData(){
        if(!navigationView){
            return
        }
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem){
                if (item.parent instanceof FluPaneItemExpander)
                {
                    arr.push({title:`${item.parent.title} -> ${item.title}`,key:item.key})
                }
                else
                    arr.push({title:item.title,key:item.key})
            }
        }
        return arr
    }

    function startPageByItem(data){
        navigationView.startPageByItem(data)
    }

}
