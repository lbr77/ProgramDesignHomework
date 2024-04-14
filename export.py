f = open("data.csv").read().split("\n")
f = [i.split(",") for i in f]
r = open("user.txt", "w")
import hashlib
def md5(s):
    return hashlib.md5(s.encode()).hexdigest()
for i in f[1:]:
    if i[0].find("552304") != -1:
        r.write(f"{i[0]},{i[1]},{md5(i[1])},1,{i[0][:2]}\n")