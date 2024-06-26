//
// Created by 22984 on 24-4-9.
//
#include "backendManager.h"
#include "const.h"
using std::max;
//封装md5操作
QString md5(QString str){
    return QString(QCryptographicHash::hash(str.toUtf8(),QCryptographicHash::Md5).toHex());
}
//封装sha256
QString sha256(QString str){
    return QString(QCryptographicHash::hash(str.toUtf8(),QCryptographicHash::Sha256).toHex());
}
//封装绩点计算
double calcGPA(int score){//映射成绩和绩点
    if(score >= 90)return 4.0;
    if(score >= 87)return 3.7;
    if(score >= 83)return 3.3;
    if(score >= 80)return 3.0;
    if(score >= 77)return 2.7;
    if(score >= 73)return 2.3;
    if(score >= 70)return 2.0;
    if(score >= 67)return 1.7;
    if(score >= 63)return 1.3;
    if(score >= 60)return 1.0;
    return 0;
}

QString getMajor(int major){//映射专业代号和专业名字
    if(major == 55)return "软件工程";
    if(major == 21)return "计算机科学与技术";
    if(major == 87)return "食品工程";
    return "Unknown";
}

const char *toNewConstChar(QString str){
    auto cstr = (char *)malloc(str.length()+1);
    strcpy(cstr,str.toStdString().c_str());
    return cstr;
}
//---------------------------------START Init & Save LinkedList-----------------------------------
void backendManager::initCourse(){
    qDebug()<<"[INFO] Initalize Course Table";
    auto list = makeList();
    FILE *fp = open_file("course.txt","r");
    char *line;
    while((line = read_line(fp))!=NULL){
        auto course = (Course *)malloc(sizeof(Course));
        course->courseid = atoi(strtok(line,","));
        this->cidx = max(cidx,course->courseid);
        course->teacherid = strtok(NULL,",");
        course->title = strtok(NULL,",");
        course->term = atoi(strtok(NULL,","));
        course->power = atof(strtok(NULL,","));
        insertList(list,course);
    }
    qDebug()<<"[DEBUG] initCourse:"<<sizeList(list)<<"courses loaded.";
    this->courselist = list;
    close_file(fp);
}
void backendManager::saveCourse() {
    FILE *fp = open_file("course.txt", "w");
    for(int i=0;i<sizeList(this->courselist);i++){
        Course *course=(Course *)getListNode(this->courselist,i);
        fprintf(fp,"%d,%s,%s,%d,%.2lf\n",course->courseid,course->teacherid,course->title,course->term,course->power);
    }
    qDebug()<<"[INFO] Save Course Table";
    close_file(fp);
}
Course* backendManager::getCourse(int courseid){
    for(int i = 0; i < sizeList(this->courselist); i++){
        auto course = (Course *)getListNode(this->courselist,i);
        if(course->courseid == courseid){
            return course;
        }
    }
    return NULL;
}

void backendManager::initUser(){
    qDebug()<<"[INFO] Initialize User Table";
    auto list = makeList();
    FILE *fp = open_file("user.txt","r");
    char *line;
    while((line = read_line(fp))!=NULL){
        auto user = (User *)malloc(sizeof(User));
        user->userid = strtok(line,",");
        user->name = strtok(NULL,",");
        user->password = strtok(NULL,",");
        user->permission = atoi(strtok(NULL,","));
        user->major = atoi(strtok(NULL,","));
        insertList(list,user);
    }
    if(sizeList(list)==0){
        auto user = (User *)malloc(sizeof(User));
        user->userid = "admin";
        user->password = "21232f297a57a5a743894a0e4a801fc3";
        user->permission = 3;
        user->name = "管理员";
        user->major = 0;
        insertList(list,user);
    }
    qDebug()<<"[DEBUG] initUser:"<<sizeList(list)<<"users loaded.";
    this->userList = list;
    close_file(fp);
}
User* backendManager::getUser(const char *userid){
    for(int i = 0; i < sizeList(this->userList); i++){
        User *user = (User *)getListNode(this->userList,i);
        if(strcmp(user->userid,userid) == 0){
            return user;
        }
    }
    return NULL;
}
void backendManager::saveUser() {
    FILE *fp = open_file("user.txt", "w");
    for(int i=0;i<sizeList(userList);i++){
        User *user=(User *)getListNode(userList,i);
        fprintf(fp,"%s,%s,%s,%d,%d\n",user->userid,user->name,user->password,user->permission,user->major);
    }
    qDebug()<<"[INFO] Save User Table";
    close_file(fp);
}
void backendManager::deleteUser(const char *userid){
    for(int i = 0; i < sizeList(this->userList); i++){
        User *user = (User *)getListNode(this->userList,i);
        if(strcmp(user->userid,userid) == 0){
            deleteList(this->userList,user);
            return;
        }
    }
}

void backendManager::initScore(){
    qDebug()<<"[INFO] Initialize Score Table";
    this->scoreidx = 0;
    auto list = makeList();
    FILE *fp = open_file("score.txt","r");
    char *line;
    while((line = read_line(fp))!=NULL){
        auto score = (Score *)malloc(sizeof(Score));
        score->scoreid = atoi(strtok(line,","));
        this->scoreidx = max(scoreidx,score->scoreid);
        score->courseid = atoi(strtok(NULL,","));
        score->studentid = strtok(NULL,",");
        score->score = atoi(strtok(NULL,","));
        insertList(list,score);
    }
    qDebug()<<"[DEBUG] initScore:"<<sizeList(list)<<"scores loaded.";
    this->scorelist = list;
    close_file(fp);
}
void backendManager::saveScore(){
    FILE *fp = open_file("score.txt", "w");
    for(int i=0;i<sizeList(this->scorelist);i++){
        Score *score=(Score *)getListNode(this->scorelist,i);
        fprintf(fp,"%d,%d,%s,%d\n",score->scoreid,score->courseid,score->studentid,score->score);
    }
    qDebug()<<"[INFO] Save Score Table";
    close_file(fp);
}

