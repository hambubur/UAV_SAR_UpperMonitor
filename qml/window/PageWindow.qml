import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import FluentUI
import UAV_SAR_UpperMonitor
import "qrc:///UAV_SAR_UpperMonitor/qml/component"

FluWindow {

    id:window
    width: 800
    height: 600
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleTask
    onInitArgument:
        (arg)=>{
            window.title = arg.title
            loader.setSource( arg.url,{animDisabled:true})
        }

    // Item{
    //     Layout.fillWidth: true
    //     Layout.topMargin: 20
    //     height: 600
    //     // paddings: 10

    //     CaptureSession {
    //         camera: Camera {
    //             id: camera

    //             focusMode: Camera.FocusModeAutoNear
    //             customFocusPoint: Qt.point(0.2, 0.2) // Focus relative to top-left corner
    //         }
    //         videoOutput: videoOutput
    //     }

    //     VideoOutput {
    //         id: videoOutput
    //         anchors.fill: parent
    //     }
    // }

    // FluArea{
    //     Layout.fillWidth: true
    //     Layout.topMargin: 20
    //     height: 50
    //     paddings: 10
    //     Row{
    //         spacing: 5
    //         FluButton{
    //             Layout.fillHeight: true
    //             width: 200
    //             text: "启动"
    //             onClicked: {
    //                 camera.start()
    //             }
    //         }
    //         FluButton{
    //             Layout.fillHeight: true
    //             width: 200
    //             text: "停止"
    //             onClicked: {
    //                 camera.stop()
    //             }
    //         }
    //     }
    // }

    Rectangle{
        anchors.fill: parent

        CaptureSession {
            id: captureSession
            camera: Camera {
                id: camera
            }
            videoOutput: preview
        }

        VideoOutput{
            id: preview
            anchors.fill: parent
        }
    }
    Row{
        spacing: 5
        Button{
            width: 200
            height: 100
            text: "start"
            onClicked: {
                camera.start()
            }
        }
        Button{
            width: 200
            height: 100
            text: "stop"
            onClicked: {
                camera.stop()
            }
        }
    }
}
