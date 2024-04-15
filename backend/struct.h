//
// Created by 22984 on 24-4-6.
//

#ifndef COURSETEST_STRUCT_H
#define COURSETEST_STRUCT_H
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
    int courseid;
    char *teacherid;
    char *title;
    int term;
    double power;
};
//----------------成绩信息-----------------
struct Score{
    int scoreid;//自增
    int courseid;
    char *studentid;
    int score;
};
//----------------额外信息-----------------
struct Article{ //论文信息
    int aid;
    char *title;
    char *author;//with all authors in one string split with .
    char *journal;
    char *releasetime;//yyyyMM
    char *level;
    double score;//加分
};
struct Project{ //项目信息
    int pid;
    char *members; //二维
};
struct Competetion{ //竞赛信息
    int cid;

};

#endif //COURSETEST_STRUCT_H
