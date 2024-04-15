//
// Created by 22984 on 2024/4/5.
//

#include "io.h"
#include <cstdlib>
#include<cstdio>

FILE *open_file(const char *filename, const char *mode) {
    // if exists, open
    FILE *file = fopen(filename, mode);
    if (file == NULL) {
        // else create
        file = fopen(filename, "w");
        file = fopen(filename, mode);
    }
    return file;
}

void close_file(FILE *file) {
    fclose(file);
}

char *read_line(FILE *file) {
    char *line = (char *)malloc(1024);
    if(!line){
        // system malloc error
        return NULL;
    }
    int c;
    int i = 0;
    while((c = fgetc(file)) != EOF && c != '\n') {
        line[i++] = (char)c;
        if(i>=1024){
            // line too long
            return NULL;
        }
    }
    if(c==EOF && i==0){
        free(line);
        return NULL;
    }
    line[i] = '\0';
    return line;
}

void write_line(FILE *file, const char *line) {
    fprintf(file, "%s\n", line);
}