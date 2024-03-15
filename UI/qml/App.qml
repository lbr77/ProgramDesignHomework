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
            "/":"qrc:/UI/qml/window/MainWindow.qml",
            "/about": "qrc:/UI/qml/window/AboutWindow.qml",
            "/login": "qrc:/UI/qml/window/LoginWindow.qml",
            "/forgetPassword": "qrc:/UI/qml/window/ForgetPwdWindow.qml",
        }
        FluApp.navigate("/")
    }
}
