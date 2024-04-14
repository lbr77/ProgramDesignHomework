//显示账户信息 + 转专业申请。
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI
FluWindow {
    id: window
    title: "账户信息"
    width: 400
    height: 400
    fixSize: true
    modality: Qt.ApplicationModal
    launchMode: FluWindowType.SingleTask
    property string major: ""
    property string username: ""
    property int permission: 0
    property var userInfo:{}
    onInitArgument: (arg)=>{
        username = arg.username;
        permission = arg.permission;
    }
    ColumnLayout{
        // anchors.fill: parent
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
                text: "用户名: " + userManager.userName(username)
                font: FluTextStyle.Subtitle
            }
        }
        RowLayout{
            Layout.topMargin: 15
            Layout.leftMargin: 15
            spacing: 14
            FluText{
                text: "专业: " + userManager.userMajor(username)
                font: FluTextStyle.Subtitle
            }
        }
        RowLayout{
            Layout.topMargin: 15
            Layout.leftMargin: 15
            spacing: 14

        }
    }
}
