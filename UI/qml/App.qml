import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Item {
    id: app
    Component.onCompleted: {
        FluApp.init(app)
        FluApp.windowIcon = "qrc:/UI/res/logo.ico"
        FluApp.routes = {
            "/about": "qrc:/UI/qml/window/AboutWindow.qml",
            "/login": "qrc:/UI/qml/window/LoginWindow.qml",
            "/forgetPassword": "qrc:/UI/qml/window/ForgetPwdWindow.qml",
            "/student": "qrc:/UI/qml/window/StudentWindow.qml",
            "/teacher": "qrc:/UI/qml/window/TeacherWindow.qml",
            "/admin": "qrc:/UI/qml/window/AdminWindow.qml",
        }
        FluApp.navigate("/login")
        console.log("Frontend loaded!");
    }
}
