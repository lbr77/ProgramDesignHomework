//
// Created by 22984 on 2024/4/5.
//

#ifndef COURSETEST_DATABASE_H
#define COURSETEST_DATABASE_H
#include<cstdlib>
//-----------------------链表 Utils-----------------------
/*
 * 普通的链表实现
 * */
//链表节点定义
struct LinkedListNode{ //节点
    void *data;
    LinkedListNode *next;
    LinkedListNode *prev;
};
LinkedListNode *makeNode(void *data); //创建节点
//链表定义
struct LinkedList{
    LinkedListNode *head;
    LinkedListNode *tail;
};
LinkedList *makeList(); //创建链表
void insertList(LinkedList *list, void *data); //插入节点
void deleteList(LinkedList *list, void *data); //删除节点
void freeList(LinkedList *list); //释放链表
int sizeList(LinkedList *list); //链表大小
void *getListNode(LinkedList *list, int index); //获取节点
#endif //COURSETEST_DATABASE_H
