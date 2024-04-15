import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage{
    id: root
    title: "个人信息"
    property var user : {}
    property var history : []
    property double gpa : 0 // 绩点
    property double added : 0 // 加分
    Component.onCompleted: {
        user = backend.getUserInfo();
        gpa = backend.getTotalGPA4Stu();
        history = backend.getGPAByTerm4Stu();
        // added = backend.getAddedGPA4Stu(); //TODO
        console.log(JSON.stringify(user))
        console.log(JSON.stringify(history))
        console.log(gpa)
    }
    RowLayout{
        anchors.topMargin: 5
        anchors.bottomMargin: 50
        anchors.fill: parent
        spacing: 75
        ColumnLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 100
            FluClip{
                radius: [100,100,100,100]
                width: 200
                height: 200
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                FluImage{
                    source: user.avatar
                    width: 200
                    height: 200
                    onStatusChanged:{
                        if(status === Image.Error){
                            showError("图片加载错误")
                        }
                    }
                    clickErrorListener: function(){
                        source = user.avatar
                    }
                }
            }
            FluText{
                id: big_name
                text: user.name
                // font.pixelSize: 20
                font: FluTextStyle.Title
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
        ColumnLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 10
            FluRectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                FluText{
                    id: title
                    text: "个人信息"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pixelSize: 20
                    font.bold: true
                }
                ColumnLayout{
                    anchors.top: title.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 20
                    anchors.leftMargin: 20
                    spacing: 20
                    FluText{
                        text: "学号: " + user.userid
                        font.pixelSize: 15
                    }
                    FluText{
                        text: "专业：" + user.major
                        font.pixelSize: 15
                    }
                    FluText{
                        text: "GPA：" + `${gpa.toFixed(2)} + ${added.toFixed(2)} = ${(gpa + added).toFixed(2)}`

                        font.pixelSize: 15
                    }
                    FluTextButton{
                        text: "修改信息"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 20
                        onClicked: ()=>{
                            modify_info.open()
                        }
                    }
                }
            }
            FluRectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                Text{
                    id: txt
                    text: "历史成绩"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    font.pixelSize: 20
                    font.bold: true
                }
                FluChart{
                    anchors.fill: parent
                    anchors.top: txt.bottom
                    anchors.topMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    chartType: 'line'
                    chartData: {
                        let labels = [0]
                        let data = [gpa]
                        let average = [gpa]
                        for(let r of history){
                            labels.push(r.term)
                            data.push(r.GPA)
                            average.push(gpa)
                        }
                        labels.push(gpa)
                        average.push(gpa)
                        return {
                            labels: labels,
                            datasets: [{
                                label: "历史绩点",
                                data: data,
                                fill: false,
                                borderColor: 'rgb(75, 192, 192)',
                                tension: 0.1,
                            },{
                                label: "平均绩点",
                                data: average,
                                fill: false,
                                borderColor: 'rgb(192, 75, 192)',
                                tension: 0.1,
                            }]
                        }
                    }
                    chartOptions: { return {
                            maintainAspectRatio: false,
                            title: {
                                display: true,
                                text: '历史成绩曲线图'
                            },
                            tooltips: {
                                mode: 'index',
                                intersect: false
                            }
                        }
                    }
                }
            }
        }
    }
    FluContentDialog{
        id: modify_info
        title: "修改信息"
        property var text : ""
        property var onAcceptListener
        negativeText: "取消"
        positiveText: "确定"
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 60
                FluTextBox{
                    id: usersss
                    placeholderText: "名字"
                    anchors.centerIn: parent
                    onTextChanged: {
                        modify_info.text = usersss.text
                    }
                }Component.onCompleted: {
                    usersss.text = user.name
                    usersss.forceActiveFocus()
                }
            }
        }
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onPositiveClicked: ()=>{
            backend.changeUserInfo(text,user.major,user.userid)
            user.name = text
            big_name.text =text
        }
    }
}