void backendManager::initExtra(){
    auto fp = open_file("extrainfo.txt","r");
    auto alist = makeList();
    auto plist = makeList();
    auto clist = makeList();
    char *line;
    while((line = read_line(fp))!=NULL){
        char *type = strtok(line,",");
        if(strcmp(type,"article") == 0){
            auto article = (Article *)malloc(sizeof(Article));
            article->aid = atoi(strtok(NULL,","));
            this->aidx = max(aidx,article->aid);
            article->studentid = strtok(NULL,",");
            article->title = strtok(NULL,",");
            article->nauthor = atoi(strtok(NULL,","));
            article->author = (char **)malloc(sizeof(char *)*article->nauthor);
            for(int i=0;i<article->nauthor;i++){
                article->author[i] = strtok(NULL,",");
                if(strcmp(article->author[i],"(null)")==0){
                    article->author[i] = (char *)malloc(1);
                    article->nauthor = 0;
                    strcpy(article->author[i],"\0");
                    break;
                }
            }
            article->journal = strtok(NULL,",");
            article->time = strtok(NULL,",");
            article->paperNum = atoi(strtok(NULL,","));
            article->volIssue = atoi(strtok(NULL,","));
            article->pageRange = strtok(NULL,",");
            article->level = strtok(NULL,",");
            article->score = atof(strtok(NULL,","));
            insertList(alist,article);
        }
        else if(strcmp(type,"project") == 0){
            auto project = (Project *)malloc(sizeof(Project));
            project->pid = atoi(strtok(NULL,","));
            this->pidx = max(pidx,project->pid);
            project->studentid = strtok(NULL,",");
            project->name = strtok(NULL,",");
            project->leader = strtok(NULL,",");
            project->nmember = atoi(strtok(NULL,","));
            project->member = (char **)malloc(sizeof(char *)*project->nmember);
            for(int i=0;i<project->nmember;i++){
                project->member[i] = strtok(NULL,",");
                if(strcmp(project->member[i],"(null)")==0) {
                    project->member[i] = (char *) malloc(1);
                    project->nmember = 0;
                    strcpy(project->member[i], "\0");
                    break;
                }
            }
            project->starttime = strtok(NULL,",");
            project->endtime = strtok(NULL,",");
            project->score = atof(strtok(NULL,","));
            insertList(plist,project);
        }
        else if(strcmp(type,"competition") == 0){
            auto competition = (Competition *)malloc(sizeof(Competition));
            competition->cid = atoi(strtok(NULL,","));
            this->coidx = max(coidx,competition->cid);
            competition->studentid = strtok(NULL,",");
            competition->name = strtok(NULL,",");
            competition->level = strtok(NULL,",");
            competition->organizer = strtok(NULL,",");
            competition->nstudent = atoi(strtok(NULL,","));
            competition->student = (char **)malloc(sizeof(char *)*competition->nstudent);
            for(int i=0;i<competition->nstudent;i++){
                competition->student[i] = strtok(NULL,",");
                if(strcmp(competition->student[i],"(null)")==0){
                    competition->student[i] = (char *)malloc(1);
                    competition->nstudent = 0;
                    strcpy(competition->student[i],"\0");
                    break;
                }
            }
            competition->time = strtok(NULL,",");
            competition->score = atof(strtok(NULL,","));
            insertList(clist,competition);
        }
    }
    close_file(fp);
    this->articlelist = alist;
    this->projectlist = plist;
    this->competitionlist = clist;
    qDebug()<<"[DEBUG] Initialize Extra Table: "<<sizeList(alist)<<"articles,"<<sizeList(plist)<<"projects,"<<sizeList(clist)<<"competitions.";
}
void backendManager::saveExtra(){
    auto fp = open_file("extrainfo.txt","w");
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        fprintf(fp,
                "article,%d,%s,%s,%d",
                article->aid,
                article->studentid,
                article->title,
                article->nauthor
        );
        for(int j=0;j<article->nauthor;j++){
            fprintf(fp,",%s",article->author[j]);
        }
        fprintf(fp,",%s,%s,%d,%d,%s,%s,%.2lf\n",
                article->journal,
                article->time,
                article->paperNum,
                article->volIssue,
                article->pageRange,
                article->level,
                article->score
        );
    }
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        fprintf(fp,
                "project,%d,%s,%s,%s,%d",
                project->pid,
                project->studentid,
                project->name,
                project->leader,
                project->nmember
        );
        for(int j=0;j<project->nmember;j++){
            fprintf(fp,",%s",project->member[j]);
        }
        fprintf(fp,",%s,%s,%.2lf\n",
                project->starttime,
                project->endtime,
                project->score
        );
    }
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist, i);
        fprintf(fp,
                "competition,%d,%s,%s,%s,%s,%d",
                competition->cid,
                competition->studentid,
                competition->name,
                competition->level,
                competition->organizer,
                competition->nstudent
        );
        for(int j=0;j<competition->nstudent;j++){
            fprintf(fp,",%s",competition->student[j]);
        }
        fprintf(fp,",%s,%.2lf\n",
                competition->time,
                competition->score
        );
    }
    close_file(fp);
}
//---------------------------------END   Init & Save LinkedList-----------------------------------

