import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
FluWindow{
    width: 1440
    height: 900
    minimumWidth: 1024
    minimumHeight: 768
    title: "学生成绩管理系统 - 管理员端"
    launchMode: FluWindowType.SingleTask
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
                text:"注销"
                onTriggered: ()=>{
                    username = ""
                    password = ""
                    FluApp.navigate("/login");
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
    Component.onCompleted: {
        console.log("Loading Completed");
        // Do sth
    }
    FluNavigationView{
        id: nav_view
        width: parent.width
        height: parent.height
        anchors.top: menu_bar.bottom
        z: 999
        pageMode: FluNavigationViewType.NoStack
        items: FluObject{
            property var navigationView
            property var paneItemMenu
            FluPaneItem{
                id: item_home
                title: "用户信息"//包括学生和老师~ //转专业/信息修改申请
                count: 9 // 未读信息，转专业信息。
                url: "qrc:/UI/qml/view/admInfoView.qml"
                onTap: ()=>{
                    console.log("切换页面 " + url);
                    if(nav_view.getCurrentUrl()){
                        item_home.count = 0
                    }
                    nav_view.push(url);
                }
            }
            FluPaneItem{
                title: "学生成绩" // 所有学生成绩 GPA等。
                url: "qrc:/UI/qml/view/admScoreView.qml"
                onTap: ()=>{
                    console.log("切换页面 " + url);
                    nav_view.push(url);
                }
            }
            FluPaneItem{
                title: "统计" // 散点图
                url: "qrc:/UI/qml/view/admStaticView.qml"
                onTap: ()=>{
                    console.log("切换页面 " + url);
                    nav_view.push(url);
                }
            }
        }
        footerItems: FluObject{
            id: footer_items
            property var navigationView
            property var paneItemMenu
            FluPaneItemSeparator{}
            FluPaneItem{
                title: "关于"
                icon: FluentIcons.Contact
                onTapListener: ()=>{
                    FluApp.navigate("/about");
                }
            }
        }
    }
}
