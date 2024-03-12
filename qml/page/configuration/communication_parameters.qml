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

    title: qsTr("通信参数")

    FluText{
        Layout.topMargin: 20
        text: qsTr("通信参数配置")
    }

    CfgCommViewModel{
        id:viewmodel_comm_cfg
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
                text: viewmodel_comm_cfg.currentJsonFile.substring(4)
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
                        viewmodel_comm_cfg.currentJsonFile = file
                        pathText.text = file.toString().substring(8)
                }
            }
            FluLoadingButton{
                text: "加载配置"
                onClicked: {
                   loading = true
                    if(viewmodel_comm_cfg.loadcfg(fileDialog.file))
                        showSuccess("加载成功");
                    else
                        showError("加载失败")
                    loading = false
                }
            }
        }
    }

    // Profile
    FluArea{
        id: area_comm
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        paddings: 10

        property int profileIndex: 0
        property int box_height: 50
        property int box_name_width: 140
        property int box_value_width: 70
        property int box_unit_width: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title: qsTr("Communication")
                contentItem:FluArea{
                    anchors.fill: parent
                    Layout.topMargin: 20
                    paddings: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        Grid{
                            id:grid_comm
                            Layout.fillWidth: true
                            columns: 3
                            spacing: 10

                            ParameterInputBox{
                                Layout.margins: 20
                                height: area_comm.box_height
                                name_width: area_comm.box_name_width
                                box_width: area_comm.box_value_width
                                unit_width: area_comm.box_unit_width

                                key: "dataLoggingMode"
                                value: "raw"
                                unit: ""
                                is_editable: true

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["dataLoggingMode"] = value.toString()
                                    console.log("[Value Changed]","dataLoggingMode",":",value)
                                }
                            }
                        }

                        Binding{
                            target: grid_comm
                            property: "columns"
                            value: Math.floor(grid_comm.width / (area_comm.box_name_width + area_comm.box_value_width + area_comm.box_unit_width + 50))
                        }

                        Binding{
                            target: area_comm
                            property: "height"
                            value: grid_comm.height + 170
                        }
                    }
                }
            }
        }
    }
}
