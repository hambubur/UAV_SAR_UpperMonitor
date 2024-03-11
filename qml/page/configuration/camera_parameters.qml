
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtMultimedia 6.4
import FluentUI
import "qrc:///UAV_SAR_UpperMonitor/qml/component"
import "qrc:///UAV_SAR_UpperMonitor/qml/global"

FluScrollablePage{

    title:"摄像头参数"

    FluText{
        Layout.topMargin: 20
        text:"暂时没想好写点儿啥"
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height:270
        paddings: 10

        RowLayout{
            anchors.fill: parent
            spacing: 2

            FluArea{
                id: cameraDisplayArea

                width: (parent.width - 2)/2
                Layout.fillHeight: true

                states: [
                    State {
                        name: "PhotoCapture"
                        StateChangeScript {
                            script: {
                                camera.start()
                            }
                        }
                    },
                    State {
                        name: "PhotoPreview"
                        StateChangeScript {
                            script: {
                                camera.stop()
                            }
                        }
                    },
                    State {
                        name: "VideoCapture"
                        StateChangeScript {
                            script: {
                                camera.start()
                            }
                        }
                    },
                    State {
                        name: "VideoPreview"
                        StateChangeScript {
                            script: {
                                camera.stop()
                            }
                        }
                    }
                ]

                CaptureSession {
                    id: captureSession
                    camera: Camera {
                        id: camera
                    }
                    imageCapture: ImageCapture {
                        id: imageCapture
                    }

                    recorder: MediaRecorder {
                        id: recorder
            //             resolution: "640x480"
            //             frameRate: 30
                    }
                    videoOutput: viewfinder
                }

                Item{
                    signal closed

                    id : photoPreview

                    anchors.fill : parent
                    onClosed: cameraDisplayArea.state = "PhotoCapture"
                    // visible: (cameraDisplayArea.state === "PhotoPreview")
                    visible: false
                    focus: visible  // focus是为了让鼠标点击事件生效


                    Image {
                        id: preview
                        anchors.fill : parent
                        fillMode: Image.PreserveAspectFit
                        source: parent.visible ? imageCapture.preview : ""
                        smooth: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parent.closed();
                        }
                    }
                }

                Item{
                    id: videoPreview

                    signal closed

                    anchors.fill : parent
                    onClosed: cameraDisplayArea.state = "VideoCapture"
                    // visible: (cameraDisplayArea.state === "VideoPreview")
                    visible: false
                    focus: visible

                    MediaPlayer {
                        id: player

                        source: parent.visible ? recorder.actualLocation : ""

                        //switch back to viewfinder after playback finished
                        onMediaStatusChanged: {
                            if (mediaStatus == MediaPlayer.EndOfMedia)
                                videoPreview.closed();
                        }
                        onSourceChanged: {
                            if (videoPreview.visible && source !== "")
                                play();
                        }

                        videoOutput: output
                        audioOutput: AudioOutput {
                        }
                    }

                    VideoOutput {
                        id: output
                        anchors.fill : parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            videoPreview.closed();
                        }
                    }
                }

                VideoOutput {
                    id: viewfinder
                    // visible: ((cameraDisplayArea.state === "PhotoCapture") || (cameraDisplayArea.state === "VideoCapture"))
                    visible: true
                    anchors.fill: parent
                }
            }

            FluArea{
                id: cameraConfigArea

                width: (parent.width - 2)/2
                Layout.fillHeight: true

                ColumnLayout{
                    anchors.fill: parent
                    spacing: 5

                    Row{
                        spacing: 5

                        FluText{
                            text: "模式"
                            font: FluTextStyle.BodyStrong
                            Layout.bottomMargin: 4
                        }

                        Flow{
                            Repeater{
                                model: [{title:"拍照模式",state:"PhotoCapture"},
                                        {title:"照片预览",state:"PhotoPreview"},
                                        {title:"录像模式",state:"VideoCapture"},
                                        {title:"视频预览",state:"VideoPreview"}]
                                delegate: FluRadioButton{
                                    checked: cameraDisplayArea.state===modelData.state
                                    text: modelData.title
                                    clickListener: function(){
                                        cameraDisplayArea.state = modelData.state
                                    }
                                }
                            }
                        }
                    }


                    Row{
                        spacing: 5
                        Layout.fillWidth: true
                        FluButton{
                            height: 25
                            width: (parent.width-5)/2
                            text:"启动"
                            onClicked: {
                                camera.start()
                                showSuccess("启动成功")
                            }
                        }
                        FluButton{
                            height: 25
                            width: (parent.width-5)/2
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
                            font.italic: true
                            Layout.bottomMargin: 4
                        }

                        Flow{
                            spacing: 15
                            Repeater{
                                model: 3
                                delegate: FluCheckBox{
                                    Layout.margins: 20
                                    text: "TX"+index
                                    checked: true
                                    clickListener: function(){
                                        checked = !checked
                                        if(checked){
                                            Cfg.radar_tx_channel = set_bit(Cfg.radar_tx_channel,Number(index))
                                        }
                                        else{
                                            Cfg.radar_tx_channel = clr_bit(Cfg.radar_tx_channel,Number(index))
                                        }
                                        console.log("tx_channel:"+String(Cfg.radar_tx_channel))
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
                            font.italic: true
                            Layout.bottomMargin: 4
                        }

                        Flow{
                            spacing: 15
                            Repeater{
                                model: 4
                                delegate: FluCheckBox{
                                    Layout.margins: 20
                                    text: "RX"+index
                                    checked: true
                                    clickListener: function(){
                                        checked = !checked
                                        if(checked){
                                            Cfg.radar_rx_channel = set_bit(Cfg.radar_rx_channel,Number(index))
                                        }
                                        else{
                                            Cfg.radar_rx_channel = clr_bit(Cfg.radar_rx_channel,Number(index))
                                        }
                                        console.log("rx_channel:"+String(Cfg.radar_rx_channel))
                                    }
                                }
                            }
                        }
                    }

                    function clr_bit(x,n){
                        return x & ~(1<<n)
                    }

                    function set_bit(x,n){
                        return x | (1<<n)
                    }
                }
            }
        }

        Timer{
            id:btn_channel_set_timer_progress
            interval: 200
            onTriggered: {
                btn_channel_set.progress = (btn_channel_set.progress + 0.1).toFixed(1)
                if(btn_channel_set.progress==1){
                    btn_channel_set_timer_progress.stop()
                }else{
                    btn_channel_set_timer_progress.start()
                }
            }
        }

        FluProgressButton{
            id:btn_channel_set
            // disabled:progress_button_switch.checked
            text:"Set"
            anchors{
                bottom: parent.bottom
                right: parent.right
                rightMargin: 20
            }
            onClicked: {
                btn_channel_set.progress = 0
                btn_channel_set_timer_progress.restart()
            }
        }
    }

    Component {
        id: delegate_parameter_input_box
        ParameterInputBox{
            Layout.margins: 20
            width: 300
            height: 50
        }
    }

    Component{
        id: model_radar_profile_cfg
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
        id: area_radar_profile
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
                title:Lang.profile
                contentItem:FluArea{
                    anchors.fill: parent
                    paddings: 10
                    Layout.topMargin: 20

                    Grid{
                        id:grid_radar_profile
                        width: parent.width
                        spacing: 10
                        clip: true

                        Repeater {
                            id: repeater_radar_profile_cfg
                            model: model_radar_profile_cfg.createObject(repeater_radar_profile_cfg)
                            delegate: delegate_parameter_input_box
                        }
                    }

                    Binding{
                        target: grid_radar_profile
                        property: "columns"
                        value: Math.floor(grid_radar_profile.width / 300)
                    }

                    Binding{
                        target: area_radar_profile
                        property: "height"
                        value: grid_radar_profile.height + 120
                    }
                }
            }
        }

        Timer{
            id:btn_profile_set_timer_progress
            interval: 200
            onTriggered: {
                btn_profile_set.progress = (btn_profile_set.progress + 0.1).toFixed(1)
                if(btn_profile_set.progress==1){
                    btn_profile_set_timer_progress.stop()
                    showSuccess("配置成功")
                }else{
                    btn_profile_set_timer_progress.start()
                }
            }
        }

        FluProgressButton{
            id:btn_profile_set
            // disabled:progress_button_switch.checked
            text:"Set"
            anchors{
                bottom: parent.bottom
                right: parent.right
                rightMargin: 20
            }
            onClicked: {
                btn_profile_set.progress = 0
                btn_profile_set_timer_progress.restart()
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
                            delegate: delegate_parameter_input_box
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