//---------------------------------START Basic Functions -----------------------------------------
backendManager::backendManager() {
    qDebug()<<"[INFO] BackendManager initalizing Started.";
    this->initUser();
    this->initCourse();
    this->initScore();
    this->initExtra();
    qDebug()<<"[INFO] BackendManager initialized.";
}
backendManager::~backendManager() {
    this->saveUser();
    this->saveCourse();
    this->saveScore();
    this->saveExtra();
    qDebug()<<"[INFO] BackendManager destroyed.";
    freeList(this->userList);
    freeList(this->scorelist);
//    freeList(this->extralist);
}
//---------------------------------END   Basic Functions -----------------------------------------
//---------------------------------START Account Related -----------------------------------------
int backendManager::login(QString username, QString password){
    if(this->username != ""){
        qDebug()<<"[INFO] User"<<this->username<<"already logged in.";
        return 0;
    }
    qDebug()<<"[INFO] User"<<username<<"attempt to login.";
    auto usrptr = toNewConstChar(username);
    auto *user = this->getUser(usrptr);
    if(user != NULL) {
        if(strcmp(user->password, toNewConstChar(md5(password))) == 0){
            this->username = username;
            this->password = md5(password);
            this->permission = user->permission;
            qDebug()<<"[INFO] User"<<username<<"login success.";
            return user->permission;
        }
        qDebug()<<"[INFO] Password incorrect.";
        return 0;
    }
    qDebug()<<"[INFO] User not found.";
    //用户不存在
    delete usrptr;
    return -1;
}
int backendManager::logout(){
    qDebug()<<"[INFO] User"<<this->username<<"logout.";
    this->username = "";
    this->password = "";
    this->permission = -1;
    return 0;
}
int backendManager::resetPassword(QString username,QString oPass,QString nPass){
    auto usrptr = toNewConstChar(username);

    qDebug()<<"[INFO] User"<<username<<"attempts to reset password.";
    auto *user = this->getUser(usrptr);
    if(user == NULL)return -1;
    if(strcmp(user->password,toNewConstChar(md5(oPass))) == 0){
        user->password = const_cast<char *>(toNewConstChar(md5(nPass)));
        delete usrptr;
        return 0;
    }
    delete usrptr;
    return -1;
}
// Get private attribute permission.
int backendManager::getPermission() {
    return this->permission;
}
// Get user info, as json
QJsonObject backendManager::getUserInfo(){
    auto usrptr = toNewConstChar(this->username);
    auto user = this->getUser(usrptr);
    QJsonObject obj;
    if(user != NULL){
        obj.insert("userid",user->userid);
        obj.insert("name",user->name);
        obj.insert("permission",user->permission);
        obj.insert("major",user->major);
        //头像~用来当占位符的
        obj.insert("avatar","https://cn.gravatar.com/avatar/"+sha256(user->name));
    }
    delete usrptr;
    return obj;
}
//---------------------------------END   Account Related -----------------------------------------
// Get user info by userid, as json
QJsonObject backendManager::getUserInfo(QString userid){
    if(this->permission <= 0)return QJsonObject(); // No permission
    if(userid == "")return QJsonObject(); // Invalid input
    auto usrptr = toNewConstChar(userid);
    auto user = this->getUser(usrptr);
    QJsonObject obj;
    if(user != NULL){
        obj.insert("userid",user->userid);
        obj.insert("name",user->name);
        obj.insert("permission",user->permission);
        obj.insert("major",user->major);
        //头像~用来当占位符的
        obj.insert("avatar","https://cn.gravatar.com/avatar/"+sha256(user->name));
    }
    delete usrptr;
    return obj;
}
// Get course info by courseid, as json
QJsonObject backendManager::getCourseInfo(int courseid){
    if(this->permission <= 0)return QJsonObject(); // No permission
    if(courseid <= 0 || courseid > this->cidx)return QJsonObject(); // Invalid courseid
    auto course = this->getCourse(courseid);
    QJsonObject obj;
    if(course != NULL){
        obj.insert("courseid",course->courseid);
        obj.insert("teacherid",course->teacherid);
        obj.insert("title",course->title);
        obj.insert("term",course->term);
        obj.insert("power",course->power);
    }
    return obj;
}
//Score related
//Read
QJsonArray backendManager::getScoreList4Stu(QString keyword){ //权限 > 1
    if(this->permission <= 0)return QJsonArray(); // No permission
    QJsonArray arr;

    for(int i=0;i< sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        if(strcmp(score->studentid,std::move(this->username.toStdString().c_str())) == 0){
            auto course = this->getCourse(score->courseid);
            if(course == NULL)continue;
            // 如果课程名称不包含关键字，则跳过
            if(!strstr(course->title, std::move(keyword.toStdString().c_str()))&&keyword!="") continue;
            QJsonObject obj;
            obj.insert("courseid",score->courseid);
            obj.insert("studentid",score->studentid);
            obj.insert("scoreid",score->scoreid);
            obj.insert("score",score->score);
            obj.insert("gpa",calcGPA(score->score));
            obj.insert("title",course->title);
            obj.insert("term",course->term);
            obj.insert("power",course->power);
            arr.append(obj);
        }
    }
    return arr;
}
QJsonArray backendManager::getScoreList4Admin(QString keyword){
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        auto course = this->getCourse(score->courseid);
        auto user = this->getUser(score->studentid);
        if(user == NULL)continue;
        if(score == NULL)continue;
        if(course == NULL)continue;
        if(!strstr(user->name,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
        QJsonObject obj;
        obj.insert("courseid",score->courseid);
        obj.insert("studentid",score->studentid);
        obj.insert("scoreid",score->scoreid);
        obj.insert("score",score->score);
        obj.insert("title",course->title);
        obj.insert("term",course->term);
        obj.insert("power",course->power);
        obj.insert("name",user->name);
        obj.insert("major",user->major);
        arr.append(obj);
    }
    qDebug()<<"23";
    return arr;
}
void backendManager::Save(){
    this->saveUser();
    this->saveCourse();
    this->saveScore();
    this->saveExtra();
}
int backendManager::addUserRec4Admin(QString userid, QString name, QString password, int permission, int major) {
    if(this->permission <= 2)return -1; // No permission
    if(userid == "" || name == "" || password == "" || permission < 0 || permission > 3 || major < 0 || major > 100)return -1; // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"add user record:"<<userid<<name<<password<<permission<<major;
    auto *user = (User *)malloc(sizeof(User));
    user->userid = const_cast<char*>(toNewConstChar(userid));
    user->name = const_cast<char*>(toNewConstChar(name));
    user->password = const_cast<char*>(toNewConstChar(md5(password)));
    user->permission = permission;
    user->major = major;
    insertList(this->userList,user);
    return 0;
}
double backendManager::getTotalGPA4Stu(){
    auto scores = this->getScoreList4Stu("");
    double GPA = 0.0;
    double totalPower = 0.0;
    for(auto scoree:scores){
        auto score = scoree.toObject();
        GPA += calcGPA(score["score"].toInt())*score["power"].toDouble();
        totalPower += score["power"].toDouble();
    }
    if(totalPower == 0)return 0;
    return GPA/totalPower;
}
QJsonArray backendManager::getGPAByTerm4Stu() {
    auto scores = this->getScoreList4Stu("");
    double total[9]={};
    double count[9]={};
    for(auto scoret:scores){
        auto score = scoret.toObject();
        total[score["term"].toInt()] += calcGPA(score["score"].toInt()) * score["power"].toDouble();
        count[score["term"].toInt()] += score["power"].toDouble();
    }
    QJsonArray arr;
    for(int i=0;i<9;i++){
        if(count[i] == 0)continue;
        total[i] /= count[i];
        QJsonObject obj;
        obj.insert("term",i);
        obj.insert("GPA",total[i]);
        arr.append(obj);
    }
    return arr;
}
//Write
QJsonObject backendManager::addScoreRec4Tea(QString courseid, QString studentid, int score){
    if(this->permission <= 1)return QJsonObject(); // No permission
    if(courseid == "" || studentid == "" || score < 0 || score > 100)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"add score record:"<<courseid<<studentid<<score;
    auto *scoreit = (Score *)malloc(sizeof(Score));
    scoreit->scoreid = ++this->scoreidx;
    scoreit->courseid = courseid.toInt();
    scoreit->studentid = const_cast<char*>(toNewConstChar(studentid));
    scoreit->score = score;
    insertList(this->scorelist,scoreit);
    QJsonObject obj;
    obj.insert("scoreid",scoreit->scoreid);
    obj.insert("courseid",scoreit->courseid);
    obj.insert("studentid",scoreit->studentid);
    obj.insert("score",scoreit->score);
    obj.insert("term",this->getCourse(scoreit->courseid)->term);
    return obj;
}
int backendManager::deleteScoreRec4Tea(QString sid){
    if(this->permission <= 1)return -1; // No permission
    if(sid == "")return -1; // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"delete score record:"<<sid;
    for(int i=0;i<sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        if(score->scoreid == sid.toInt()){
            deleteList(this->scorelist,score);
            return 0;
        }
    }
    return -1;
}

//User related
//Read
QJsonArray backendManager::getUserList4Admin(QString keyword){
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->userList);i++){
        auto user = (User *)getListNode(this->userList,i);
        if(user == NULL)continue;
        if(!strstr(user->name,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
        QJsonObject obj;
        obj.insert("userid",user->userid);
        obj.insert("name",user->name);
        obj.insert("permission",user->permission);
        obj.insert("major",user->major);
        obj.insert("password",user->password);
        arr.append(obj);
    }
    return arr;
}
QJsonArray backendManager::getStudentScoreList4Tea(int courseid,QString keyword){
    if(this->permission <= 1)return QJsonArray(); // No permission
    if(courseid <= 0 || courseid > this->cidx)return QJsonArray(); // Invalid courseid
    QJsonArray arr;
    auto cid = courseid;
    for(int i=0;i<sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        if(score->courseid == cid){
            auto user = this->getUser(score->studentid);
            if(user == NULL)continue;
            if(!strstr(user->name,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
            QJsonObject obj;
            obj.insert("scoreid",score->scoreid);
            obj.insert("userid",user->userid);
            obj.insert("name",user->name);
            obj.insert("permission",user->permission);
            obj.insert("major",user->major);
            obj.insert("score",score->score);
            arr.append(obj);
        }
    }
    return arr;
}
//WriteW
void backendManager::changeUserInfo(QString name, int major,QString userid) {
    if(this->permission <= 0)return;
    if(userid == "")return;
    qDebug()<<"[INFO] User"<<this->username<<"change user info:"<<name<<major<<userid;
    auto user = this->getUser(std::move(userid).toStdString().c_str());
    if(this->permission == 1){
        user->name = (char *)malloc(name.length()+1);
        strcpy(user->name,name.toStdString().c_str());
//        user->major = major; 学生不能改变专业
        return;
    }
    if(this->permission == 3){
        user->name = (char *)malloc(name.length()+1);
        strcpy(user->name,name.toStdString().c_str());
        user->major = major;
        return;
    }
}
//Course related
QJsonArray backendManager::getCourseList4Tea(QString keyword){
    if(this->permission <= 1)return QJsonArray(); // No permission // for teacher admin
    QJsonArray arr;
    for(int i=0;i<sizeList(this->courselist);i++){
        auto course = (Course *)getListNode(this->courselist,i);
        if(course == NULL)continue;
        if(strcmp(course->teacherid,std::move(this->username).toStdString().c_str()) == 0 || this->permission == 3){
            if(!strstr(course->title,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
            QJsonObject obj;
            obj.insert("courseid",course->courseid);
            obj.insert("teacherid",course->teacherid);
            obj.insert("title",course->title);
            obj.insert("term",course->term);
            obj.insert("average",this->getScoreAverage(course->courseid));
            obj.insert("percentage",this->getCoursePercentage4Tea(course->courseid));
            arr.append(obj);
        }
    }
    return arr;
}
double backendManager::getCoursePercentage4Tea(int courseid) {
    if(this->permission <= 1)return 0; // No permission
    if(courseid <= 0 || courseid > this->cidx)return 0; // Invalid courseid
    int total = 0;
    int count = 0;
    auto scorelist = this->getStudentScoreList4Tea(courseid,"");
    for(auto score:scorelist){
        if( score.toObject()["score"].toInt() >= 60){
            total += 1;
        }
        count += 1;
    }
    if(count == 0)return 0;
    return (double)(total* 100 / count) ;
}
double backendManager::getScoreAverage(int courseid) {
    if(this->permission <= 1)return 0; // No permission
    if(courseid <= 0 || courseid > this->cidx)return 0; // Invalid courseid
    double total = 0;
    int count = 0;
    auto scorelist = this->getStudentScoreList4Tea(courseid,"");
    for(auto score:scorelist){
        total += score.toObject()["score"].toInt();
        count++;
    }
    if(count == 0)return 0;
    return total/count;
}


int backendManager::deleteUserRec4Admin(QString userid) {
    if(this->permission <= 2)return -1; // No permission
    if(userid == "")return -1; // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"delete user record";
    this->deleteUser(toNewConstChar(userid));
    return 0;
}

void backendManager::changeScoreRec4Tea(QString sid, int score) {
    if(this->permission <= 1)return; // No permission
    if(score < 0 || score > 100)return; // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"change score record:"<<sid<<score;
    for(int i=0;i<sizeList(this->scorelist);i++){
        auto scoreit = (Score *)getListNode(this->scorelist,i);
        if(scoreit->scoreid == sid.toInt()){
            scoreit->score = score;
            return;
        }
    }
}

QJsonArray backendManager::getStudentList() {
    if(this->permission <= 1)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->userList);i++){
        auto user = (User *)getListNode(this->userList,i);
        if(user->permission == 1){
            QJsonObject obj;
            obj.insert("userid",user->userid);
            obj.insert("name",user->name);
            obj.insert("major",user->major);
            arr.append(obj);
        }
    }
    return arr;
}

QString backendManager::findStudentIdByName(QString name) {
    if(this->permission <= 1)return ""; // No permission
    if(name == "")return ""; // Invalid input
    for(int i=0;i<sizeList(this->userList);i++){
        auto user = (User *)getListNode(this->userList,i);
        if(strcmp(user->name,std::move(name).toStdString().c_str()) == 0){
            return user->userid;
        }
    }
    return "";
}

QJsonObject backendManager::modifyUserRec4Admin(QString userid, QString name, QString password, int permission, int major) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    if(userid == "" || name == "" || password == "" || permission < 0 || permission > 3 || major < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"modify user record:"<<userid<<name<<password<<permission<<major;
    auto *user = this->getUser(toNewConstChar(userid));
    user->name = const_cast<char*>(toNewConstChar(name));
    user->password = const_cast<char*>(toNewConstChar(md5(password)));
    user->permission = permission;
    user->major = major;
    QJsonObject obj;
    obj.insert("userid",user->userid);
    obj.insert("name",user->name);
    obj.insert("permission",user->permission);
    obj.insert("major",user->major);
    obj.insert("password",user->password);
    return obj;
}

QJsonArray backendManager::getCourseList4Admin(QString keyword) {
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->courselist);i++){
        auto course = (Course *)getListNode(this->courselist,i);
        if(course == NULL)continue;
        if(!strstr(course->title,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
        QJsonObject obj;
        obj.insert("courseid",course->courseid);
        obj.insert("teacherid",course->teacherid);
        auto user = this->getUser(course->teacherid);
        if(user == NULL)continue;
        obj.insert("teachername",user->name);
        obj.insert("title",course->title);
        obj.insert("term",course->term);
        obj.insert("power",course->power);
        arr.append(obj);
    }
    return arr;
}

QJsonArray backendManager::getTeacherList4Admin(QString keyword) {
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->userList);i++){
        auto user = (User *)getListNode(this->userList,i);
        if(user == NULL)continue;
        if(user->permission == 2){
            if(!strstr(user->name,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
            QJsonObject obj;
            obj.insert("userid",user->userid);
            obj.insert("name",user->name);
            arr.append(obj);
        }
    }
    return arr;
}

QJsonObject backendManager::addCourseRec4Admin(QString teacherid, QString title, int term, double power) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    if(teacherid == "" || title == "" || term < 0 || power < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"add course record:"<<teacherid<<title<<term<<power;
    auto *course = (Course *)malloc(sizeof(Course));
    course->courseid = ++this->cidx;
    course->teacherid = const_cast<char*>(toNewConstChar(teacherid));
    course->title = const_cast<char*>(toNewConstChar(title));
    course->term = term;
    course->power = power;
    insertList(this->courselist,course);
    QJsonObject obj;
    obj.insert("courseid",course->courseid);
    obj.insert("teacherid",course->teacherid);
    auto user = this->getUser(course->teacherid);
    if(user == NULL)return QJsonObject();
    obj.insert("teachername",user->name);
    obj.insert("title",course->title);
    obj.insert("term",course->term);
    obj.insert("power",course->power);
    return obj;
}

QJsonArray backendManager::getArticleList4Stu(QString keyword) {
    if(this->permission <= 1)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        if(strcmp(article->studentid,std::move(this->username).toStdString().c_str()) == 0){
            // 如果文章标题或作者不包含关键字，则跳过
            if(!strstr(article->title, std::move(keyword.toStdString().c_str())) && keyword != "") continue;
            QJsonObject obj;
            obj.insert("aid",article->aid);
            obj.insert("studentid",article->studentid);
            obj.insert("title",article->title);
            QJsonArray author;
            for(int j=0;j<article->nauthor;j++){
                author.append(article->author[j]);
            }
            obj.insert("author",author);
            obj.insert("journal",article->journal);
            obj.insert("time",article->time);
            obj.insert("paperNum",article->paperNum);
            obj.insert("volIssue",article->volIssue);
            obj.insert("pageRange",article->pageRange);
            obj.insert("level",article->level);
            obj.insert("score",article->score);
            arr.append(obj);
        }
    }
    return arr;
}
QJsonArray backendManager::getProjectList4Stu(QString keyword) {
    if(this->permission <= 1)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        if(strcmp(project->studentid,std::move(this->username).toStdString().c_str()) == 0){
            // 如果项目名称或领导者不包含关键字，则跳过
            if(!(strstr(project->name, std::move(keyword.toStdString().c_str()))
            || strstr(project->leader, std::move(keyword.toStdString().c_str()))) && keyword != "" ) continue;
            QJsonObject obj;
            obj.insert("pid",project->pid);
            obj.insert("studentid",project->studentid);
            obj.insert("name",project->name);
            obj.insert("leader",project->leader);
            QJsonArray member;
            for(int j=0;j<project->nmember;j++){
                member.append(project->member[j]);
            }
            obj.insert("member",member);
            obj.insert("starttime",project->starttime);
            obj.insert("endtime",project->endtime);
            obj.insert("score",project->score);
            arr.append(obj);
        }
    }
    return arr;
}

QJsonArray backendManager::getCompetitionList4Stu(QString keyword) {
    if(this->permission <= 0)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist,i);
        if(strcmp(competition->studentid,std::move(this->username).toStdString().c_str()) == 0){
// 如果比赛名称不包含关键字，则跳过
            if(!(strstr(competition->name, std::move(keyword.toStdString().c_str()))) && keyword != "") continue;
            QJsonObject obj;
            obj.insert("cid",competition->cid);
            obj.insert("studentid",competition->studentid);
            auto stu = this->getUser(competition->studentid);
            if(stu == NULL)continue;
            obj.insert("studentname",stu->name);
            obj.insert("name",competition->name);
            obj.insert("level",competition->level);
            obj.insert("organizer",competition->organizer);
            QJsonArray student;
            for(int j=0;j<competition->nstudent;j++){
                student.append(competition->student[j]);
            }
            obj.insert("student",student);
            obj.insert("time",competition->time);
            obj.insert("score",competition->score);
            arr.append(obj);
        }
    }
    return arr;
}

