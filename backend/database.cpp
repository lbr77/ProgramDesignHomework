//
// Created by 22984 on 2024/4/5.
//

#include "database.h"
#include "io.h"
#include<cstdlib>

LinkedListNode *makeNode(void *data) {
    LinkedListNode *node = (LinkedListNode *)malloc(sizeof(LinkedListNode));
    if(!node){
        // system malloc error
        fprintf(stderr, "makeNode: malloc error\n");
        return NULL;
    }
    node->data = data;
    node->next = NULL;
    node->prev = NULL;
    return node;
}

LinkedList *makeList() {
    LinkedList *list = (LinkedList *)malloc(sizeof(LinkedList));
    if(!list){
        // system malloc error
        fprintf(stderr, "makeList: malloc error\n");
        return NULL;
    }
    list->head = NULL;
    list->tail = NULL;
    return list;
}

void insertList(LinkedList *list, void *data) {
    LinkedListNode *node = makeNode(data);
    if(list->head == NULL){
        list->head = node;
        list->tail = node;
    }else{
        list->tail->next = node;
        node->prev = list->tail;
        list->tail = node;
    }
}

void deleteList(LinkedList *list, void *data) {
    LinkedListNode *node = list->head;
    while(node!=NULL){
        if(node->data == data){
            if(node->prev!=NULL){
                node->prev->next = node->next;
            }else{
                list->head = node->next;
            }
            if(node->next!=NULL){
                node->next->prev = node->prev;
            }else{
                list->tail = node->prev;
            }
            free(node);
            return;
        }
        node = node->next;
    }
}
void freeList(LinkedList *list) {
    LinkedListNode *node = list->head;
    while(node!=NULL){
        LinkedListNode *next = node->next;
        free(node);
        node = next;
    }
    free(list);
}

int sizeList(LinkedList *list) {
//    printf("111");
    int size = 0;
    LinkedListNode *node = list->head;
    while(node!=NULL){
        size++;
        node = node->next;
    }
    return size;
}

void *getListNode(LinkedList *list, int index) {
    LinkedListNode *node = list->head;
    for(int i=0;i<index;i++){
        if(node==NULL){
            return NULL;
        }
        node = node->next;
    }
    return node->data;
}