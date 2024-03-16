import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import Qt.labs.platform
import FluentUI
import UAV_SAR_UpperMonitor
import "../../component"
import "../../global"
import "../../viewmodel"

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

    // File Path
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
                text: viewmodel_radar_cfg.currentJsonFile.substring(4)
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
                bottomMargin: 15
            }
            currentIndex: 0
            FluPivotItem{
                title:"Channel"
                contentItem:FluArea{
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    paddings: 20

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
        property int box_height: 50
        property int box_name_width: 100
        property int box_value_width: 60
        property int box_unit_width: 60

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
                    Layout.topMargin: 20
                    paddings: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        FluDropDownButton{
                            text: qsTr("Profile Index")
                            Repeater{
                                model: viewmodel_radar_cfg.profile.length
                                delegate: FluMenuItem{
                                    text: qsTr("Profile %1").arg(index)
                                    onTriggered: {
                                        area_radar_profile.profileIndex = index
                                        console.log("[Value Changed]","Profile Index",":",index)
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
                                    height: area_radar_profile.box_height
                                    name_width: area_radar_profile.box_name_width
                                    box_width: area_radar_profile.box_value_width
                                    unit_width: area_radar_profile.box_unit_width

                                    key: modelData.title
                                    value: modelData.value
                                    unit: modelData.unit
                                    locked: modelData.locked

                                    onValueChanged: {
                                        viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0][index].value = value
                                        console.log("[Value Changed]",viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0][index].title,":",value)
                                    }
                                }
                            }

                            Repeater{
                                model: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1]
                                delegate: Repeater{
                                    property int outsideIndex: index
                                    model: modelData.title.length
                                    delegate: ParameterInputBox{
                                        Layout.margins: 20
                                        height: area_radar_profile.box_height
                                        name_width: area_radar_profile.box_name_width
                                        box_width: area_radar_profile.box_value_width
                                        unit_width: area_radar_profile.box_unit_width

                                        key: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].title[index]
                                        value: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].value[index]
                                        unit: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].unit
                                        locked: viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].locked

                                        onValueChanged: {
                                            viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].value[index] = value
                                            console.log("[Value Changed]",viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][1][outsideIndex].title[index],":",value)
                                        }
                                    }
                                }
                            }
                        }

                        Binding{
                            target: grid_radar_profile
                            property: "columns"
                            value: Math.floor(grid_radar_profile.width / (area_radar_profile.box_name_width + area_radar_profile.box_value_width + area_radar_profile.box_unit_width + 50))
                        }

                        Binding{
                            target: area_radar_profile
                            property: "height"
                            value: grid_radar_profile.height + 170
                        }
                    }
                }
            }
        }
    }

    // Chirp
    FluArea{
        id: area_radar_chirp
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 300
        paddings: 10

        property int chirpIndex: 0
        property int box_height: 50
        property int box_name_width: 100
        property int box_value_width: 60
        property int box_unit_width: 60

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title:"Chirp"
                contentItem:FluArea{
                    anchors.fill: parent
                    Layout.topMargin: 20
                    paddings: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        FluDropDownButton{
                            text: qsTr("Chirp Config Index")
                            Repeater{
                                id: repeater_radar_chirp_cfg
                                model: viewmodel_radar_cfg.chirp.length
                                delegate: FluMenuItem{
                                    text: qsTr("Chirp Config %1").arg(index)
                                    onTriggered: {
                                        area_radar_chirp.chirpIndex = index
                                        console.log("[Value Changed]","Chirp Config Index",":",index)
                                    }
                                }
                            }
                            FluMenuItem{
                                text: qsTr("Add New Config")
                                onTriggered: {
                                    var new_chirp = viewmodel_radar_cfg.chirp[0]
                                    new_chirp[0][0].value = 0
                                    new_chirp[0][1].value = 0
                                    viewmodel_radar_cfg.chirp.push(new_chirp)
                                    repeater_radar_chirp_cfg.model = viewmodel_radar_cfg.chirp.length
                                    area_radar_chirp.chirpIndex = index
                                }
                            }
                        }

                        Grid{
                            id:grid_radar_chirp
                            Layout.fillWidth: true
                            columns: 3
                            spacing: 10

                            Repeater{
                                model: viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][0]
                                delegate: ParameterInputBox{
                                    Layout.margins: 20
                                    height: area_radar_chirp.box_height
                                    name_width: area_radar_chirp.box_name_width
                                    box_width: area_radar_chirp.box_value_width
                                    unit_width: area_radar_chirp.box_unit_width

                                    key: modelData.title
                                    value: modelData.value
                                    unit: modelData.unit
                                    locked: modelData.locked

                                    onValueChanged: {
                                        viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0][index].value = value
                                        console.log("[Value Changed]",viewmodel_radar_cfg.profile[area_radar_profile.profileIndex][0][index].title,":",value)
                                    }
                                }
                            }

                            Repeater{
                                model: viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1]
                                delegate: Repeater{
                                    property int outsideIndex: index
                                    model: modelData.title.length
                                    delegate: ParameterInputBox{
                                        Layout.margins: 20
                                        height: area_radar_chirp.box_height
                                        name_width: area_radar_chirp.box_name_width
                                        box_width: area_radar_chirp.box_value_width
                                        unit_width: area_radar_chirp.box_unit_width

                                        key: viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1][outsideIndex].title[index]
                                        value: viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1][outsideIndex].value[index]
                                        unit: viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1][outsideIndex].unit
                                        locked: viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1][outsideIndex].locked

                                        onValueChanged: {
                                            viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1][outsideIndex].value[index] = value
                                            console.log("[Value Changed]",viewmodel_radar_cfg.chirp[area_radar_chirp.chirpIndex][1][outsideIndex].title[index],":",value)
                                        }
                                    }
                                }
                            }
                        }

                        Binding{
                            target: grid_radar_chirp
                            property: "columns"
                            value: Math.floor(grid_radar_chirp.width / (area_radar_chirp.box_name_width + area_radar_chirp.box_value_width + area_radar_chirp.box_unit_width + 50))
                        }

                        Binding{
                            target: area_radar_chirp
                            property: "height"
                            value: grid_radar_chirp.height + 170
                        }
                    }
                }
            }
        }
    }

    // Frame
    FluArea{
        id: area_radar_frame
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 300
        paddings: 10

        property int box_height: 50
        property int box_name_width: 100
        property int box_value_width: 60
        property int box_unit_width: 60

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title:"Frame"
                contentItem:FluArea{
                    anchors.fill: parent
                    Layout.topMargin: 20
                    paddings: 20

                    Grid{
                        id:grid_radar_frame
                        width: parent.width
                        columns: 3
                        spacing: 10

                        Repeater {
                            id: repeater_radar_frame_cfg
                            model: viewmodel_radar_cfg.frame
                            delegate: ParameterInputBox{
                                Layout.margins: 20
                                height: area_radar_frame.box_height
                                name_width: area_radar_frame.box_name_width
                                box_width: area_radar_frame.box_value_width
                                unit_width: area_radar_frame.box_unit_width

                                key: modelData.title
                                value: modelData.value
                                unit: modelData.unit
                                locked: modelData.locked

                                onValueChanged: {
                                    viewmodel_radar_cfg.frame[index].value = value
                                    console.log("[Value Changed]",viewmodel_radar_cfg.frame[index].title,":",value)
                                }
                            }
                        }
                    }

                    Binding{
                        target: grid_radar_frame
                        property: "columns"
                        value: Math.floor(grid_radar_frame.width / (area_radar_frame.box_name_width + area_radar_frame.box_value_width + area_radar_frame.box_unit_width + 50))
                    }

                    Binding{
                        target: area_radar_frame
                        property: "height"
                        value: grid_radar_frame.height + 120
                    }
                }
            }
        }
    }
}
