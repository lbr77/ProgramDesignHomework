import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage{

    id:root
    title: "论文列表"
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
                text: "成绩"
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
        title: "修改论文信息"
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
                            text: "授课教师"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluDropDownButton{
                            id: teacher_btn
                            text: "教师"
                            Layout.alignment: Qt.AlignVCenter
                            Repeater{
                                model: backend.getTeacherList4Admin("")
                                delegate: FluMenuItem{
                                    text: modelData.name
                                    onClicked: {
                                        modify.usrid = modelData.userid
                                        teacher_btn.text = modelData.name
                                    }
                                }
                            }

                        }
                    }
                    Row{
                        FluText{
                            text: "课程名字："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_name
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.coursename = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "学期："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluDropDownButton{
                            id: term_btn
                            text: "学期"
                            Layout.alignment: Qt.AlignVCenter
                            Repeater{
                                model: [1,2,3,4,5,6,7,8]
                                delegate: FluMenuItem{
                                    text: modelData
                                    onClicked: {
                                        modify.courseterm = modelData
                                        term_btn.text = modelData
                                    }
                                }
                            }

                        }
                    }
                    Row{
                        FluText{
                            text: "学分："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_major
                            text: "0"
                            Layout.fillWidth: true
                            onTextChanged: {
                                modify.usrmajor = parseFloat(text)
                            }
                        }
                    }
                }
            }
        }

        onPositiveClicked: {
            let r = backend.modifyCourseRec4Admin(modify.usrid,modify.coursename,modify.courseterm,modify.usrmajor)
            loadData()
            showInfo("修改成功")
        }
    }
    FluContentDialog{
        id: add_usr
        title: "新增论文信息"
        property var info : {};
        negativeText: "取消"
        positiveText: "确定"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 400
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
                                add_usr.info.stuname = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "论文标题"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_title
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.title = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "作者"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_author
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.author = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "期刊名字"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_journal
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.journal = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "发表时间"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_time
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.time = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "页码"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_paperNum
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.paperNum = parseInt(text)
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "卷"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_volIssue
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.volIssue = parseInt(text)
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "页码范围"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_pageRange
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.pageRange = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "等级"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_level
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.level = text
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "加分"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_score
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_usr.info.score = parseFloat(text)
                            }
                        }
                    }
                }
            }
        }
        Component.onCompleted: {
            add_usr.info = {            stuname: "",
                title: "",
                author: "",
                journal: "",
                time: "",
                paperNum: 0,
                volIssue: 0,
                pageRange: "",
                level: "",
                score: 0.0
            }
        }
        onPositiveClicked: {
            let r = backend.addArticleRec4Admin(add_usr.info.stuname, add_usr.info.title, add_usr.info.author, add_usr.info.journal, add_usr.info.time, add_usr.info.paperNum, add_usr.info.volIssue, add_usr.info.pageRange, add_usr.info.level, add_usr.info.score)
            table_view.dataSource.push(root.makeData(r));
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
                text: "导入论文"
                onClicked: ()=>{
                    showError("未实现")
                }
            }
            FluButton{
                text: "添加论文"
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
                title: table_view.customItem(com_column_filter_name,{title:"标题"}),
                dataIndex: 'title',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "学生",
                dataIndex: "studentname",
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "作者",
                dataIndex: 'author',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "期刊名字",
                dataIndex: 'journal',
                width: 100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: "发表时间",
                dataIndex: 'time',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "页码",
                dataIndex: 'paperNum',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "卷",
                dataIndex: 'volIssue',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },
            {
                title: "等级",
                dataIndex: 'level',
                width: 200,
                minimumWidth:200,
                maximumWidth:200
            },{
                title: '加分',
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
            aid: data.aid,
            studentname: data.studentname,
            title: data.title,
            author: JSON.stringify(data.author),
            journal: data.journal,
            time: data.time,
            paperNum: data.paperNum,
            volIssue: data.volIssue,
            level: data.level,
            score: data.score,
            action: table_view.customItem(com_action,{})
        };
    }
    function loadData(){
        let datas = backend.getArticleList4Admin(nameKeyword);
        const dataSource = []
        for(let data of datas){
            dataSource.push(makeData(data));
        }
        root.dataSource = dataSource
        table_view.dataSource = root.dataSource
    }
}