QJsonArray backendManager::getArticleList4Admin(QString keyword) {
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        if(!strstr(article->title,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
        QJsonObject obj;
        obj.insert("aid",article->aid);
        obj.insert("studentid",article->studentid);
        auto user = this->getUser(article->studentid);
        if(user == NULL)continue;
        obj.insert("studentname",user->name);
        obj.insert("title",article->title);
        QJsonArray author;
        for(int j=0;j<article->nauthor;j++){
            author.append(article->author[j]);
        }
        obj.insert("author",author);
        obj.insert("journal",article->journal);
        obj.insert("time",article->time);
        obj.insert("paperNum",article->paperNum);
        obj.insert("volIssue",article->volIssue);
        obj.insert("pageRange",article->pageRange);
        obj.insert("level",article->level);
        obj.insert("score",article->score);
        arr.append(obj);
    }
    return arr;
}

QJsonArray backendManager::getProjectList4Admin(QString keyword) {
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        if(!strstr(project->name,std::move(keyword).toStdString().c_str())&&keyword!="") continue;
        QJsonObject obj;
        auto student = this->getUser(project->studentid);
        if(student == NULL)continue;
        obj.insert("pid",project->pid);
        obj.insert("studentid",project->studentid);
        obj.insert("studentname",student->name);
        obj.insert("name",project->name);
        obj.insert("leader",project->leader);
        QJsonArray member;
        for(int j=0;j<project->nmember;j++){
            member.append(project->member[j]);
        }
        obj.insert("member",member);
        obj.insert("starttime",project->starttime);
        obj.insert("endtime",project->endtime);
        obj.insert("score",project->score);
        arr.append(obj);
    }
    return arr;
}

