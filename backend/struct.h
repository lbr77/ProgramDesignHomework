//
// Created by 22984 on 24-4-6.
//

#ifndef COURSETEST_DB_H
#define COURSETEST_DB_H
//----------------学生信息-----------------
struct User{
    char *userid;
    char *name;
    char *password;
    int permission;
    int major;
};

//----------------课程信息-----------------
struct Course{
    char *courseid;
    char *teacherid;
    char *title;
};
struct Score{
    int scoreid;//自增
    char *courseid;
    char *title;
    char *studentid;
    char *teacherid;
    int score;
    double power;
    int term;
};
#endif //COURSETEST_DB_H
