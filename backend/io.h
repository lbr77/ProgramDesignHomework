//
// Created by 22984 on 2024/4/5.
//

#ifndef COURSETEST_IO_H
#define COURSETEST_IO_H
#include <cstdio>
FILE *open_file(const char *filename, const char *mode);
void close_file(FILE *file);
char *read_line(FILE *file);
void write_line(FILE *file, const char *line);
#endif //COURSETEST_IO_H