QJsonArray backendManager::getCompetitionList4Admin() {
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist,i);
        QJsonObject obj;
        obj.insert("cid",competition->cid);
        obj.insert("studentid",competition->studentid);
        auto user = this->getUser(competition->studentid);
        if(user == NULL)continue;
        obj.insert("studentname",user->name);
        obj.insert("name",competition->name);
        obj.insert("level",competition->level);
        obj.insert("organizer",competition->organizer);
        QJsonArray student;
        for(int j=0;j<competition->nstudent;j++){
            student.append(competition->student[j]);
        }
        obj.insert("student",student);
        obj.insert("time",competition->time);
        obj.insert("score",competition->score);
        arr.append(obj);
    }
    return arr;
}

double backendManager::getBonusGPA4Stu() {
    if(this->permission <= 0)return 0; // No permission
    qDebug()<<"[INFO] User"<<this->username<<"get bonus GPA.";
    double GPA = 0.0;
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        if(strcmp(article->studentid,std::move(this->username).toStdString().c_str()) == 0){
            GPA += article->score;
        }
    }
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        if(strcmp(project->studentid,std::move(this->username).toStdString().c_str()) == 0){
            GPA += project->score;
        }
    }
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist,i);
        if(strcmp(competition->studentid,std::move(this->username).toStdString().c_str()) == 0){
            GPA += competition->score;
        }
    }
    return GPA;
}

