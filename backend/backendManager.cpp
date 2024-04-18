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
    auto fp = open_file("article.txt","r");
    auto alist = makeList();
    auto plist = makeList();
    auto clist = makeList();
    char *line;
    while((line = read_line(fp))!=NULL){
        char *type = strtok(line,",");
        if(strcmp(type,"article") == 0){
            auto article = (Article *)malloc(sizeof(Article));
            article->aid = atoi(strtok(NULL,","));
            article->title = strtok(NULL,",");
            article->author = strtok(NULL,",");
            article->journal = strtok(NULL,",");
            article->releasetime = strtok(NULL,",");
            article->level = strtok(NULL,",");
            article->score = atof(strtok(NULL,","));
            insertList(alist,article);
        }else if(strcmp(type,"project") == 0){
            auto project = (Project *)malloc(sizeof(Project));
            project->pid = atoi(strtok(NULL,","));
            project->members = strtok(NULL,",");
            insertList(plist,project);
        }else if(strcmp(type,"competetion") == 0){
            auto competetion = (Competetion *)malloc(sizeof(Competetion));
            competetion->cid = atoi(strtok(NULL,","));
            insertList(clist,competetion);
        }
    }
    close_file(fp);
    this->articlelist = alist;
    this->projectlist = plist;
    this->competetionlist = clist;
}
void backendManager::saveExtra(){
    auto fp = open_file("article.txt","w");
    for(int i=0;i<sizeList(this->articlelist);i++){
        auto article = (Article *)getListNode(this->articlelist,i);
        fprintf(fp,"article,%d,%s,%s,%s,%s,%s,%.2lf\n",article->aid,article->title,article->author,article->journal,article->releasetime,article->level,article->score);
    }
    for(int i=0;i<sizeList(this->projectlist);i++){
        auto project = (Project *)getListNode(this->projectlist,i);
        fprintf(fp,"project,%d,%s\n",project->pid,project->members);
    }
    for(int i=0;i<sizeList(this->competetionlist);i++){
        auto competetion = (Competetion *)getListNode(this->competetionlist,i);
        fprintf(fp,"competetion,%d\n",competetion->cid);
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
        qDebug()<<"[INFO] User"<<this->username<<"already login.";
        return 0;
    }
    qDebug()<<"[INFO] User"<<username<<"attempts login.";
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
QJsonArray backendManager::getScoreList4Stu(){ //权限 > 1
    if(this->permission <= 0)return QJsonArray(); // No permission
    QJsonArray arr;

    for(int i=0;i< sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        if(strcmp(score->studentid,std::move(this->username.toStdString().c_str())) == 0){
            QJsonObject obj;
            obj.insert("courseid",score->courseid);
            obj.insert("studentid",score->studentid);
            obj.insert("scoreid",score->scoreid);
            obj.insert("score",score->score);
            obj.insert("gpa",calcGPA(score->score));
            auto course = this->getCourse(score->courseid);
            if(course == NULL)continue;
            obj.insert("title",course->title);
            obj.insert("term",course->term);
            obj.insert("power",course->power);
            arr.append(obj);
        }
    }
    return arr;
}
QJsonArray backendManager::getScoreList4Admin(){
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        QJsonObject obj;
        obj.insert("courseid",score->courseid);
        obj.insert("studentid",score->studentid);
        obj.insert("scoreid",score->scoreid);
        obj.insert("score",score->score);
        auto course = this->getCourse(score->courseid);
        obj.insert("title",course->title);
        obj.insert("term",course->term);
        obj.insert("power",course->power);
        auto user = this->getUser(score->studentid);
        obj.insert("name",user->name);
        obj.insert("major",user->major);
        arr.append(obj);
    }
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
    auto scores = this->getScoreList4Stu();
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
    auto scores = this->getScoreList4Stu();
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
QJsonArray backendManager::getUserList4Admin(){
    if(this->permission <= 2)return QJsonArray(); // No permission
    QJsonArray arr;
    for(int i=0;i<sizeList(this->userList);i++){
        auto user = (User *)getListNode(this->userList,i);
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
QJsonArray backendManager::getStudentScoreList4Tea(int courseid){
    if(this->permission <= 1)return QJsonArray(); // No permission
    QJsonArray arr;
    auto cid = courseid;
    for(int i=0;i<sizeList(this->scorelist);i++){
        auto score = (Score *)getListNode(this->scorelist,i);
        if(score->courseid == cid){
            auto user = this->getUser(score->studentid);
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
QJsonArray backendManager::getCourseList4Tea(){
    if(this->permission <= 1)return QJsonArray(); // No permission // for teacher admin
    QJsonArray arr;
    for(int i=0;i<sizeList(this->courselist);i++){
        auto course = (Course *)getListNode(this->courselist,i);
        if(strcmp(course->teacherid,std::move(this->username).toStdString().c_str()) == 0 || this->permission == 3){
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
    int total = 0;
    int count = 0;
    auto scorelist = this->getStudentScoreList4Tea(courseid);
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
    double total = 0;
    int count = 0;
    auto scorelist = this->getStudentScoreList4Tea(courseid);
    for(auto score:scorelist){
        total += score.toObject()["score"].toInt();
        count++;
    }
    if(count == 0)return 0;
    return total/count;
}


int backendManager::deleteUserRec4Admin(QString userid) {
    if(this->permission <= 2)return -1; // No permission
    qDebug()<<"[INFO] User"<<this->username<<"delete user record";
    this->deleteUser(toNewConstChar(userid));
    return 0;
}

void backendManager::changeScoreRec4Tea(QString sid, int score) {
    if(this->permission <= 1)return; // No permission
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
