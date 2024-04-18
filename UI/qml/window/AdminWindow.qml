import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
FluWindow{
    id: windows
    maximumWidth: 1440
    maximumHeight: 900
    width: 1440
    height: 900
    minimumWidth: 1440
    minimumHeight: 900
    title: "学生成绩管理系统 - 管理员端"
    launchMode: FluWindowType.SingleTask
    FluMenuBar{
        id: menu_bar
        FluMenu {
            title: "文件"
            Action{
                text:"保存"
                onTriggered: ()=>{
                    console.log("保存");
                    backend.Save();
                }
            }
            FluMenuSeparator{ }
            Action{
                text:"退出"
                onTriggered: ()=>{
                    FluApp.exit(0);
                }
            }
        }
        FluMenu{
            title: "账户"
            Action{
                text:"注销"
                onTriggered: ()=>{
                    backend.logout();
                    FluApp.navigate("/login");
                    windows.close();
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
    Shortcut{
        sequence: "Ctrl+W"
        onActivated: {
            FluApp.exit(0);
        }
    }
    Shortcut{
        sequence: "Ctrl+S"
        onActivated: {
            backend.Save();
        }
    }
    FluNavigationView{
        id: nav_view
        width: parent.width
        height: parent.height
        anchors.top: menu_bar.bottom
        anchors.bottom: parent.bottom
        // anchors.bottomMargin: 30
        z: 999
        pageMode: FluNavigationViewType.NoStack
        items: FluObject{
            property var navigationView
            property var paneItemMenu
            FluPaneItem{
                title: "用户列表" //
                url: "qrc:/UI/qml/view/adminUserView.qml"
                onTap: ()=>{
                    console.log("[INFO] 切换页面 " + url);
                    nav_view.push(url);
                }
                icon: FluentIcons.PhoneBook
            }
            FluPaneItem{
                title: "课程列表" //
                url: "qrc:/UI/qml/view/adminCourseView.qml"
                onTap: ()=>{
                    console.log("[INFO] 切换页面 " + url);
                    nav_view.push(url);
                }
                icon: FluentIcons.Library
            }
            FluPaneItem{
                title: "成绩列表" //
                url: "qrc:/UI/qml/view/adminScoreView.qml"
                onTap: ()=>{
                    console.log("[INFO] 切换页面 " + url);
                    nav_view.push(url);
                }
                icon: FluentIcons.AllApps
            }
            FluPaneItemExpander{
                title: "素质项目"
                icon: FluentIcons.BookmarksMirrored
                FluPaneItem{
                    title: "论文"
                    url: "qrc:/UI/qml/view/adminArticleView.qml"
                    onTap: ()=>{
                        console.log("[INFO] 切换页面 " + url);
                        nav_view.push(url);
                    }
                }
                FluPaneItem{
                    title: "项目"
                    url: "qrc:/UI/qml/view/adminProjectView.qml"
                    onTap: ()=>{
                        console.log("[INFO] 切换页面 " + url);
                        nav_view.push(url);
                    }
                }
                FluPaneItem{
                    title: "竞赛奖项"
                    url: "qrc:/UI/qml/view/adminCompetitionView.qml"
                    onTap: ()=>{
                        console.log("[INFO] 切换页面 " + url);
                        nav_view.push(url);
                    }

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
        autoSuggestBox:FluTextBox{
            placeholderText: "搜索"
        }
        Component.onCompleted: ()=>{
            setCurrentIndex(0);
        }
    }
}
