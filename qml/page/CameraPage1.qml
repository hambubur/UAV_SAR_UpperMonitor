import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtMultimedia
import FluentUI
import "qrc:///UAV_SAR_UpperMonitor/qml/global"
import "qrc:///UAV_SAR_UpperMonitor/qml/component"
import "qrc:///UAV_SAR_UpperMonitor/qml/viewmodel"

FluScrollablePage{

    title:"Camera"

    SettingsViewModel{
        id:viewmodel_settings
    }


    FluArea{
        id: cameraUI
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        paddings: 10

        Item {
            anchors.fill: parent

            property var cameraDevices

            MediaDevices {
                id: mediaDevices
            }

            Row{
                spacing: 8

                ComboBox {
                    id: comboBox
                    width: 300
                    model: ListModel{
                        id:model
                    }
                    textRole: "text"
                    valueRole: "value"

                    onCurrentIndexChanged: {
                        camera.cameraDevice = mediaDevices.videoInputs[comboBox.currentIndex]
                    }
                }

            }

            CaptureSession {
                camera: Camera {
                    id: camera
                }
                imageCapture: ImageCapture {
                    id: imageCapture
                }

                recorder: MediaRecorder {
                    id: recorder
                }
                videoOutput: videoOutput
            }

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
            }

            Item {
                id: videoPreview
                anchors.fill: parent
                visible: false
                focus: visible
                Rectangle{
                    anchors.top: parent.top
                    Layout.fillWidth: true
                    height: 10
                    color: "yellow"
                    visible: parent.visible
                }

                MediaPlayer {
                    id: player
                    source: videoPreview.visible ? recorder.actualLocation : ""

                    onMediaStatusChanged: {
                        if (mediaStatus == MediaPlayer.EndOfMedia)
                            stop();
                    }
                    onSourceChanged: {
                        if (videoPreview.visible && player.source !== "")
                            play();
                    }

                    videoOutput: output
                    audioOutput: AudioOutput {
                    }
                }
                VideoOutput {
                    id: output
                    anchors.fill : parent
                    visible: parent.visible
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (player.mediaStatus == MediaPlayer.PlayingState)
                            player.pause();
                        else
                            player.play();
                    }
                }
            }

            Component.onCompleted: {
                initDevices()
            }

            function initDevices(){
                //初始化摄像头选择框
                cameraDevices = mediaDevices.videoInputs
                for(let i = 0; i < cameraDevices.length; i ++)
                {
                    let json = {}
                    json["text"] = cameraDevices[i].description
                    json["value"] = cameraDevices[i].id
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
            spacing: 7
            anchors.bottom: parent.bottom
            Button{
                height: 50
                width: 100
                text: "Start"
                onClicked: {
                    videoOutput.visible = true
                    videoPreview.visible = false
                    camera.start()
                    console.log("Camera start successfully!")
                }
            }
            Button{
                height: 50
                width: 100
                text: "Stop"
                onClicked: {
                    camera.stop()
                    console.log("Camera stop successfully!")
                }
            }
            Button{
                height: 50
                width: 100
                text: "Devices"
                onClicked: {
                    console.log(mediaDevices.videoInputs)
                }
            }
            Button{
                height: 50
                width: 100
                text: "Record"
                onClicked: {
                    recorder.record()
                    console.log("start recording!")
                }
            }
            Button{
                height: 50
                width: 100
                text: "Stop"
                onClicked: {
                    recorder.stop()
                    console.log("stop recording!")
                }
            }
            Button{
                height: 50
                width: 100
                text: "Preview"
                onClicked: {
                    player.play()
                    videoOutput.visible = false
                    videoPreview.visible = true
                    console.log("video preview!")
                    player.pause()
                }
            }
            Button{
                height: 50
                width: 100
                text: "Play"
                onClicked: {
                    player.play()
                    console.log("video play!")
                    console.log(player.source)
                }
            }
            Button{
                height: 50
                width: 100
                text: "Pause"
                onClicked: {
                    player.pause()
                    console.log("video pause!")
                }
            }
            Button{
                height: 50
                width: 100
                text: "Stop"
                onClicked: {
                    player.stop()
                    console.log("video stop!")
                }
            }
        }

    }
}
