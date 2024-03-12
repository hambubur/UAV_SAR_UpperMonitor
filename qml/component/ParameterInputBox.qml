import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

Item {
    id: wrapper
    height: 50

    property int name_width: 75
    property int box_width: 50
    property int unit_width: 75

    property bool is_editable: true
    property string key
    property string value
    property string unit

    // name
    FluArea{
        anchors.fill: parent
        paddings: 5
        leftPadding: 15
        RowLayout {
            anchors.centerIn: parent.Center
            spacing: 5

            Item{
                width: wrapper.name_width
                height: wrapper.height-10
                FluText{
                    id: para_key
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    text: key
                    font{
                        pixelSize: 14
                    }
                }
            }

            Item{
                width: wrapper.box_width
                height: wrapper.height-10
                FluTextBox{
                    id: para_value
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    text: value
                    disabled: is_editable ? false : true
                    cleanEnabled: false
                }
            }

            Item{
                width: wrapper.unit_width
                height: wrapper.height-10
                FluText{
                    id: para_unit
                    anchors.verticalCenter: parent.verticalCenter
                    text: unit
                    font{
                        pixelSize: 14
                    }

                }
            }
        }
    }

    Binding{
        target: wrapper
        property: "width"
        value: name_width+box_width+unit_width+40
    }
}
