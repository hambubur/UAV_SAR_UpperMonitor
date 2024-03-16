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

    property bool is_editable: false
    property bool locked: false
    property bool hovered: mouseArea.containsMouse
    property string key
    property var valueList
    property string unit
    property int currentIndex
    property var value


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
                FluComboBox{
                    id: para_value
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    disabled: wrapper.locked
                    editable: wrapper.is_editable

                    model: wrapper.valueList
                    currentIndex: wrapper.currentIndex

                    onCurrentIndexChanged: {
                        wrapper.value = valueList[currentIndex]
                        wrapper.currentIndex = currentIndex
                    }

                    onAccepted: {
                        if (find(editText) === -1)
                            model.append({text: editText})
                    }
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