int backendManager::getRank4Stu() {
    if(this->permission <= 0)return 0; // No permission
    auto GPA = this->getTotalGPA4Stu() + this->getBonusGPA4Stu();
    int rank = 1;
    for(int i=0;i<sizeList(this->userList);i++){
        auto user = (User *)getListNode(this->userList,i);
        if(user->permission == 1){
            auto userGPA = this->getTotalGPA4Stu(user->userid) + this->getBonusGPA4Stu(user->userid);
            if(userGPA > GPA){
                rank++;
            }
        }
    }
    return rank;
}

double backendManager::getTotalGPA4Stu(QString userid) {
    if(this->permission <= 1)return 0; // No permission
    auto scores = this->getScoreList4Stu("");
    double GPA = 0.0;
    double totalPower = 0.0;
    for(auto scoree:scores){
        auto score = scoree.toObject();
        if(strcmp(score["userid"].toString().toStdString().c_str(),std::move(userid).toStdString().c_str()) == 0){
            GPA += calcGPA(score["score"].toInt())*score["power"].toDouble();
            totalPower += score["power"].toDouble();
        }
    }
    if(totalPower == 0)return 0;
    return GPA/totalPower;
}

double backendManager::getBonusGPA4Stu(QString userid) {
    if(this->permission <= 1)return 0; // No permission
    double GPA = 0.0;
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        if(strcmp(article->studentid,std::move(userid).toStdString().c_str()) == 0){
            GPA += article->score;
        }
    }
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        if(strcmp(project->studentid,std::move(userid).toStdString().c_str()) == 0){
            GPA += project->score;
        }
    }
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist,i);
        if(strcmp(competition->studentid,std::move(userid).toStdString().c_str()) == 0){
            GPA += competition->score;
        }
    }
    return GPA;
}

QJsonObject
backendManager::changeCompetitionRec4Admin(int cid, QString stuname, QString name, QString level, QString organizer, QString student, QString time, double score) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    auto studentid = this->findStudentIdByName(stuname);
    if(studentid == "" || name == "" || level == "" || organizer == ""  || score < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"change competition record:"<<cid<<studentid<<name<<level<<organizer<<student<<time<<score;
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist,i);
        if(competition->cid == cid){
            competition->studentid = const_cast<char*>(toNewConstChar(studentid));
            competition->name = const_cast<char*>(toNewConstChar(name));
            competition->level = const_cast<char*>(toNewConstChar(level));
            competition->organizer = const_cast<char*>(toNewConstChar(organizer));
            auto t = student.split(",");

            competition->nstudent = t.size();
            competition->student = (char **)malloc(sizeof(char *)*competition->nstudent);
            for(int j=0;j<t.size();j++){
                competition->student[j] = const_cast<char*>(toNewConstChar(t[j]));
            }
            competition->time = const_cast<char*>(toNewConstChar(time));
            competition->score = score;
            QJsonObject obj;
            obj.insert("cid",competition->cid);
            obj.insert("studentid",competition->studentid);
            obj.insert("name",competition->name);
            obj.insert("level",competition->level);
            obj.insert("organizer",competition->organizer);
            QJsonArray studentarr;
            for(int j=0;j<competition->nstudent;j++){
                studentarr.append(competition->student[j]);
            }
            obj.insert("student",studentarr);
            obj.insert("time",competition->time);
            obj.insert("score",competition->score);
            return obj;
        }
    }
}

