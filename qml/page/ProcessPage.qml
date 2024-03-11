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

    Item{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 600
        // paddings: 10

        CaptureSession {
            camera: Camera {
                id: camera

                focusMode: Camera.FocusModeAutoNear
                customFocusPoint: Qt.point(0.2, 0.2) // Focus relative to top-left corner
            }
            videoOutput: videoOutput
        }

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10
        Row{
            spacing: 5
            FluButton{
                Layout.fillHeight: true
                width: 200
                text: "启动"
                onClicked: {
                    camera.start()
                }
            }
            FluButton{
                Layout.fillHeight: true
                width: 200
                text: "停止"
                onClicked: {
                    camera.stop()
                }
            }
            FluButton{
                Layout.fillHeight: true
                width: 200
                text: "新窗口"
                onClicked: {
                    FluApp.navigate("/cameraWindow")
                }
            }
        }
    }


    // Item{
    //     id:item
    //     anchors.fill: parent
    //     Camera {
    //         id: camera
    //         focus {
    //             focusMode: Camera.FocusAuto;
    //             focusPointMode: Camera.FocusPointCenter;
    //         }
    //         captureMode: Camera.CaptureStillImage;
    //         imageProcessing {
    //             whiteBalanceMode: CameraImageProcessing.WhiteBalanceAuto;
    //         }
    //         flash.mode: Camera.FlashAuto;

    //         imageCapture {
    //             onImageCaptured: {
    //                 // Show the preview in an Image
    //                 photoPreview.source = preview
    //             }
    //         }
    //     }


    //     VideoOutput {
    //         id:viewfinder
    //         source: camera
    //         fillMode: Stretch
    //         focus : visible // to receive focus and capture key events when visible
    //         anchors.fill: parent
    //         autoOrientation: true
    //         MouseArea{
    //             anchors.fill: parent
    //             onClicked: {
    //                 camera.searchAndLock();
    //             }
    //         }
    //     }

    //     ZoomControl {
    //         id:zoomControl
    //         x : 0
    //         y : 0
    //         z:3
    //         width : 100
    //         height: parent.height

    //         currentZoom: camera.digitalZoom
    //         maximumZoom: Math.min(4.0, camera.maximumDigitalZoom)
    //         onZoomTo: camera.setDigitalZoom(value)}

    //         TLImageButton{
    //             id:captureBtn
    //             width: 60
    //             height: width
    //             picNormal:commonParameter.getSkinPath() + "icon_capture_normal.png"
    //             picPressed: commonParameter.getSkinPath() + "icon_capture_press.png"
    //             picHover: commonParameter.getSkinPath() + "icon_capture_normal.png"
    //             anchors.bottom: parent.bottom
    //             anchors.bottomMargin: 8*initWidth/375.0
    //             anchors.horizontalCenter: parent.horizontalCenter
    //             onClicked: {
    //                 camera.imageCapture.capture()}
    //         }
    //     }
    // Image {id: photoPreview}



    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10
        FluCheckBox{
            text:"fitsAppBarWindows"
            checked: window.fitsAppBarWindows
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                window.fitsAppBarWindows = !window.fitsAppBarWindows
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10
        FluCheckBox{
            text:"Software Render"
            checked: SettingsHelper.getRender() === "software"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                if(SettingsHelper.getRender() === "software"){
                    SettingsHelper.saveRender("")
                }else{
                    SettingsHelper.saveRender("software")
                }
                dialog_restart.open()
            }
        }
    }

    FluContentDialog{
        id:dialog_restart
        title:"友情提示"
        message:"此操作需要重启才能生效，是否重新启动？"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: "取消"
        positiveText:"确定"
        onPositiveClicked:{
            FluApp.exit(931)
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 128
        paddings: 10

        ColumnLayout{
            spacing: 5
            anchors{
                top: parent.top
                left: parent.left
            }
            FluText{
                text:Lang.dark_mode
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater{
                model: [{title:"System",mode:FluThemeType.System},{title:"Light",mode:FluThemeType.Light},{title:"Dark",mode:FluThemeType.Dark}]
                delegate:  FluRadioButton{
                    checked : FluTheme.darkMode === modelData.mode
                    text:modelData.title
                    clickListener:function(){
                        FluTheme.darkMode = modelData.mode
                    }
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 160
        paddings: 10

        ColumnLayout{
            spacing: 5
            anchors{
                top: parent.top
                left: parent.left
            }
            FluText{
                text:Lang.navigation_view_display_mode
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater{
                model: [{title:"Open",mode:FluNavigationViewType.Open},{title:"Compact",mode:FluNavigationViewType.Compact},{title:"Minimal",mode:FluNavigationViewType.Minimal},{title:"Auto",mode:FluNavigationViewType.Auto}]
                delegate: FluRadioButton{
                    checked : viewmodel_settings.displayMode===modelData.mode
                    text:modelData.title
                    clickListener:function(){
                        viewmodel_settings.displayMode = modelData.mode
                    }
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        paddings: 10

        ColumnLayout{
            spacing: 10
            anchors{
                top: parent.top
                left: parent.left
            }

            FluText{
                text:Lang.locale
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }

            Flow{
                spacing: 5
                Repeater{
                    model: Lang.__localeList
                    delegate: FluRadioButton{
                        checked: Lang.__locale === modelData
                        text:modelData
                        clickListener:function(){
                            Lang.__locale = modelData
                        }
                    }
                }
            }
        }
    }
}
