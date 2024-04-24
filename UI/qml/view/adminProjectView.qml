import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage{

    id:root
    title: "创新项目列表"
    signal checkBoxChanged

    property var dataSource : []
    property int sortType: 0
    property bool seletedAll: false
    property string nameKeyword: ""
    onNameKeywordChanged: ()=>{
        loadData()
    }
    Component.onCompleted: ()=>{
        console.log("[INFO] Loading project");
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
                        modifyProjectDialog.usrid = table_view.getRow(row).userid
                        modifyProjectDialog.open()
                    }
                }
            }
        }
    }
    Component{
        id:com_column_filter_name
        Item{
            FluText{
                text: "标题"
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
        id:com_combobox
        FluComboBox {
            anchors.fill: parent
            focus: true
            editText: display
            editable: true
            model: ListModel {
                ListElement { text: "100" }
                ListElement { text: "300" }
                ListElement { text: "500" }
                ListElement { text: "1000" }
            }
            Component.onCompleted: {
                currentIndex=["100","300","500","1000"].findIndex((element) => element === display)
                selectAll()
            }
            onCommit: {
                editTextChaged(editText)
                tableView.closeEditor()
            }
        }
    }
    Component{
        id:com_column_sort_score
        Item{
            FluText{
                text: "加分"
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
        id: modifyProjectDialog
        title: "修改项目信息"
        property var title
        property var leader
        property var member
        property var startTime
        property var endTime
        property var score
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
                            text: "标题："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_title
                            Layout.fillWidth: true
                            onTextChanged: {
                                modifyProjectDialog.title = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "负责人："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_leader
                            Layout.fillWidth: true
                            onTextChanged: {
                                modifyProjectDialog.leader = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "成员："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_member
                            Layout.fillWidth: true
                            onTextChanged: {
                                modifyProjectDialog.member = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "开始时间："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_startTime
                            Layout.fillWidth: true
                            onTextChanged: {
                                modifyProjectDialog.startTime = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "结束时间："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_endTime
                            Layout.fillWidth: true
                            onTextChanged: {
                                modifyProjectDialog.endTime = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "分数："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_score
                            Layout.fillWidth: true
                            onTextChanged: {
                                modifyProjectDialog.score = parseFloat(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            let data = {
                pid: 0, // You might need to get the pid of the project to be modified
                studentname: "", // You might need to fill this
                title: modifyProjectDialog.title,
                leader: modifyProjectDialog.leader,
                member: modifyProjectDialog.member,
                startTime: modifyProjectDialog.startTime,
                endTime: modifyProjectDialog.endTime,
                score: modifyProjectDialog.score,
                action: table_view.customItem(com_action)
            };
            let newData = makeData(data);
            // You might need to find the index of the project to be modified in the dataSource array
            let index = 0;
            root.dataSource[index] = newData;
            table_view.dataSource = root.dataSource;
            modifyProjectDialog.close();
        }
    }
    FluContentDialog{
        id: addProjectDialog
        title: "新增项目信息"
        property var title
        property var leader
        property var member
        property var startTime
        property var endTime
        property var score
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
                            text: "标题："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_title
                            Layout.fillWidth: true
                            onTextChanged: {
                                addProjectDialog.title = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "负责人："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_leader
                            Layout.fillWidth: true
                            onTextChanged: {
                                addProjectDialog.leader = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "成员："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_member
                            Layout.fillWidth: true
                            onTextChanged: {
                                addProjectDialog.member = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "开始时间："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_startTime
                            Layout.fillWidth: true
                            onTextChanged: {
                                addProjectDialog.startTime = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "结束时间："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_endTime
                            Layout.fillWidth: true
                            onTextChanged: {
                                addProjectDialog.endTime = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "分数："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_score
                            Layout.fillWidth: true
                            onTextChanged: {
                                addProjectDialog.score = parseFloat(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            let data = {
                pid: 0, // You might need to generate a unique pid
                studentname: "", // You might need to fill this
                title: addProjectDialog.title,
                leader: addProjectDialog.leader,
                member: addProjectDialog.member,
                startTime: addProjectDialog.startTime,
                endTime: addProjectDialog.endTime,
                score: addProjectDialog.score,
                action: table_view.customItem(com_action)
            };
            let newData = makeData(data);
            root.dataSource.push(newData);
            table_view.dataSource = root.dataSource;
            addProjectDialog.close();
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
                text: "导入项目"
                onClicked: ()=>{
                    showError("未实现")
                }
            }
            FluButton{
                text: "添加项目"
                onClicked: ()=>{
                    addProjectDialog.open()
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
                title: table_view.customItem(com_column_filter_name,{title:"标题"}),
                dataIndex: 'title',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "负责人",
                dataIndex: 'leader',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "成员",
                dataIndex: 'member',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "开始时间",
                dataIndex: 'startTime',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "结束时间",
                dataIndex: 'endTime',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: table_view.customItem(com_column_sort_score,{title:"加分"}),
                dataIndex: 'score',
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
            pid: data.pid,
            studentname: data.studentname,
            title: data.name,
            leader: data.leader,
            member: JSON.stringify(data.member),
            startTime: data.starttime,
            endTime: data.endtime,
            score: data.score,
            action: table_view.customItem(com_action)
        };
    }
    function loadData(){
        let datas = backend.getProjectList4Admin(nameKeyword);
        const dataSource = []
        for(let data of datas){
            dataSource.push(makeData(data));
        }
        root.dataSource = dataSource
        table_view.dataSource = root.dataSource
    }
}
