import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls
import FluentUI 1.0

Item{
    FluPivot{
        id: pivot
        anchors.fill: parent
        FluPivotItem{
            title: "授课信息"
        }
        FluPivotItem{
            title: "统计信息"
        }
    }
}