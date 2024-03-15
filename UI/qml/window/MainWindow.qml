import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls
import FluentUI 1.0
FluWindow {
    width: 1440
    height: 900
    minimumWidth: 1024
    minimumHeight: 768
    title: "学生成绩管理系统"
    launchMode: FluWindowType.SingleTask

    property var loginPageRegister: registerForWindowResult("/login")
    property string username: ""
    property string password: ""
    property int permission: 0
    Connections {
        target: loginPageRegister
        function onResult(data){
            username = data.username
            password = data.password
            permission = data.permission
            switch (permission) {
                case 1:  //学生
                    stackView.push("qrc:/UI/qml/page/StudentPage.qml");
                    break;
                case 2: // 授课教师
                    stackView.push("qrc:/UI/qml/page/TeacherPage.qml");
                    break;
                case 3:// 管理员
                    stackView.push("qrc:/UI/qml/page/AdministratorPage.qml");
                    break;
                default:
                    showError("权限错误！请联系管理员")
                    break;
            }
        }
    }

    FluMenuBar{
        id: menu_bar
        FluMenu {
            title: "文件"
            Action{
                text:"保存"
            }
            Action{
                text:"导出"
            }
            FluMenuSeparator{ }
            Action{
                text:"退出"
                onTriggered: ()=>{
                    FluApp.exit(0);
                }
            }
        }
        FluMenu {
            title: "编辑"
            Action{
                text:"撤销"
            }
            Action{
                text:"重做"
            }
        }
        FluMenu{
            title: "账户"
            Action{
                text:"登录"
                onTriggered: ()=>{
                    if(username !== "" && password !== "") {
                        showInfo("您已经登录了！")
                        return;
                    }
                    loginPageRegister.launch()
                }
            }
            Action{
                text:"注销"
                onTriggered: ()=>{
                    username = ""
                    password = ""
                    loginPageRegister.launch()
                }
            }
        }
        FluMenu {
            title: "帮助"
            Action{
                text:"关于"
                onTriggered: ()=>{
                    FluApp.navigate("/about");
                }
            }
        }
    }
    StackView{
        id: stackView
        anchors {
            top: menu_bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 20
            rightMargin: 20
            bottomMargin: 15
        }
    }
    Component.onCompleted: {
        //For Debug...调试需要
        // username = "55230422"
        // password = "liborui77"
        // permission = 1;
        if(username === "" || password === "") {
            loginPageRegister.launch()
        }
    }
}
