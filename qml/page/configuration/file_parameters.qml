import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtMultimedia
import FluentUI
import "qrc:///UAV_SAR_UpperMonitor/qml/component"
import "qrc:///UAV_SAR_UpperMonitor/qml/global"

// FluScrollablePage{

//     title:"文件参数"

//     FluText{
//         Layout.topMargin: 20
//         text:"暂时没想好写点儿啥"
//     }

//     FluArea{
//         Layout.fillWidth: true
//         Layout.topMargin: 20
//         height:270
//         paddings: 10

//         Rectangle{
//             anchors.fill: parent
//             color: "yellow"

//             CaptureSession {
//                 id: captureSession
//                 camera: Camera {
//                     id: camera
//                 }
//                 videoOutput: preview
//             }

//             VideoOutput{
//                 id: preview
//                 anchors.fill: parent
//             }
//         }

//         Row{
//             spacing: 5
//             Button{
//                 width: 200
//                 height: 100
//                 text: "start"
//                 onClicked: {
//                     camera.start()
//                 }
//             }
//             Button{
//                 width: 200
//                 height: 100
//                 text: "stop"
//                 onClicked: {
//                     camera.stop()
//                 }
//             }
//         }


//     }

// }

Rectangle{
    Layout.fillWidth: true
    Layout.topMargin: 20
    height:270

    CaptureSession{
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
        Button{
            width: 200
            height: 100
            text: "visible"
            onClicked: {
                preview.visible = !preview.visible
                showSuccess("visible changed")
            }
        }
    }

}
