f = open("cmake-build-debug/user.txt",encoding='utf-8').read().split("\n")
users = [i.split(",") for i in f if i != ""]
f = open("cmake-build-debug/course.txt",encoding='utf-8').read().split("\n")
courses = [i.split(",") for i in f if i != ""]
import random
students = [r for r in users if r[-2] == "1"]
f = open("score.txt","w",encoding='utf-8')
cnt = 1
for student in students:
    for course in courses:
        cnt += 1
        f.write(f"{cnt},{course[0]},{student[0]},{random.randint(50,100)}\n")