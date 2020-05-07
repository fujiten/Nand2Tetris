filename = "Add.asm"

f = open("add/Add.hack", "x")

f = open("add/Add.asm")
for x in f:
    x = x.strip()
    if (x[0:2] == "//") or (x == ""):
        continue
    if (x[0:1] == "@"):
        print("A命令")
        if x[1:].isdecimal():
            order = str(format(int(x[1:]), '016b'))
            file = open('add/Add.hack','a')
            file.write(f'{order}\n')
            file.close()
        else:
            print('これはシンボル')
    else:
        print('C命令')

f.close()