QJsonObject
backendManager::addCompetitonRec4Admin(QString stuname, QString name, QString level, QString organizer,
                                       QString student, QString time, double score) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    auto studentid = this->findStudentIdByName(stuname);
    if(studentid == "" || name == "" || level == "" || organizer == ""  || score < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"add competition record:"<<studentid<<name<<level<<organizer<<student<<time<<score;
    auto *competition = (Competition *)malloc(sizeof(Competition));
    competition->cid = ++this->cidx;
    competition->studentid = const_cast<char*>(toNewConstChar(studentid));
    competition->name = const_cast<char*>(toNewConstChar(name));
    competition->level = const_cast<char*>(toNewConstChar(level));
    competition->organizer = const_cast<char*>(toNewConstChar(organizer));
    auto t = student.split(",");
    if(student == ""){
        competition->nstudent = 0;
        competition->student = (char **)malloc(sizeof(char *));
        competition->student[0] = const_cast<char*>(toNewConstChar(""));
    }
    competition->nstudent = t.size();
    competition->student = (char **)malloc(sizeof(char *)*t.size());
    auto studentptr = const_cast<char*>(toNewConstChar(student));
    for(int j=0;j<t.size();j++){
        competition->student[j] = strtok(studentptr,",");
    }
    competition->time = const_cast<char*>(toNewConstChar(time));
    competition->score = score;
    insertList(this->competitionlist,competition);
    QJsonObject obj;
    obj.insert("cid",competition->cid);
    obj.insert("studentid",competition->studentid);
    obj.insert("name",competition->name);
    obj.insert("level",competition->level);
    obj.insert("organizer",competition->organizer);
    obj.insert("nstudent",competition->nstudent);
    QJsonArray studentarr;
    for(int j=0;j<competition->nstudent;j++){
        studentarr.append(competition->student[j]);
    }
    obj.insert("student",studentarr);
    obj.insert("time",competition->time);
    obj.insert("score",competition->score);
    return obj;
}

bool backendManager::canApplyGraduate4Stu() {
    return this->getTotalGPA4Stu() + this->getBonusGPA4Stu() >= 3.6;
}

QJsonObject
backendManager::addProjectRec4Admin(QString stuname, QString name, QString leader, QString member, QString starttime,
                                    QString endtime, double score) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    auto studentid = this->findStudentIdByName(stuname);
    if(studentid == "" || name == "" || leader == "" || member == "" || score < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"add project record:"<<studentid<<name<<leader<<member<<starttime<<endtime<<score;
    auto *project = (Project *)malloc(sizeof(Project));
    project->pid = ++this->pidx;
    project->studentid = const_cast<char*>(toNewConstChar(studentid));
    project->name = const_cast<char*>(toNewConstChar(name));
    project->leader = const_cast<char*>(toNewConstChar(leader));
    auto t = member.split(",");
    if(member == ""){
        project->nmember = 0;
        project->member = (char **)malloc(sizeof(char *));
        project->member[0] = const_cast<char*>(toNewConstChar(""));
    }
    project->nmember = t.size();

    project->member = (char **)malloc(sizeof(char *)*t.size());
    auto memberptr = const_cast<char*>(toNewConstChar(member));
    for(int j=0;j<t.size();j++){
        project->member[j] = strtok(memberptr,",");
    }
    project->starttime = const_cast<char*>(toNewConstChar(starttime));
    project->endtime = const_cast<char*>(toNewConstChar(endtime));
    project->score = score;
    insertList(this->projectlist,project);
    QJsonObject obj;
    obj.insert("pid",project->pid);
    obj.insert("studentid",project->studentid);
    obj.insert("student",this->getUser(studentid.toStdString().c_str())->name);
    obj.insert("name",project->name);
    obj.insert("leader",project->leader);
    obj.insert("nmember",project->nmember);
    QJsonArray memberarr;
    for(int j=0;j<project->nmember;j++){
        memberarr.append(project->member[j]);
    }
    obj.insert("member",memberarr);
    obj.insert("starttime",project->starttime);
    obj.insert("endtime",project->endtime);
    obj.insert("score",project->score);
    return obj;
}

void backendManager::deleteCompetitonRec4Admin(int cid) {
    if(this->permission <= 2)return; // No permission
    qDebug()<<"[INFO] User"<<this->username<<"delete competition record:"<<cid;
    for(int i=0;i<sizeList(this->competitionlist);i++){
        auto competition = (Competition *)getListNode(this->competitionlist,i);
        if(competition->cid == cid){
            deleteList(this->competitionlist,competition);
            return;
        }
    }
}

void backendManager::deleteProjectRec4Admin(int pid) {
    if(this->permission <= 2)return; // No permission
    qDebug()<<"[INFO] User"<<this->username<<"delete project record:"<<pid;
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        if(project->pid == pid){
            deleteList(this->projectlist,project);
            return;
        }
    }
}

void backendManager::deleteArticleRec4Admin(int aid) {
    if(this->permission <= 2)return; // No permission
    qDebug()<<"[INFO] User"<<this->username<<"delete article record:"<<aid;
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        if(article->aid == aid){
            deleteList(this->articlelist,article);
            return;
        }
    }
}

