import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI
FluWindow {
    id: window
    title: "修改密码"
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
        FluTextBox{
            id: textbox_uesrname
            placeholderText: "账号"
            Layout.preferredWidth: 260
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox{
            id: textbox_Opassword
            Layout.topMargin: 20
            Layout.preferredWidth: 260
            placeholderText: "旧密码"
            echoMode:TextInput.Password
            Layout.alignment: Qt.AlignHCenter
        }
        FluTextBox{
            id: textbox_Npassword
            Layout.topMargin: 20
            Layout.preferredWidth: 260
            placeholderText: "新密码"
            echoMode:TextInput.Password
            Layout.alignment: Qt.AlignHCenter
        }
        RowLayout{
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            FluFilledButton{
                text: "更新"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                onClicked:()=>{

                    let username = textbox_uesrname.text
                    let Opassword = textbox_Opassword.text
                    let Npassword = textbox_Npassword.text
                    if(Opassword === ""||Npassword === ""){
                        showError("密码不能为空")
                        return
                    }
                    if(Opassword === Npassword){
                        showError("新密码不能与旧密码相同")
                        return
                    }
                    let result = backend.resetPassword(username,Opassword,Npassword);
                    if(result == 0){
                        showInfo("密码修改成功")
                    }else if(result == 1){
                        showError("旧密码错误")
                        return;
                    }else if(result == 2){
                        showError("未知错误")
                        return;
                    }
                    backend.Save();
                    // 延时1.5ss关闭窗口
                    let timer = Qt.createQmlObject('import QtQuick 2.0; Timer {interval: 1500; running: true; repeat: false; onTriggered: {window.close();}}', window);
                }
            }
            FluButton{
                text: "取消"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                onClicked:{
                    window.close()
                }
            }
        }
    }
}
