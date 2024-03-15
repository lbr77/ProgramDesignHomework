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
    onInitArgument:
            (argument)=>{
        //textbox_uesrname.focus();
    }

    ColumnLayout{
        anchors{
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        // FluText{
        //     text: "登录"
        //     font: FluTextStyle.Subtitle
        //     Layout.alignment: Qt.AlignHCenter
        // }
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
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillWidth: true
            FluFilledButton{
                text: "登录"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                onClicked: ()=>{
                    if(textbox_password.text === ""){
                        showError("密码不能为空")
                        return
                    }
                    // TODO: 判断密码
                    let username = textbox_uesrname.text
                    let password = textbox_password.text
                    let permission = userManager.login(username,password);
                    if(permission === -1){
                        showError("登录错误")
                        return
                    }
                    if(permission === 0){
                        showError("密码错误")
                        return;
                    }
                    console.log("permission:",permission);
                    onResult({password:password,username:username,permission:permission})
                    window.close()
                }
            }
            FluTextButton{
                text: "忘记密码"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                onClicked: ()=>{
                    FluApp.navigate("/forgetPassword")
                }
            }
        }
    }
}
