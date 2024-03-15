import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
FluWindow{
    id: aboutWindow
    title: "关于"
    width: 500
    height: 200
    fixSize: true
    launchMode: FluWindowType.SingleTask
    ColumnLayout{
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        spacing: 5

        RowLayout{
            Layout.topMargin: 15
            Layout.leftMargin: 15
            spacing: 14
            FluText{
                text:"学生信息管理系统"
                font: FluTextStyle.Title
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        FluApp.navigate("/")
                    }
                }
            }
        }
        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"作者："
            }
            FluText{
                text:"李博睿\n张原溪\n侯凯建"
                Layout.alignment: Qt.AlignBottom
            }
        }
        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"GitHub Repository:"
            }
            FluTextButton{
                id:text_hublink
                topPadding:0
                bottomPadding:0
                text:"https://github.com/lbr77/ProgramDesignHomework"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text_hublink.text)
                }
            }
        }
        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            Layout.topMargin: 20
            FluText{
                id:text_desc
                text:"只是一个程序设计作业，不建议在生产环境中使用。"
            }
        }
    }
    Component.onCompleted: {
        aboutWindow.stayTop = true
    }
}