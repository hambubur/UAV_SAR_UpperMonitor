import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtMultimedia
import FluentUI
import "../../component"
import "../../global"
import "../../viewmodel"

FluScrollablePage{

    title:"摄像头参数"

    FluText{
        Layout.topMargin: 20
        text:"暂时没想好写点儿啥"
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: (SCREEN_HEIGHT > 1080 ? 1080 : SCREEN_HEIGHT) * 0.8 - 110
        paddings: 10

        MediaDevices{
            id: mediaDevices
        }

        RowLayout{
            anchors.fill: parent
            spacing: 5

            FluArea{
                Layout.fillWidth: true
                Layout.fillHeight: true

                CaptureSession {
                    id: captureSession
                    camera: Camera {
                        id: camera
                    }
                    videoOutput: viewfinder
                }

                VideoOutput {
                    id: viewfinder
                    anchors.fill: parent
                }
            }

            FluArea{
                width: Math.floor(parent.width * 0.2)
                Layout.maximumWidth: 350
                Layout.minimumWidth: 150
                Layout.fillHeight: true

                ColumnLayout{
                    anchors.fill: parent
                    spacing: 5

                    RowLayout{
                        property var cameraDevices
                        spacing: 5
                        FluText{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 20
                            text: qsTr("设备端口")
                            font: FluTextStyle.BodyStrong
                        }

                        FluComboBox{
                            id: comboBox
                            Layout.fillWidth: true
                            model: ListModel{
                                id: model
                            }
                            textRole: "description"
                            valueRole: "id"
                            onCurrentIndexChanged: {
                                camera.cameraDevice = mediaDevices.videoInputs[comboBox.currentIndex]
                            }
                        }

                        FluArea{
                            width: iconButton_refresh.implicitWidth
                            height: iconButton_refresh.implicitHeight
                            color:FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
                            FluIconButton{
                                id:iconButton_refresh
                                iconSource: FluentIcons.Refresh
                                iconSize: 15
                                text: qsTr("刷新端口")
                                onClicked: {
                                    initDevices()
                                }
                            }
                        }

                        Component.onCompleted: {
                            initDevices()
                        }

                        function initDevices(){
                            //初始化摄像头选择框
                            model.clear()
                            cameraDevices = mediaDevices.videoInputs
                            for(let i = 0; i < cameraDevices.length; i ++)
                            {
                                let json = {}
                                json["description"] = cameraDevices[i].description
                                json["id"] = cameraDevices[i].id
                                model.append(json)
                                console.debug("qqqqqqqqqqqqqq",JSON.stringify(json),cameraDevices[i])

                                if(cameraDevices[i] === mediaDevices.defaultVideoInput)
                                {
                                    comboBox.currentIndex = i
                                }
                            }
                        }
                    }

                    Row{
                        spacing: 5
                        FluButton{
                            height: 25
                            Layout.fillWidth: true
                            text:"启动"
                            onClicked: {
                                camera.start()
                                showSuccess("启动成功")
                            }
                        }
                        FluButton{
                            height: 25
                            Layout.fillWidth: true
                            text:"停止"
                            onClicked: {
                                camera.stop()
                                showSuccess("停止成功")
                            }
                        }
                    }


                }
            }
        }
    }
}
