//
// Created by 22984 on 2024/3/27.
//
//此文件负责对接前后端。
#ifndef COURSEWORK_BACKEND_H
#define COURSEWORK_BACKEND_H
#include<QObject>
#include<QDebug>
#include<QCryptographicHash>
#include<QJsonArray>
#include<QJsonObject>
#include<cstring>
#include"struct.h"
#include"database.h"
#include"io.h"
// 这个类操作带有用户名密码和权限。
// 主要进行Qt Type -> C Type的转换等。
// 与前端对接。
//封装md5
using Qt::endl;
QString md5(QString str);
QString sha256(QString str);
double calcGPA(int score);
QString getMajor(int major);
const char *toNewConstChar(QString str);
class backendManager : public QObject {
    Q_OBJECT
private:
    QString password,username;
    int permission{};
    LinkedList *userList{};
    void initUser();
    User *getUser(const char *userid);
    void saveUser();
    void deleteUser(const char *userid);
    LinkedList *scorelist{};
    int scoreidx;
    void initScore();
    void saveScore();
    LinkedList *courselist{};
    int cidx;
    void initCourse();
    void saveCourse();
    Course *getCourse(int courseid);
    LinkedList *articlelist{};
    int aidx;
    LinkedList *projectlist{};
    int pidx;
    LinkedList *competetionlist{};
    int coidx;
    void initExtra();
    void saveExtra();
//    LinkedList *changeApply{};
//    void initApply();
//    void saveApply();
public:
    backendManager();
    ~backendManager();
    // Account related
    Q_INVOKABLE int login(QString username,QString password); // DONE(Used)
    Q_INVOKABLE int logout(); // DONE(Used)
    Q_INVOKABLE int resetPassword(QString username,QString oPass,QString nPass); // DONE(Used)
    // Misc
    Q_INVOKABLE void Save(); //DONE(Used)
    Q_INVOKABLE int getPermission(); //DONE(Used)
    Q_INVOKABLE QJsonObject getUserInfo(); //DONE(Used) //获取当前用户信息 json object
    Q_INVOKABLE QJsonObject getUserInfo(QString userid); //DONE(Used)
    Q_INVOKABLE QJsonObject getCourseInfo(int courseid); //DONE(Used)
    Q_INVOKABLE void changeUserInfo(QString name,int major,QString userid); //DONE(Used) //信息改变(包括转专业等)
    //Student related
    Q_INVOKABLE QJsonArray getScoreList4Stu();//DONE(Used) //学生成绩列表
    Q_INVOKABLE double getTotalGPA4Stu();//DONE(Used) //计算总GPA
    Q_INVOKABLE QJsonArray getGPAByTerm4Stu();//DONE(Used)  //计算每学期GPA (Line Chart)
//    Q_INVOKABLE QJsonArray getArticleList4Stu(); //(素质) 论文
//    Q_INVOKABLE QJsonArray getProjectList4Stu(); //(素质) 项目
//    Q_INVOKABLE QJsonArray getCompetetionList4Stu(); //(素质) 竞赛
    //Teacher related
    Q_INVOKABLE QJsonArray getStudentList(); //DONE(Used)
    Q_INVOKABLE QString findStudentIdByName(QString name); //DONE(Used)
    Q_INVOKABLE QJsonObject addScoreRec4Tea(QString courseid, QString studentid, int score); //DONE
    Q_INVOKABLE QJsonArray getStudentScoreList4Tea(int courseid); //DONE
    double getCoursePercentage4Tea(int courseid); //DONE
    Q_INVOKABLE int deleteScoreRec4Tea(QString sid); //DONE
    Q_INVOKABLE void changeScoreRec4Tea(QString sid, int score); //DONE
    Q_INVOKABLE QJsonArray getCourseList4Tea(); //DONE
    Q_INVOKABLE double getScoreAverage(int courseid); //DONE
    //Admin related
    Q_INVOKABLE QJsonArray getScoreList4Admin();
    Q_INVOKABLE int addUserRec4Admin(QString userid,QString name,QString password,int permission,int major);//DONE
    Q_INVOKABLE QJsonArray getUserList4Admin();
    Q_INVOKABLE int deleteUserRec4Admin(QString userid);//DONE
    Q_INVOKABLE QJsonObject modifyUserRec4Admin(QString userid,QString name,QString password,int permission,int major);//DONE
};

#endif //COURSEWORK_BACKEND_H