QJsonObject
backendManager::addArticleRec4Admin(QString stuname, QString title, QString author, QString journal, QString time,
                                    int paperNum, int volIssue, QString pageRange, QString level, double score) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    auto studentid = this->findStudentIdByName(stuname);
    if(studentid == "" || title == "" || author == "" || journal == "" || time == "" || paperNum < 0 || volIssue < 0 || score < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"add article record:"<<studentid<<title<<author<<journal<<time<<paperNum<<volIssue<<pageRange<<level<<score;
    auto *article = (Article *)malloc(sizeof(Article));
    article->aid = ++this->aidx;
    article->studentid = const_cast<char*>(toNewConstChar(studentid));
    article->title = const_cast<char*>(toNewConstChar(title));
    auto t = author.split(",");
    if(author == ""){
        article->nauthor = 0;
        article->author = (char **)malloc(sizeof(char *));
        article->author[0] = const_cast<char*>(toNewConstChar(""));
    }
    article->nauthor = t.size();
    article->author = (char **)malloc(sizeof(char *)*t.size());
    auto authorptr = const_cast<char*>(toNewConstChar(author));
    for(int j=0;j<t.size();j++){
        article->author[j] = strtok(authorptr,",");
    }
    article->journal = const_cast<char*>(toNewConstChar(journal));
    article->time = const_cast<char*>(toNewConstChar(time));
    article->paperNum = paperNum;
    article->volIssue = volIssue;
    article->pageRange = const_cast<char*>(toNewConstChar(pageRange));
    article->level = const_cast<char*>(toNewConstChar(level));
    article->score = score;
    insertList(this->articlelist,article);
    QJsonObject obj;
    obj.insert("aid",article->aid);
    obj.insert("studentid",article->studentid);
    obj.insert("student",this->getUser(studentid.toStdString().c_str())->name);
    obj.insert("title",article->title);
    obj.insert("nauthor",article->nauthor);
    QJsonArray authorarr;
    for(int j=0;j<article->nauthor;j++){
        authorarr.append(article->author[j]);
    }
    obj.insert("author",authorarr);
    obj.insert("journal",article->journal);
    obj.insert("time",article->time);
    obj.insert("paperNum",article->paperNum);
    obj.insert("volIssue",article->volIssue);
    obj.insert("pageRange",article->pageRange);
    obj.insert("level",article->level);
    obj.insert("score",article->score);
    return obj;
}

QJsonObject
backendManager::changeArticleRec4Admin(int aid, QString stuname, QString title, QString author, QString journal,
                                       QString time, int paperNum, int volIssue, QString pageRange, QString level,
                                       double score) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    auto studentid = this->findStudentIdByName(stuname);
    if(studentid == "" || title == "" || author == "" || journal == "" || time == "" || paperNum < 0 || volIssue < 0 || score < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"change article record:"<<aid<<studentid<<title<<author<<journal<<time<<paperNum<<volIssue<<pageRange<<level<<score;
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        if(article->aid == aid){
            article->studentid = const_cast<char*>(toNewConstChar(studentid));
            article->title = const_cast<char*>(toNewConstChar(title));
            auto t = author.split(",");
            if(author == ""){
                article->nauthor = 0;
                article->author = (char **)malloc(sizeof(char *));
                article->author[0] = const_cast<char*>(toNewConstChar(""));
            }
            article->nauthor = t.size();
            article->author = (char **)malloc(sizeof(char *)*t.size());
            auto authorptr = const_cast<char*>(toNewConstChar(author));
            for(int j=0;j<t.size();j++){
                article->author[j] = strtok(authorptr,",");
            }
            article->journal = const_cast<char*>(toNewConstChar(journal));
            article->time = const_cast<char*>(toNewConstChar(time));
            article->paperNum = paperNum;
            article->volIssue = volIssue;
            article->pageRange = const_cast<char*>(toNewConstChar(pageRange));
            article->level = const_cast<char*>(toNewConstChar(level));
            article->score = score;
            QJsonObject obj;
            obj.insert("aid",article->aid);
            obj.insert("studentid",article->studentid);
            obj.insert("student",this->getUser(studentid.toStdString().c_str())->name);
            obj.insert("title",article->title);
            obj.insert("nauthor",article->nauthor);
            QJsonArray authorarr;
            for(int j=0;j<article->nauthor;j++){
                authorarr.append(article->author[j]);
            }
            obj.insert("author",authorarr);
            obj.insert("journal",article->journal);
            obj.insert("time",article->time);
            obj.insert("paperNum",article->paperNum);
            obj.insert("volIssue",article->volIssue);
            obj.insert("pageRange",article->pageRange);
            obj.insert("level",article->level);
            obj.insert("score",article->score);
            return obj;
        }
    }
}

QJsonObject
backendManager::changeProjectRec4Admin(int pid, QString stuname, QString name, QString leader, QString member,
                                       QString starttime, QString endtime, double score) {
    if(this->permission <= 2)return QJsonObject(); // No permission
    auto studentid = this->findStudentIdByName(stuname);
    if(studentid == "" || name == "" || leader == "" || member == "" || score < 0)return QJsonObject(); // Invalid input
    qDebug()<<"[INFO] User"<<this->username<<"change project record:"<<pid<<studentid<<name<<leader<<member<<starttime<<endtime<<score;
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        if(project->pid == pid){
            project->studentid = const_cast<char*>(toNewConstChar(studentid));
            project->name = const_cast<char*>(toNewConstChar(name));
            project->leader = const_cast<char*>(toNewConstChar(leader));
            auto t = member.split(",");
            if(member == ""){
                project->nmember = 0;
                project->member = (char **)malloc(sizeof(char *));
                project->member[0] = const_cast<char*>(toNewConstChar(""));
            }
            project->nmember = t.size();
            project->member = (char **)malloc(sizeof(char *)*t.size());
            auto memberptr = const_cast<char*>(toNewConstChar(member));
            for(int j=0;j<t.size();j++){
                project->member[j] = strtok(memberptr,",");
            }
            project->starttime = const_cast<char*>(toNewConstChar(starttime));
            project->endtime = const_cast<char*>(toNewConstChar(endtime));
            project->score = score;
            QJsonObject obj;
            obj.insert("pid",project->pid);
            obj.insert("studentid",project->studentid);
            obj.insert("student",this->getUser(studentid.toStdString().c_str())->name);
            obj.insert("name",project->name);
            obj.insert("leader",project->leader);
            obj.insert("nmember",project->nmember);
            QJsonArray memberarr;
            for(int j=0;j<project->nmember;j++){
                memberarr.append(project->member[j]);
            }
            obj.insert("member",memberarr);
            obj.insert("starttime",project->starttime);
            obj.insert("endtime",project->endtime);
            obj.insert("score",project->score);
            return obj;
        }
    }
}
