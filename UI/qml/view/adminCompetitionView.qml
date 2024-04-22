import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage{

    id:root
    title: "竞赛获奖列表"
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
                text: qsTr("Search")
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
                        backend.deleteCompetitonRec4Admin(table_view.getRow(row).cid)
                        table_view.removeRow(row)
                        showInfo("删除成功")
                    }
                }
                FluFilledButton{
                    text: "编辑"
                    onClicked: ()=>{
                        modify.cid = table_view.getRow(row).cid
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
                text: "奖项"
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
    FluContentDialog{
        id: modify
        title: "修改获奖信息"
        property var cid
        property var stuname
        property var name
        property var level
        property var organizer
        property var student
        property var score

        negativeText: "取消"
        positiveText: "确定"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 300
                anchors.fill: parent
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        FluText{
                            text: "学生姓名"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_stuname
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.stuname = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "奖项名字"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_name
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.name = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "奖项等级"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_level
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.level = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "组织者："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_organizer
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.organizer = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "其他参与者："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_student
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.student = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "加分："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_score
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.score = parseFloat(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            let r = backend.changeCompetitionRec4Admin(modify.cid,modify.stuname,modify.name,modify.level,modify.organizer,modify.student,modify.score)
            loadData()
            showInfo("修改成功")
        }
    }
    FluContentDialog{
        id: add_usr
        title: "新增获奖信息"
        property var cid
        property var stuname
        property var name
        property var level
        property var organizer
        property var student : ""
        property var time : ""
        property var score
        negativeText: "取消"
        positiveText: "确定"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton

        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 300
                anchors.fill: parent
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        FluText{
                            text: "学生姓名"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_stuname
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.stuname = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "奖项名字"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_name
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.name = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "奖项等级"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_level
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.level = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "组织者："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_organizer
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.organizer = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "其他参与者："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_student
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.student = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "时间："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_time
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.time = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "加分："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_score
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.score = parseFloat(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            console.log(stuname,name,level,organizer,student,score)
            let r = backend.addCompetitonRec4Admin(add_usr.stuname,add_usr.name,add_usr.level,add_usr.organizer,add_usr.student,add_usr.time,add_usr.score)
            loadData()
            add_usr.close()
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
                text: "导入奖项"
                onClicked: ()=>{
                    showError("未实现")
                }
            }
            FluButton{
                text: "添加奖项"
                onClicked: ()=>{
                    add_usr.open()
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
                title: "比赛名称",
                dataIndex: "name",
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "奖项等级",
                dataIndex: 'level',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "选手名字",
                dataIndex: 'studentname',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "组织者",
                dataIndex: 'organizer',
                width: 100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: "其他参与者",
                dataIndex: 'student',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "时间",
                dataIndex: 'time',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "加分",
                dataIndex: 'score',
                width: 100,
                minimumWidth:100,
                maximumWidth:100
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
            cid: data.cid,
            name: data.name,
            level: data.level,
            studentname: data.studentname,
            organizer: data.organizer,
            student: JSON.stringify(data.student),
            time: data.time,
            score: data.score,
            action: table_view.customItem(com_action)
        };
    }
    function loadData(){
        let datas = backend.getCompetitionList4Admin(nameKeyword);
        const dataSource = []
        for(let data of datas){
            dataSource.push(makeData(data));
        }
        root.dataSource = dataSource
        table_view.dataSource = root.dataSource
    }
}
