import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage{

    id:root
    title: "成绩列表"
    signal checkBoxChanged

    property var dataSource : []
    property var courseList: []
    property int sortType: 0
    property bool seletedAll: true
    property int courseid: -1
    property var nameKeyword : ""
    onNameKeywordChanged: {
        loadData()
    }
    Component.onCompleted: {
        loadData()
    }
    onCourseidChanged: {
        table_view.closeEditor()
        var data = []
        for (var i = 0; i < dataSource.length; i++) {
            var item = dataSource[i];
            if (courseid === -1 || item.courseid === courseid) {
                data.push(item);
            }
        }
        table_view.dataSource = data
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

    FluContentDialog{
        id: modify
        title: "修改成绩"
        property var onAcceptListener
        property var scoreInfo
        negativeText: "取消"
        positiveText: "确定"
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 60
                FluTextBox{
                    id: txt
                    text: modify.scoreInfo.score
                    anchors.centerIn: parent
                    onTextChanged: {
                        modify.scoreInfo.score = text
                    }
                }
                Component.onCompleted: {
                    txt.text = modify.scoreInfo.score
                    txt.forceActiveFocus()
                }
            }
        }
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onPositiveClicked: ()=>{
            backend.changeScoreRec4Tea(modify.scoreInfo.scoreid,modify.scoreInfo.score)
            table_view.dataSource.forEach((item,index)=>{
                if(item.scoreid === modify.scoreInfo.scoreid){
                    item.score = modify.scoreInfo.score
                    table_view.setRow(index,item)
                }
            })
            modify.close()
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
                        backend.deleteScoreRec4Tea(table_view.getRow(row).scoreid)
                        table_view.removeRow(row)
                    }
                }
                FluFilledButton{
                    text: "编辑"
                    onClicked: ()=>{
                        modify.scoreInfo = table_view.getRow(row)
                        modify.open()
                    }
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
                    text: qsTr("Select All")
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
    FluMenu{
        id:pop_filter_name
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
                id:name_filter_txt
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
                    root.nameKeyword = name_filter_txt.text
                    pop_filter.close()
                }
            }

        }
        function showPopup(){
            table_view.closeEditor()
            pop_filter_name.popup()
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
                    pop_filter_name.showPopup()
                }
            }
        }
    }
    FluArea{
        id:layout_controls
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
            FluText{
                text: "课程："
                Layout.alignment: Qt.AlignVCenter
            }
            FluDropDownButton{
                id: sel_btn
                text:"选择课程"
                Layout.alignment: Qt.AlignVCenter
                FluMenuItem{
                    text: "全部"
                    onClicked: ()=>{
                        sel_btn.text = "选择课程"
                        root.courseid = -1
                    }
                }
                Repeater{
                    model: root.courseList
                    FluMenuItem{
                        text: modelData.title
                        onClicked: ()=>{
                            sel_btn.text = text
                            root.courseid = modelData.courseid
                        }
                    }
                }
            }
            FluButton{
                text: "导入成绩"
                onClicked: ()=>{
                    showError("未实现")
                }
            }
            FluButton{
                text: "添加成绩"
                onClicked: ()=>{
                    add_score.open()
                }
            }
        }
    }
    FluContentDialog{
        id: add_score
        title: "添加成绩"
        property var usrname
        property var courseid
        property var score
        negativeText: "取消"
        positiveText: "确定"
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 100
                anchors.fill: parent
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        FluText{
                            text: "课程："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluDropDownButton{
                            id: sel_btn
                            text:"选择课程"
                            Layout.alignment: Qt.AlignVCenter
                            Repeater{
                                model: root.courseList
                                FluMenuItem{
                                    text: modelData.title
                                    onClicked: ()=>{
                                        sel_btn.text = text
                                        add_score.courseid = modelData.courseid
                                    }
                                }
                            }
                        }
                    }
                    Row{
                        FluText{
                            text: "学生："
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox{
                            id: txt_name
                            Layout.fillWidth: true
                            onTextChanged: {
                                add_score.usrname = text
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
                                add_score.score = parseInt(text)
                            }
                        }
                    }
                }
            }
        }
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onPositiveClicked: ()=>{
            let uid = backend.findStudentIdByName(usrname);
            if(uid === "")add_score.close()
            let d = backend.addScoreRec4Tea(courseid,uid,score);
            table_view.dataSource.push({
                courseid: courseid,
                scoreid: d.scoreid,
                title: sel_btn.text,
                name: usrname,
                score: score,
                term: d.term,
                action: table_view.customItem(com_action,{})
            });
            add_score.close()
        }
    }
    FluTableView{
        id:table_view
        anchors{
            left: parent.left
            right: parent.right
            top: layout_controls.bottom
            bottom: parent.bottom
        }
        anchors.topMargin: 5
        anchors.bottomMargin: 50
        onRowsChanged: ()=>{
            root.checkBoxChanged()
        }
        columnSource:[
            {
                title: "课程名",
                dataIndex: 'title',
                width: 625,
                minimumWidth:625,
                maximumWidth:625
            },
            {
                title: table_view.customItem(com_column_filter_name,{}),
                dataIndex: 'name'
            },
            {
                title: "分数",
                dataIndex: 'score',
                width:80,
                minimumWidth:80,
                maximumWidth:80
            },
            {
                title: "学期",
                dataIndex: 'term',
                width:80,
                minimumWidth:80,
                maximumWidth:80
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
    function loadData(){
        courseList = backend.getCourseList4Tea("");
        let data = [],dt=[]
        for(let r of courseList){
            data = backend.getStudentScoreList4Tea(r.courseid,nameKeyword);
            for(let s of data){
                dt.push({
                    // checkbox: table_view.customItem(com_checbox,{checked:true}),
                    courseid: r.courseid,
                    scoreid: s.scoreid,
                    title: r.title,
                    name: s.name,
                    score: s.score,
                    term: r.term,
                    action: table_view.customItem(com_action,{})
                })
            }
        }
        dataSource = dt
        table_view.dataSource = root.dataSource
    }
}
