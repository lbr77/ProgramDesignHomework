#include "../backend/backendManager.h"
#include<iostream>
#include<QJsonDocument>
using Qt::endl;
backendManager bMgr;
void test_student(){
    bMgr.login("55230422","1");
    qDebug()<< bMgr.getTotalGPA4Stu();
    qDebug()<<bMgr.getGPAByTerm4Stu();
    qDebug()<< bMgr.getScoreList4Stu();
    bMgr.changeUserInfo("李博",55,"55230422");
    bMgr.changeUserInfo("李博睿",55,"55230422");
    bMgr.logout();
}
void test_teacher(){
    bMgr.login("2","1");
    qDebug()<< bMgr.getCourseList4Tea();
    for(auto r : bMgr.getCourseList4Tea()){
        auto c = r.toObject();
        qDebug()<< bMgr.getStudentScoreList4Tea(c["courseid"].toInt());
    }
    bMgr.addScoreRec4Tea("1","1",100);
    bMgr.deleteScoreRec4Tea("1");
    qDebug()<<bMgr.getScoreAverage(1);
    bMgr.logout();
}
void test_admin(){
    bMgr.login("admin","1");
//    qDebug()<<
    bMgr.logout();
}
int main(){
//    test_teacher();
//    test_student();
    test_admin();
}