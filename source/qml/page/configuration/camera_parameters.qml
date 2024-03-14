
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI
import "../component"
import "../global"

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
