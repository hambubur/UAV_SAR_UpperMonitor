import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import Qt.labs.platform
import FluentUI
import UAV_SAR_UpperMonitor
import "qrc:///UAV_SAR_UpperMonitor/qml/component"
import "qrc:///UAV_SAR_UpperMonitor/qml/global"
import "qrc:///UAV_SAR_UpperMonitor/qml/viewmodel"

FluScrollablePage{

    title:qsTr("雷达参数")

    FluText{
        Layout.topMargin: 20
        text:qsTr("暂时没想好写点儿啥")
    }

    CfgRadarViewModel{
        id:viewmodel_radar_cfg
        property string currentJsonFile: cfgPath
        onCurrentJsonFileChanged: {
            console.debug("Current Json File: ", currentJsonFile)
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 60
        paddings: 10
        RowLayout{
            anchors.fill: parent
            spacing: 8

            FluTextBox{
                id: pathText
                Layout.fillWidth: true
                Layout.minimumWidth: 200
                text: viewmodel_radar_cfg.cfgPath
            }

            FluButton{
                text: "选择文件"
                onClicked: {
                    fileDialog.open()
                }
            }
            FileDialog{
                id: fileDialog
                nameFilters: ["Json files (*.json)"]
                onFileChanged: {
                    if(file !== "")
                        viewmodel_radar_cfg.currentJsonFile = file
                        pathText.text = file.toString().substring(8)
                }
            }
            FluLoadingButton{
                text: "加载配置"
                onClicked: {
                   loading = true
                    if(viewmodel_radar_cfg.loadcfg(fileDialog.file))
                        showSuccess("加载成功");
                    else
                        showError("加载失败")
                    loading = false
                }
            }
        }
    }

    // Channel
    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height:270
        paddings: 10


        FluPivot{
            Layout.fillWidth: true
            anchors{
                fill: parent
                bottomMargin: 35
            }
            currentIndex: 0
            FluPivotItem{
                title:"Channel"
                contentItem:FluArea{
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    paddings: 10

                    ColumnLayout{
                        id: area_tx_channel
                        spacing: 10
                        anchors{
                            top: parent.top
                            left: parent.left
                        }

                        FluText{
                            text: "TX Channel"
                            font.pixelSize: 18
                            // font.italic: true
                            Layout.bottomMargin: 4
                        }

                        Flow{
                            spacing: 15
                            Repeater{
                                model: 3
                                delegate: FluCheckBox{
                                    Layout.margins: 20
                                    text: "TX"+index
                                    checked: viewmodel_radar_cfg.channel["ChannelTX"]["value"][index]
                                    clickListener: function(){
                                        checked = !checked
                                        viewmodel_radar_cfg.channel["ChannelTX"]["value"][index] = checked
                                        console.debug("tx_channel: ", viewmodel_radar_cfg.channel["ChannelTX"]["value"])
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout{
                        spacing: 10
                        anchors{
                            top: area_tx_channel.bottom
                            topMargin: 25
                            left: parent.left
                        }

                        FluText{
                            text: "RX Channel"
                            font.pixelSize: 18
                            // font.italic: true
                            Layout.bottomMargin: 4
                        }

                        Flow{
                            spacing: 15
                            Repeater{
                                model: 4
                                delegate: FluCheckBox{
                                    Layout.margins: 20
                                    text: "RX"+index
                                    checked: viewmodel_radar_cfg.channel["ChannelRX"]["value"][index]
                                    clickListener: function(){
                                        checked = !checked
                                        viewmodel_radar_cfg.channel["ChannelRX"]["value"][index] = checked
                                        console.debug("rx_channel: ", viewmodel_radar_cfg.channel["ChannelRX"]["value"])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Profile
    FluArea{
        id: area_radar_profile
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        paddings: 10

        property int profileIndex: 0

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title: qsTr("Profile")
                contentItem:FluArea{
                    anchors.fill: parent
                    paddings: 20
                    Layout.topMargin: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        FluDropDownButton{
                            text: qsTr("Profile Index")
                            Repeater{
                                model: 4
                                delegate: FluMenuItem{
                                    text: qsTr("Profile %1").arg(index)
                                    onTriggered: {
                                        area_radar_profile.profileIndex = index
                                    }
                                }
                            }
                        }

                        Grid{
                            id:grid_radar_profile
                            Layout.fillWidth: true
                            columns: 3
                            spacing: 10

                            Repeater{
                                model: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0]
                                delegate: ParameterInputBox{
                                    Layout.margins: 20
                                    height: 50
                                    name_width: 95
                                    box_width: 60
                                    unit_width: 75

                                    key: modelData.title
                                    value: modelData.value
                                    unit: modelData.unit
                                    is_editable: !modelData.locked

                                    onValueChanged: {
                                        viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0][index].value = value
                                        console.log("[Value Changed]",viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0][index].title,":",value)
                                    }
                                }
                            }

                            Repeater{
                                id: repeater_radar_profile_muti_para
                                model: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1]
                                delegate: Repeater{
                                    property int outsideIndex: index
                                    model: modelData.title.length
                                    delegate: ParameterInputBox{
                                        Layout.margins: 20
                                        height: 50
                                        name_width: 95
                                        box_width: 60
                                        unit_width: 75

                                        key: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].title[index]
                                        value: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].value[index]
                                        unit: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].unit
                                        is_editable: !viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].locked

                                        onValueChanged: {
                                            viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].value[index] = value
                                            console.log("[Value Changed]",viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].title[index],":",value)
                                        }
                                    }

                                }
                            }


                            // Repeater {
                            //     id: repeater_radar_profile_cfg
                            //     model: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex]
                            //     delegate: Loader{
                            //         id: loader_radar_profile
                            //         property var loaderData: modelData
                            //         signal isMuti
                            //         sourceComponent: {
                            //             console.debug("modelData.title.type:",typeof modelData.title)
                            //             if(modelData.visible){
                            //                 if(typeof modelData.title === "string"){
                            //                     return defaultInputBox
                            //                 }else{ //是个列表
                            //                     console.debug("modelData:",JSON.stringify(modelData));
                            //                     isMuti()
                            //                     return undefined
                            //                 }
                            //             }else{
                            //                 return undefined
                            //             }
                            //         }

                            //         onIsMuti: {
                            //             grid_radar_profile.mutiParaList.push(modelData)
                            //             repeater_radar_profile_cfg.itemAdded()
                            //             console.debug("onLoaded mutiPara_list ", JSON.stringify(grid_radar_profile.mutiParaList))
                            //         }

                            //         onLoaded: {
                            //             console.debug("onLoaded modelData", JSON.stringify(modelData))
                            //         }

                            //         Component{
                            //             id: defaultInputBox
                            //             ParameterInputBox{
                            //                 Layout.margins: 20
                            //                 width: 300
                            //                 height: 50
                            //                 name_width: 100
                            //                 box_width: 60
                            //                 unit_width: 50

                            //                 key: modelData.title
                            //                 value: modelData.value
                            //                 unit: modelData.unit
                            //                 is_editable: !modelData.locked
                            //             }
                            //         }

                            //         Component{
                            //             id: mutiInputBox
                            //             Repeater{
                            //                 model: profile_loader.loaderData.title.length
                            //                 delegate: ParameterInputBox{
                            //                     Layout.margins: 20
                            //                     width: 300
                            //                     height: 50
                            //                     name_width: 100
                            //                     box_width: 60
                            //                     unit_width: 50

                            //                     key: profile_loader.loaderData.title[index]
                            //                     value: profile_loader.loaderData.value[index]
                            //                     unit: profile_loader.loaderData.unit
                            //                     is_editable: !profile_loader.loaderData.locked

                            //                     Component.onCompleted: {
                            //                         console.debug("mutiComponent modelData ",JSON.stringify(profile_loader.loaderData))
                            //                     }
                            //                 }
                            //             }
                            //         }
                            //     }
                            // }

                            // Repeater{
                            //     id: repeater_profile_mutiPara_outside
                            //     readonly property int modelNum: grid_radar_profile.mutiParaList.length
                            //     // model: grid_radar_profile.mutiParaList
                            //     model: modelNum
                            //     // model:1

                            //     delegate: Repeater{
                            //         property var repeaterData: grid_radar_profile.mutiParaList[index]
                            //         // model: repeaterData.title.length
                            //         // delegate: ParameterInputBox{
                            //         //     Layout.margins: 20
                            //         //     width: 300
                            //         //     height: 50
                            //         //     name_width: 100
                            //         //     box_width: 60
                            //         //     unit_width: 50

                            //         //     key: parent.repeaterData.title[index]
                            //         //     value: parent.repeaterData.value[index]
                            //         //     unit: parent.repeaterData.unit
                            //         //     is_editable: !parent.repeaterData.locked

                            //         //     Component.onCompleted: {
                            //         //         console.debug("inside repeaterData ",JSON.stringify(parent.repeaterData[index]))

                            //         //     }
                            //         // }

                            //         model:3
                            //         delegate: FluButton{
                            //             width: 300
                            //             height: 50
                            //             onClicked: {
                            //                 console.debug("onclicked grid_radar_profile.mutiParaList.length",grid_radar_profile.mutiParaList.length)
                            //                 console.debug("inside repeaterData ",JSON.stringify(parent.repeaterData[index]))
                            //             }
                            //         }
                            //     }
                            // }

                            // onMutiParaListChanged: console.debug("mutiParaList ", JSON.stringify(grid_radar_profile.mutiParaList))

                            // Repeater{
                            //     id: repeater_profile_mutiPara_inside
                            //     // model: grid_radar_profile.mutiParaList.length
                            //     model:1
                            //     delegate: FluButton{
                            //             width: 300
                            //             height: 50
                            //             onClicked: {
                            //                 console.debug("onclicked index", index)
                            //                 console.debug("onclicked mutiParaList ", JSON.stringify(grid_radar_profile.mutiParaList[0]))
                            //                 console.debug("onclicked mutiParaList ", JSON.stringify(grid_radar_profile.mutiParaList[0].title))
                            //                 console.debug("onclicked mutiParaList ", JSON.stringify(grid_radar_profile.mutiParaList[0].title[0]))
                            //             }
                            //         }



                            //     Component{
                            //         id:a
                            //         ParameterInputBox{
                            //             Layout.margins: 20
                            //             width: 300
                            //             height: 50
                            //             name_width: 100
                            //             box_width: 60
                            //             unit_width: 50

                            //             key: repeater_profile_mutiPara_inside.repeaterData.title[repeater_profile_mutiPara_inside.index]
                            //             value: repeater_profile_mutiPara_inside.repeaterData.value[repeater_profile_mutiPara_inside.index]
                            //             unit: repeater_profile_mutiPara_inside.repeaterData.unit
                            //             is_editable: !repeater_profile_mutiPara_inside.repeaterData.locked

                            //             Component.onCompleted: {
                            //                 console.debug("inside repeaterData ",JSON.stringify(repeater_profile_mutiPara_inside.repeaterData))

                            //             }
                            //         }
                            //     }


                            // }

                        }

                        Binding{
                            target: grid_radar_profile
                            property: "columns"
                            value: Math.floor(grid_radar_profile.width / 250)
                        }

                        Binding{
                            target: area_radar_profile
                            property: "height"
                            value: grid_radar_profile.height + 180
                        }
                    }
                }
            }
        }
    }
    

    Component{
        id: model_radar_chirp_cfg
        ListModel {
            ListElement{
                name: "载波频率(fc)"
                name_width: 100
                box_width: 80
                value: 76
                is_editable: true
                unit: "GHz"
                unit_width: 50
            }
            ListElement{
                name: "调频率(K)"
                name_width: 100
                box_width: 80
                value: 80
                is_editable: true
                unit: "MHz/us"
                unit_width: 50
            }
            ListElement{
                name: "空闲时间(Ti)"
                name_width: 100
                box_width: 80
                value: 40
                is_editable: true
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "斜坡时间(Tr)"
                name_width: 100
                box_width: 80
                value: 60
                is_editable: true
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "脉冲宽度(T)"
                name_width: 100
                box_width: 80
                value: 100
                is_editable: false
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "采样率(fs)"
                name_width: 100
                box_width: 80
                value: 22.5
                is_editable: true
                unit: "GHz"
                unit_width: 50
            }
            ListElement{
                name: "采样点数(N)"
                name_width: 100
                box_width: 80
                value: 1024
                is_editable: true
                unit: "Samples"
                unit_width: 50
            }
            ListElement{
                name: "射频增益(G_RF)"
                name_width: 100
                box_width: 80
                value: 33
                is_editable: true
                unit: "dB"
                unit_width: 50
            }
            ListElement{
                name: "接收增益(G_RX)"
                name_width: 100
                box_width: 80
                value: 30
                is_editable: true
                unit: "dB"
                unit_width: 50
            }
        }
    }

    FluArea{
        id: area_radar_chirp
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 300
        paddings: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 35
            }

            FluPivotItem{
                title:"Chirp"
                contentItem:FluArea{
                    anchors.fill: parent
                    paddings: 10
                    Layout.topMargin: 20

                    Grid{
                        id:grid_radar_chirp
                        width: parent.width
                        spacing: 10

                        Repeater {
                            id: repeater_radar_chirp_cfg
                            delegate:  ParameterInputBox{
                                Layout.margins: 20
                                width: 300
                                height: 50
                                name_width: 100
                                box_width: 60
                                unit_width: 50

                                key: model.name
                                unit: model.unit
                                is_editable: model.is_editable
                            }
                            model: model_radar_chirp_cfg.createObject(repeater_radar_chirp_cfg)
                        }
                    }

                    Binding{
                        target: grid_radar_chirp
                        property: "columns"
                        value: Math.floor(grid_radar_chirp.width / 300)
                    }

                    Binding{
                        target: area_radar_chirp
                        property: "height"
                        value: grid_radar_chirp.height + 120
                    }
                }
            }
        }

        Timer{
            id:btn_chirp_set_timer_progress
            interval: 200
            onTriggered: {
                btn_chirp_set.progress = (btn_chirp_set.progress + 0.1).toFixed(1)
                if(btn_chirp_set.progress==1){
                    btn_chirp_set_timer_progress.stop()
                }else{
                    btn_chirp_set_timer_progress.start()
                }
            }
        }

        FluProgressButton{
            id:btn_chirp_set
            // disabled:progress_button_switch.checked
            text:"Set"
            anchors{
                bottom: parent.bottom
                right: parent.right
                rightMargin: 20
            }
            onClicked: {
                btn_chirp_set.progress = 0
                btn_chirp_set_timer_progress.restart()
            }
        }
    }

    Component{
        id: model_radar_frame_cfg
        ListModel {
            ListElement{
                name: "载波频率(fc)"
                name_width: 100
                box_width: 80
                value: 76
                is_editable: true
                unit: "GHz"
                unit_width: 50
            }
            ListElement{
                name: "调频率(K)"
                name_width: 100
                box_width: 80
                value: 80
                is_editable: true
                unit: "MHz/us"
                unit_width: 50
            }
            ListElement{
                name: "空闲时间(Ti)"
                name_width: 100
                box_width: 80
                value: 40
                is_editable: true
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "斜坡时间(Tr)"
                name_width: 100
                box_width: 80
                value: 60
                is_editable: true
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "脉冲宽度(T)"
                name_width: 100
                box_width: 80
                value: 100
                is_editable: false
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "采样率(fs)"
                name_width: 100
                box_width: 80
                value: 22.5
                is_editable: true
                unit: "GHz"
                unit_width: 50
            }
            ListElement{
                name: "采样点数(N)"
                name_width: 100
                box_width: 80
                value: 1024
                is_editable: true
                unit: "Samples"
                unit_width: 50
            }
            ListElement{
                name: "射频增益(G_RF)"
                name_width: 100
                box_width: 80
                value: 33
                is_editable: true
                unit: "dB"
                unit_width: 50
            }
            ListElement{
                name: "接收增益(G_RX)"
                name_width: 100
                box_width: 80
                value: 30
                is_editable: true
                unit: "dB"
                unit_width: 50
            }
        }
    }

    FluArea{
        id: area_radar_frame
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 300
        paddings: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 35
            }

            FluPivotItem{
                title:"Frame"
                contentItem:FluArea{
                    anchors.fill: parent
                    paddings: 10
                    Layout.topMargin: 20

                    Grid{
                        id:grid_radar_frame
                        width: parent.width
                        spacing: 10

                        Repeater {
                            id: repeater_radar_frame_cfg
                            delegate: delegate_parameter_input_box
                            model: model_radar_frame_cfg.createObject(repeater_radar_frame_cfg)
                        }
                    }

                    Binding{
                        target: grid_radar_frame
                        property: "columns"
                        value: Math.floor(grid_radar_frame.width / 300)
                    }

                    Binding{
                        target: area_radar_frame
                        property: "height"
                        value: grid_radar_frame.height + 120
                    }
                }
            }
        }

        Timer{
            id:btn_frame_set_timer_progress
            interval: 200
            onTriggered: {
                btn_frame_set.progress = (btn_frame_set.progress + 0.1).toFixed(1)
                if(btn_frame_set.progress==1){
                    btn_frame_set_timer_progress.stop()
                }else{
                    btn_frame_set_timer_progress.start()
                }
            }
        }

        FluProgressButton{
            id:btn_frame_set
            // disabled:progress_button_switch.checked
            text:"Set"
            anchors{
                bottom: parent.bottom
                right: parent.right
                rightMargin: 20
            }
            onClicked: {
                btn_frame_set.progress = 0
                btn_frame_set_timer_progress.restart()
            }
        }
    }

    Component{
        id: model_radar_communication_cfg
        ListModel {
            ListElement{
                name: "载波频率(fc)"
                name_width: 100
                box_width: 80
                value: 76
                is_editable: true
                unit: "GHz"
                unit_width: 50
            }
            ListElement{
                name: "调频率(K)"
                name_width: 100
                box_width: 80
                value: 80
                is_editable: true
                unit: "MHz/us"
                unit_width: 50
            }
            ListElement{
                name: "空闲时间(Ti)"
                name_width: 100
                box_width: 80
                value: 40
                is_editable: true
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "斜坡时间(Tr)"
                name_width: 100
                box_width: 80
                value: 60
                is_editable: true
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "脉冲宽度(T)"
                name_width: 100
                box_width: 80
                value: 100
                is_editable: false
                unit: "us"
                unit_width: 50
            }
            ListElement{
                name: "采样率(fs)"
                name_width: 100
                box_width: 80
                value: 22.5
                is_editable: true
                unit: "GHz"
                unit_width: 50
            }
            ListElement{
                name: "采样点数(N)"
                name_width: 100
                box_width: 80
                value: 1024
                is_editable: true
                unit: "Samples"
                unit_width: 50
            }
            ListElement{
                name: "射频增益(G_RF)"
                name_width: 100
                box_width: 80
                value: 33
                is_editable: true
                unit: "dB"
                unit_width: 50
            }
            ListElement{
                name: "接收增益(G_RX)"
                name_width: 100
                box_width: 80
                value: 30
                is_editable: true
                unit: "dB"
                unit_width: 50
            }
        }
    }

    FluArea{
        id: area_radar_communication
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 300
        paddings: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 35
            }

            FluPivotItem{
                title:"Communication"
                contentItem:FluArea{
                    anchors.fill: parent
                    paddings: 10
                    Layout.topMargin: 20

                    Grid{
                        id:grid_radar_communication
                        width: parent.width
                        spacing: 10

                        Repeater {
                            id: repeater_radar_communication_cfg
                            delegate: delegate_parameter_input_box
                            model: model_radar_communication_cfg.createObject(repeater_radar_communication_cfg)
                        }
                    }

                    Binding{
                        target: grid_radar_communication
                        property: "columns"
                        value: Math.floor(grid_radar_communication.width / 300)
                    }

                    Binding{
                        target: area_radar_communication
                        property: "height"
                        value: grid_radar_communication.height + 120
                    }
                }
            }
        }

        Timer{
            id:btn_communication_set_timer_progress
            interval: 200
            onTriggered: {
                btn_communication_set.progress = (btn_communication_set.progress + 0.1).toFixed(1)
                if(btn_communication_set.progress==1){
                    btn_communication_set_timer_progress.stop()
                }else{
                    btn_communication_set_timer_progress.start()
                }
            }
        }

        FluProgressButton{
            id:btn_communication_set
            // disabled:progress_button_switch.checked
            text:"Set"
            anchors{
                bottom: parent.bottom
                right: parent.right
                rightMargin: 20
            }
            onClicked: {
                btn_communication_set.progress = 0
                btn_communication_set_timer_progress.restart()
            }
        }
    }
}
