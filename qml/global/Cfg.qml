pragma Singleton

import QtQuick

QtObject {
    property int radar_tx_channel
    property int radar_rx_channel
    property string test: "test"


    function init() {
        radar_tx_channel = 7
        radar_rx_channel = 15
        test = "test"
    }

    //
    Component.onCompleted: {
        init()
    }
}
