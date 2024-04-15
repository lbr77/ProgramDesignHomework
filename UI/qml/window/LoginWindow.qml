import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI
FluWindow {
    id: window
    title: "登录"
    width: 400
    height: 400
    fixSize: true
    modality: Qt.ApplicationModal
    launchMode: FluWindowType.SingleTask
    function login(){
        if(textbox_password.text === ""){
            showError("密码不能为空")
            return
        }
        let username = textbox_uesrname.text
        let password = textbox_password.text
        let permission = backend.login(username,password);
        // 1 学生 2 老师 3 管理员
        if(permission === -1){
            showError("登录错误")
            return
        }
        if(permission === 0){
            showError("密码错误")
            return;
        }
        console.log(`Logged in with ${username},${password},${permission}`)
        FluApp.navigate(["","/student","/teacher","/admin"][permission])
        window.close();
    }
    ColumnLayout{
        anchors{
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        FluTextBox{
            id: textbox_uesrname
            placeholderText: "账号"
            Layout.preferredWidth: 260
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox{
            id: textbox_password
            Layout.topMargin: 20
            Layout.preferredWidth: 260
            placeholderText: "密码"
            echoMode:TextInput.Password
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout{
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            FluFilledButton{
                text: "登录"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                onClicked: login()
            }
            FluTextButton{
                text: "修改密码"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                onClicked: ()=>{
                    FluApp.navigate("/forgetPassword")
                }
            }
        }
        Shortcut{
            sequence: "Enter"
            onActivated: ()=>{
                login()
            }
        }
    }
}
