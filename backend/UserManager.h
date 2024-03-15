//
// Created by 22984 on 2024/3/14.
//

#ifndef COURSETEST_USERMANAGER_H
#define COURSETEST_USERMANAGER_H
#include<QObject>
#include<QCryptographicHash> // 使用现成的md5函数。。。自己写太麻烦了
class UserManager : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE int login(const QString& username,const QString& password){//返回获得权限。（理论上是返回token但是简化了）
        // TODO:调用后端接口
        //  错误返回-1
        //  密码错误返回0
        //  成功返回权限
        try{
            QString hashed = QCryptographicHash::hash(password.toUtf8(),QCryptographicHash::Md5).toHex();
            // return getUserPermission(username,password)
            if(username == "admin"){
                return 3;
            }else if(username == "teacher"){
                return 2;
            }
            return 1;
        }catch(...){
            return -1;
        }
    }
    Q_INVOKABLE int passwordChange(const QString& username,const QString& oldPassword,const QString& newPassword){
        QString oldHashed = QCryptographicHash::hash(oldPassword.toUtf8(),QCryptographicHash::Md5).toHex();
        QString newHashed = QCryptographicHash::hash(newPassword.toUtf8(),QCryptographicHash::Md5).toHex();
        //TODO:
        // 判断oldhashed和数据库中是否相同 若不同返回1
        // pass
        // 修改数据库中的密码 不成功返回2
        // pass
        return 0;
    }
    Q_INVOKABLE QString userInfo(const QString& username){

    }
};
#endif //COURSETEST_USERMANAGER_H
