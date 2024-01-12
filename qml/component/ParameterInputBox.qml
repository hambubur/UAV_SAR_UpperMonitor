import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

Item {
    id: wrapper
    width: childrenRect.width
    height: childrenRect.height

    property int name_width: 100
    property int box_width: 60
    property int unit_width: 50

    property bool is_editable: true
    property string key
    property string value
    property string unit

    // name
    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: childrenRect.height
        spacing: 8

        Rectangle{
            width: wrapper.name_width
            FluText{
                id: para_key
                anchors.verticalCenter: parent.verticalCenter
                text: key
                font: FluTextStyle.Body
            }
        }

        Rectangle{
            width: wrapper.box_width
            FluTextBox{
                id: para_value
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                text: value
                disabled: is_editable ? false : true
                cleanEnabled: false
            }
        }

        Rectangle{
            width: wrapper.unit_width
            FluText{
                id: para_unit
                anchors.verticalCenter: parent.verticalCenter
                text: unit
                font: FluTextStyle.Body
            }
        }
    }
}
