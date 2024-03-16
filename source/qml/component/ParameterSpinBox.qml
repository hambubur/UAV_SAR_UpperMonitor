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
    property bool locked: false
    property bool hovered: mouseArea.containsMouse
    property string key
    property var value
    property string unit
    property int minimumValue: 0
    property int maximumValue: 100

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
                    text: wrapper.key
                    font{
                        pixelSize: 14
                    }
                }
                MouseArea{
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Item{
                width: wrapper.box_width
                height: wrapper.height-10
                FluSpinBox{
                    id: para_value
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    disabled: wrapper.locked
                    editable: wrapper.is_editable

                    value: wrapper.value
                    from: wrapper.minimumValue
                    to: wrapper.maximumValue
                    onValueChanged: wrapper.value = value
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
