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
    char *studentid;
    char *title;
    int nauthor;
    char **author;
    char *journal;
    char *time;//yyyy-MM-dd
    int paperNum;
    int volIssue;
    char *pageRange;
    char *level;
    double score;//加分
};
struct Project{ //项目信息
    int pid;
    char *studentid;
    char *name;
    char *leader;
    int nmember;
    char **member;
    char *starttime;//yyyy-MM-dd
    char *endtime;//yyyy-MM-dd
    double score;//加分
};
struct Competition{ //竞赛信息
    int cid;
    char *studentid;
    char *name;
    char *level;
    char *organizer;
    int nstudent;
    char **student;
    char *time;//yyyy-MM-dd
    double score;//加分
};

#endif //COURSETEST_STRUCT_H
