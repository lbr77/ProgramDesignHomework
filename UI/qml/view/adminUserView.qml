import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage{

    id:root
    title: "用户列表"
    signal checkBoxChanged

    property var dataSource : []
    property int sortType: 0
    property bool seletedAll: false
    property string nameKeyword: ""
    onNameKeywordChanged: ()=>{
        loadData()
    }
    Component.onCompleted: ()=>{
        console.log("[INFO] Loading score");
        loadData()
        console.log("[INFO] Loaded");
    }
    onCheckBoxChanged: ()=>{
        for(var i =0;i< table_view.rows ;i++){
            if(false === table_view.getRow(i).checkbox.options.checked){
                root.seletedAll = false
                return
            }
        }
        root.seletedAll = true
    }
    onSortTypeChanged: ()=>{
        table_view.closeEditor()
        if(sortType === 0){
            table_view.sort()
        }else if(sortType === 1){
            table_view.sort(
                    (l, r) =>{
                    var lage = Number(l.age)
                    var rage = Number(r.age)
                    if(lage === rage){
                        return l._key>r._key
                    }
                    return lage>rage
                });
        }else if(sortType === 2){
            table_view.sort(
                    (l, r) => {
                    var lage = Number(l.age)
                    var rage = Number(r.age)
                    if(lage === rage){
                        return l._key>r._key
                    }
                    return lage<rage
                });
        }
    }
    FluMenu{
        id:pop_filter
        width: 200
        height: 89

        contentItem: Item{

            onVisibleChanged: {
                if(visible){
                    name_filter_text.text = root.nameKeyword
                    name_filter_text.cursorPosition = name_filter_text.text.length
                    name_filter_text.forceActiveFocus()
                }
            }

            FluTextBox{
                id:name_filter_text
                anchors{
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 10
                }
                iconSource: FluentIcons.Search
            }

            FluButton{
                text: "搜索"
                anchors{
                    bottom: parent.bottom
                    right: parent.right
                    bottomMargin: 10
                    rightMargin: 10
                }
                onClicked: {
                    root.nameKeyword = name_filter_text.text
                    pop_filter.close()
                }
            }

        }
        function showPopup(){
            table_view.closeEditor()
            pop_filter.popup()
        }

    }
    Component{
        id:com_checbox
        Item{
            FluCheckBox{
                anchors.centerIn: parent
                checked: true === options.checked
                enableAnimation: false
                clickListener: function(){
                    var obj = table_view.getRow(row)
                    obj.checkbox = table_view.customItem(com_checbox,{checked:!options.checked})
                    table_view.setRow(row,obj)
                    checkBoxChanged()
                }
            }
        }
    }
    Component{
        id:com_action
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluButton{
                    text: "删除"
                    onClicked: ()=>{
                        table_view.closeEditor()
                        console.log(JSON.stringify(table_view.getRow(row)))
                        backend.deleteUserRec4Admin(table_view.getRow(row).userid)
                        table_view.removeRow(row)
                        showInfo("删除成功")
                    }
                }
                FluFilledButton{
                    text: "编辑"
                    onClicked: ()=>{
                        modify.usrid = table_view.getRow(row).userid
                        modify.open()
                    }
                }
            }
        }
    }
    Component{
        id:com_column_filter_name
        Item{
            FluText{
                text: "姓名"
                anchors.centerIn: parent
            }
            FluIconButton{
                width: 20
                height: 20
                iconSize: 12
                verticalPadding:0
                horizontalPadding:0
                iconSource: FluentIcons.Filter
                iconColor: {
                    if("" !== root.nameKeyword){
                        return FluTheme.primaryColor
                    }
                    return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                }
                anchors{
                    right: parent.right
                    rightMargin: 3
                    verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    pop_filter.showPopup()
                }
            }
        }
    }
    Component{
        id:com_column_checbox
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluText{
                    text: "全选"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluCheckBox{
                    checked: true === root.seletedAll
                    enableAnimation: false
                    Layout.alignment: Qt.AlignVCenter
                    clickListener: function(){
                        root.seletedAll = !root.seletedAll
                        var checked = root.seletedAll
                        itemModel.display = table_view.customItem(com_column_checbox,{"checked":checked})
                        for(var i =0;i< table_view.rows ;i++){
                            var rowData = table_view.getRow(i)
                            rowData.checkbox = table_view.customItem(com_checbox,{"checked":checked})
                            table_view.setRow(i,rowData)
                        }
                    }
                }
            }
        }
    }

    Component{
        id:com_column_sort_score
        Item{
            FluText{
                text: "权限"
                anchors.centerIn: parent
            }
            ColumnLayout{
                spacing: 0
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronUp
                    iconColor: {
                        if(1 === root.sortType){
                            return FluTheme.primaryColor
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortType === 1){
                            root.sortType = 0
                            return
                        }
                        root.sortType = 1
                    }
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronDown
                    iconColor: {
                        if(2 === root.sortType){
                            return FluTheme.primaryColor
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortType === 2){
                            root.sortType = 0
                            return
                        }
                        root.sortType = 2
                    }
                }
            }
        }
    }

    FluContentDialog{
        id: modify
        title: "修改用户信息"
        property var usrname
        property var usrid
        property var usrpass
        property var usrperm
        property var usrmajor

        negativeText: "取消"
        positiveText: "确定"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 200
                anchors.fill: parent
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        FluText{
                            text: "姓名："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_name
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.usrname = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "密码："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluPasswordBox{
                            id: txt_pwd
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.usrpass = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "类型："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluDropDownButton{
                            id: perm_btn
                            text: "权限"
                            Layout.alignment: Qt.AlignVCenter
                            FluMenuItem{
                                text: "学生"
                                onClicked: {
                                    modify.usrperm = 1
                                    perm_btn.text = "学生"
                                }
                            }
                            FluMenuItem{
                                text: "教师"
                                onClicked: {
                                    modify.usrperm = 2
                                    perm_btn.text = "教师"
                                }
                            }
                            FluMenuItem {
                                text: "管理员"
                                onClicked: {
                                    modify.usrperm = 3
                                    perm_btn.text = "管理员"
                                }
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "专业："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_major
                            text: "0"
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.usrname = parseInt(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            let rr = backend.modifyUserRec4Admin(usrid,usrname,usrpass,usrperm,usrmajor);
            for(let i = 0;i<table_view.dataSource.length;i++){
                if(table_view.dataSource[i].userid === usrid){
                    table_view.dataSource[i].name = usrname
                    table_view.dataSource[i].permission = usrperm
                    table_view.dataSource[i].password = usrpass
                    break
                }
            }
            modify.close()
        }
    }
    FluContentDialog{
        id: add_crs
        title: "新增用户信息"
        property var usrname
        property var usrid
        property var usrpass
        property var usrperm
        property var usrmajor

        negativeText: "取消"
        positiveText: "确定"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 200
                anchors.fill: parent
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        FluText{
                            text: "学/工号："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_id
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_crs.usrid = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "姓名："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_name
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_crs.usrname = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "密码："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluPasswordBox{
                            id: txt_pwd
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_crs.usrpass = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "类型："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluDropDownButton{
                            id: perm_btn
                            text: "权限"
                            Layout.alignment: Qt.AlignVCenter
                            FluMenuItem{
                                text: "学生"
                                onClicked: {
                                    add_crs.usrperm = 1
                                    perm_btn.text = "学生"
                                }
                            }
                            FluMenuItem{
                                text: "教师"
                                onClicked: {
                                    add_crs.usrperm = 2
                                    perm_btn.text = "教师"
                                }
                            }
                            FluMenuItem {
                                text: "管理员"
                                onClicked: {
                                    add_crs.usrperm = 3
                                    perm_btn.text = "管理员"
                                }
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "专业："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_major
                            text: "0"
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_crs.usrmajor = parseInt(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            console.log(usrid,usrname,usrpass,usrperm,usrmajor);
            let rr = backend.addUserRec4Admin(usrid,usrname,usrpass,usrperm,usrmajor);
            table_view.dataSource.push(root.makeData(rr));
            modify.close()
            showInfo("添加成功")
        }
    }
    FluArea{
        id: ctrl
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 20
        }
        height: 60
        Row{
            spacing: 5
            anchors{
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            FluButton{
                text: "导入用户"
                onClicked: ()=>{
                    showError("未实现")
                }
            }
            FluButton{
                text: "添加用户"
                onClicked: ()=>{
                    add_crs.open()
                }
            }
            FluButton{
                text:"刷新"
                onClicked: ()=>{
                    loadData()
                }
            }
        }
    }
    FluTableView{
        id:table_view
        anchors{
            left: parent.left
            right: parent.right
            top: ctrl.bottom
            bottom: parent.bottom
        }
        anchors.topMargin: 5
        anchors.bottomMargin: 50
        onRowsChanged: {
            root.checkBoxChanged()
        }
        columnSource:[
            {
                title: table_view.customItem(com_column_checbox,{checked:false}),
                dataIndex: 'checkbox',
                width:100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: "用户名",
                dataIndex: "userid",
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: table_view.customItem(com_column_filter_name,{title:"姓名"}),
                dataIndex: 'name',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: table_view.customItem(com_column_sort_score,{sort:0}),
                dataIndex: 'permission',
                width:100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: "密码(加密后)",
                dataIndex: 'password',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "操作",
                dataIndex: 'action',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            }
        ]
    }
    function makeData(data){
        return {
            checkbox: table_view.customItem(com_checbox,{checked: false}),
            userid: data.userid,
            name: data.name,
            permission: data.permission,
            password: data.password,
            action: table_view.customItem(com_action,{})
        };
    }
    function loadData(){
        let datas = backend.getUserList4Admin(nameKeyword);
        const dataSource = []
        for(let data of datas){
            dataSource.push(makeData(data));
        }
        root.dataSource = dataSource
        table_view.dataSource = root.dataSource
    }
}
