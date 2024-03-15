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
    id:page
    property bool is_lvds: true
    property bool is_ethernetStream: false

    title: qsTr("通信参数")

    FluText{
        Layout.topMargin: 20
        text: qsTr("DCA1000EVM的部分配置无效，部分配置需要配合板上开关，详情参考官方文档和社区，谨慎修改参数")
    }

    CfgCommViewModel{
        id:viewmodel_comm_cfg
        property string currentJsonFile: cfgPath
        onCurrentJsonFileChanged: {
            console.log("Current Json File: ", currentJsonFile)
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

            FluIconButton{
                iconSource: FluentIcons.FolderOpen
                iconSize: 15
                text: qsTr("选择文件")
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

    // Mode
    FluArea{
        id: area_mode
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        paddings: 10

        property int profileIndex: 0
        property int box_height: 50
        property int box_name_width: 150
        property int box_value_width: 150
        property int box_unit_width: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title: qsTr("Mode")
                contentItem:FluArea{
                    anchors.fill: parent
                    Layout.topMargin: 20
                    paddings: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        Grid{
                            id:grid_mode
                            Layout.fillWidth: true
                            columns: 3
                            spacing: 10

                            property var keyList: viewmodel_comm_cfg.keys().slice(0, 5)

                            //dataTransferMode
                            ParameterComboBox{
                                property int index: 1
                                Layout.margins: 20
                                height: area_mode.box_height
                                name_width: area_mode.box_name_width
                                box_width: area_mode.box_value_width
                                unit_width: area_mode.box_unit_width

                                key: qsTr(parent.keyList[index])
                                valueList: ["LVDSCapture","LVDSPlayback"]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config[parent.keyList[index]] = value
                                    page.is_lvds = value==="LVDSCapture"? true : false
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data transfer mode specifies if DCA100EVM is in record mode or playback mode.")
                                    delay: 1000
                                }
                            }

                            //dataLoggingMode
                            ParameterComboBox{
                                property int index: 0
                                Layout.margins: 20
                                height: area_mode.box_height
                                name_width: area_mode.box_name_width
                                box_width: area_mode.box_value_width
                                unit_width: area_mode.box_unit_width
                                visible: page.is_lvds

                                key: qsTr(parent.keyList[index])
                                valueList: ["raw","multi"]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config[parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data logging mode specifies the type of data being transferred in record mode through DCA1000EVM. This field is valid only when dataTransferMode is “LVDSCapture”.")
                                    delay: 1000
                                }
                            }

                            //dataCaptureMode
                            ParameterComboBox{
                                property int index: 2

                                Layout.margins: 20
                                height: area_mode.box_height
                                name_width: area_mode.box_name_width
                                box_width: area_mode.box_value_width
                                unit_width: area_mode.box_unit_width
                                visible: page.is_lvds

                                key: qsTr(parent.keyList[index])
                                valueList: ["ethernetStream","SDCardStorage"]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config[parent.keyList[index]] = value
                                    page.is_ethernetStream = (page.is_lvds && value==="ethernetStream")? true : false
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data capture mode specifies the transport mechanism for getting data out of DCA1000EVM. This field is valid only when dataTransferMode is “LVDSCapture”.")
                                    delay: 1000
                                }
                            }

                            //lvdsMode
                            ParameterComboBox{
                                property int index: 3
                                Layout.margins: 20
                                height: area_mode.box_height
                                name_width: area_mode.box_name_width
                                box_width: area_mode.box_value_width
                                unit_width: area_mode.box_unit_width
                                visible: page.is_lvds

                                key: qsTr(parent.keyList[index])
                                valueList: ["4lane","2lane"]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config[parent.keyList[index]] = currentIndex+1
                                    console.log("[Value Changed]",parent.keyList[index],":",qsTr("%1(%2)").arg(currentIndex+1,valueList[currentIndex]))
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data capture mode specifies the transport mechanism for getting data out of DCA1000EVM. This field is valid only when dataTransferMode is “LVDSCapture”.")
                                    delay: 1000
                                }
                            }

                            //dataFormatMode
                            ParameterComboBox{
                                property int index: 4
                                Layout.margins: 20
                                height: area_mode.box_height
                                name_width: area_mode.box_name_width
                                box_width: area_mode.box_value_width
                                unit_width: area_mode.box_unit_width
                                visible: page.is_lvds

                                key: qsTr(parent.keyList[index])
                                valueList: ["12 bit","14 bit","16 bit"]
                                currentIndex: 2
                                value: valueList[currentIndex]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config[parent.keyList[index]] = currentIndex+1
                                    console.log("[Value Changed]",parent.keyList[index],":",qsTr("%1(%2)").arg(currentIndex+1,valueList[currentIndex]))
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data format mode specifies the bit-mode for the captured data. This field is valid only when dataTransferMode is “LVDSCapture”.")
                                    delay: 1000
                                }
                            }

                        }

                        Binding{
                            target: grid_mode
                            property: "columns"
                            value: Math.floor(grid_mode.width / (area_mode.box_name_width + area_mode.box_value_width + area_mode.box_unit_width + 50))
                        }

                        Binding{
                            target: area_mode
                            property: "height"
                            value: grid_mode.height + 170
                        }
                    }
                }
            }
        }
    }

    // EthernetConfig
    FluArea{
        id: area_ethernet
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        paddings: 10
        visible: page.is_ethernetStream

        property int profileIndex: 0
        property int box_height: 50
        property int box_name_width: 150
        property int box_value_width: 150
        property int box_unit_width: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title: qsTr("Ethernet")
                contentItem:FluArea{
                    anchors.fill: parent
                    Layout.topMargin: 20
                    paddings: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        Grid{
                            id:grid_ethernet
                            Layout.fillWidth: true
                            columns: 3
                            spacing: 10

                            property var keyList: Object.keys(viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"])

                            //systemIPAddress
                            ParameterInputBox{
                                property int index: 0
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("IP address of the PC in EEPPROM of DCA1000EVM")
                                    delay: 1000
                                }
                            }

                            //DCA1000IPAddress
                            ParameterInputBox{
                                property int index: 1
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfig"][parent.keyList[index]] = value
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("IP address of the DCA1000EVM in EEPPROM of DCA1000EVM")
                                    delay: 1000
                                }
                            }

                            //DCA1000MACAddress
                            ParameterInputBox{
                                property int index: 2
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("MAC address of the DCA1000EVM in EEPPROM of DCA1000EVM")
                                    delay: 1000
                                }
                            }

                            //DCA1000ConfigPort
                            ParameterInputBox{
                                property int index: 3
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfig"][parent.keyList[index]] = parseInt(value)
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = parseInt(value)
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Config port number in EEPPROM of DCA1000EVM for config command communication between DCA1000EVM and PC")
                                    delay: 1000
                                }
                            }

                            //DCA1000DataPort
                            ParameterInputBox{
                                property int index: 4
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfig"][parent.keyList[index]] = parseInt(value)
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = parseInt(value)
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data port number in EEPPROM of DCA1000EVM for config command communication between DCA1000EVM and PC")
                                    delay: 1000
                                }
                            }

                            //packetDelay_us
                            ParameterSpinBox{
                                property int index: 5
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr("packetDelay_us")
                                value: 25
                                minimumValue: 5
                                maximumValue: 500
                                unit: ""
                                is_editable: true

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["packetDelay_us"] = parseInt(value)
                                    console.log("[Value Changed]","packetDelay_us",":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Value in usec to throttle the throughput of the Ethernet stream out of DCA1000EVM. Min and max values are dictated by the limits supported by DCA1000 H/W. This field is valid only when dataCaptureMode is “ethernetStream”.")
                                    delay: 1000
                                }
                            }
                        }

                        Binding{
                            target: grid_ethernet
                            property: "columns"
                            value: Math.floor(grid_ethernet.width / (area_ethernet.box_name_width + area_ethernet.box_value_width + area_ethernet.box_unit_width + 50))
                        }

                        Binding{
                            target: area_ethernet
                            property: "height"
                            value: grid_ethernet.height + 170
                        }
                    }
                }
            }
        }
    }

    // captureConfig
    FluArea{
        id: area_capture
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        paddings: 10

        property int profileIndex: 0
        property int box_height: 50
        property int box_name_width: 150
        property int box_value_width: 150
        property int box_unit_width: 10

        FluPivot{
            currentIndex: 0
            anchors{
                fill: parent
                bottomMargin: 15
            }

            FluPivotItem{
                title: qsTr("Capture")
                contentItem:FluArea{
                    anchors.fill: parent
                    Layout.topMargin: 20
                    paddings: 20

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 10

                        //fileBasePath
                        RowLayout{
                            Layout.fillWidth: true
                            spacing: 8

                            FluTextBox{
                                id: fileBasePath
                                Layout.fillWidth: true
                                Layout.minimumWidth: 200
                                text: viewmodel_comm_cfg.dca1000Config["captureConfig"]["fileBasePath"]
                            }
                            FluArea{
                                width: children.implicitWidth
                                height: children.implicitHeight
                                FluIconButton{
                                    id:a
                                    iconSource: FluentIcons.FolderOpen
                                    iconSize: 15
                                    display: Button.TextBesideIcon
                                    text: qsTr("选择文件路径")
                                    onClicked: {
                                        folderDialog.open()
                                    }
                                }
                            }

                            FolderDialog{
                                id: folderDialog
                                folder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
                                onFolderChanged: {
                                    if(folder !== ""){
                                        var newPath = folder.toString().substring(8);
                                        viewmodel_comm_cfg.dca1000Config["captureConfig"]["fileBasePath"] = newPath.replace(/\//g, "\\\\");
                                        fileBasePath.text = newPath;
                                        console.log("[Value Changed]","fileBasePath",":",newPath.replace(/\//g, "\\\\"));
                                    }
                                }
                            }
                        }

                        Grid{
                            id:grid_capture
                            Layout.fillWidth: true
                            columns: 3
                            spacing: 10

                            property var keyList: Object.keys(viewmodel_comm_cfg.dca1000Config["captureConfig"])

                            //fileBasePath
                            ParameterInputBox{
                                property int index: 0
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width
                                visible: dataCaptureMode.is_ethernetStream

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["captureConfig"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["captureConfig"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Valid file path on the PC where this CLI runs.")
                                    delay: 1000
                                }
                            }

                            //DCA1000IPAddress
                            ParameterInputBox{
                                property int index: 1
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfig"][parent.keyList[index]] = value
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("IP address of the DCA1000EVM in EEPPROM of DCA1000EVM")
                                    delay: 1000
                                }
                            }

                            //DCA1000MACAddress
                            ParameterInputBox{
                                property int index: 2
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("MAC address of the DCA1000EVM in EEPPROM of DCA1000EVM")
                                    delay: 1000
                                }
                            }

                            //DCA1000ConfigPort
                            ParameterInputBox{
                                property int index: 3
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfig"][parent.keyList[index]] = value
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Config port number in EEPPROM of DCA1000EVM for config command communication between DCA1000EVM and PC")
                                    delay: 1000
                                }
                            }

                            //DCA1000DataPort
                            ParameterInputBox{
                                property int index: 4
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]]
                                unit: ""

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfig"][parent.keyList[index]] = value
                                    viewmodel_comm_cfg.dca1000Config["ethernetConfigUpdate"][parent.keyList[index]] = value
                                    console.log("[Value Changed]",parent.keyList[index],":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Data port number in EEPPROM of DCA1000EVM for config command communication between DCA1000EVM and PC")
                                    delay: 1000
                                }
                            }

                            //packetDelay_us
                            ParameterSpinBox{
                                property int index: 5
                                Layout.margins: 20
                                height: area_ethernet.box_height
                                name_width: area_ethernet.box_name_width
                                box_width: area_ethernet.box_value_width
                                unit_width: area_ethernet.box_unit_width

                                key: qsTr(parent.keyList[index])
                                value: 25
                                minimumValue: 5
                                maximumValue: 500
                                unit: ""
                                is_editable: true

                                onValueChanged: {
                                    viewmodel_comm_cfg.dca1000Config["packetDelay_us"] = parseInt(value)
                                    console.log("[Value Changed]","packetDelay_us",":",value)
                                }

                                FluTooltip{
                                    visible: parent.hovered
                                    text: qsTr("Value in usec to throttle the throughput of the Ethernet stream out of DCA1000EVM. Min and max values are dictated by the limits supported by DCA1000 H/W. This field is valid only when dataCaptureMode is “ethernetStream”.")
                                    delay: 1000
                                }
                            }
                        }

                        Binding{
                            target: grid_ethernet
                            property: "columns"
                            value: Math.floor(grid_ethernet.width / (area_ethernet.box_name_width + area_ethernet.box_value_width + area_ethernet.box_unit_width + 50))
                        }

                        Binding{
                            target: area_ethernet
                            property: "height"
                            value: grid_ethernet.height + 170
                        }
                    }
                }
            }
        }
    }
}
