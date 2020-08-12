import re
import sys

filename = sys.argv[1]

def write_file(binary):
    file = open(f'{filename}.hack','a')
    file.write(f'{binary}\n')
    file.close()

def create_dest_binary(dest):
    if dest is None:
        return "000"
    elif dest == 'M':
        return "001"
    elif dest == 'D':
        return "010"
    elif dest == 'MD':
        return "011"
    elif dest == 'A':
        return "100"
    elif dest == 'AM':
        return "101"
    elif dest == 'AD':
        return "110"
    elif dest == 'AMD':
        return "111"

def create_comp_binary(comp):
    if comp == "0":
        return "0101010"
    elif comp == "1":
        return "0111111"
    elif comp == "-1":
        return "0111010"
    elif comp == "D":
        return "0001100"
    elif comp == "A":
        return "0110000"
    elif comp == "!D":
        return "0001101"
    elif comp == "!A":
        return "0110001"
    elif comp == "-D":
        return "0001111"
    elif comp == "-A":
        return "0110011"
    elif comp == "D+1":
        return "0011111"
    elif comp == "A+1":
        return "0110111"
    elif comp == "D-1":
        return "0001110"
    elif comp == "A-1":
        return "0110010"
    elif comp == "D+A":
        return "0000010"
    elif comp == "D-A":
        return "0010011"
    elif comp == "A-D":
        return "0000111"
    elif comp == "D&A":
        return "0000000"
    elif comp == "D|A":
        return "0010101"
    elif comp == "M":
        return "1110000"
    elif comp == "!M":
        return "1110001"
    elif comp == "-M":
        return "1110011"
    elif comp == "M+1":
        return "1110111"
    elif comp == "M-1":
        return "1110010"
    elif comp == "D+M":
        return "1000010"
    elif comp == "D-M":
        return "1010011"
    elif comp == "M-D":
        return "1000111"
    elif comp == "D&M":
        return "1000000"
    elif comp == "D|M":
        return "1010101"

def create_jump_binary(jump):
    if jump is None:
        return "000"
    elif jump == "JGT":
        return "001"
    elif jump == "JEQ":
        return "010"
    elif jump == "JGE":
        return "011"
    elif jump == "JLT":
        return "100"
    elif jump == "JNE":
        return "101"
    elif jump == "JLE":
        return "110"
    elif jump == "JMP":
        return "111"

f = open(f'{filename}.hack', "x")
f.close()

f = open(f'{filename}.asm')

symbol_table = dict()
orders = list()

line_number = -1

for x in f:
    x = x.strip()
    result = re.search('//', x)
    if not (result is None):
        chars_number = result.start()
        x = x[:chars_number].strip()
    if (x[0:2] == "//") or (x == ""):
        continue
    if x[0] == "(" and x[-1] == ")":
        symbol = x[1:-1]
        symbol_table[symbol] = (line_number + 1)
    else:
        orders.append(x)
        line_number += 1

symbol_table = {**symbol_table, "SP": 0, "LCL": 1, "ARG": 2, "THIS": 3, "THAT": 4, "SCREEN": 16384, "KBD": 24576}
for x in range(0, 16):
    key = f'R{x}'
    symbol_table[key] = x

value_number = 16

for x in orders:
    print(x)
    if (x[0:1] == "@"):
        print("A命令")
        if x[1:].isdecimal():
            order = str(format(int(x[1:]), '016b'))
            write_file(order)
        else:
            print('シンボル')
            if x[1:] in symbol_table:
                num = 9[x[1:]]
                order = str(format(num, '016b'))
            else:
                symbol_table[x[1:]] = value_number
                order = str(format(value_number, '016b'))
                value_number += 1
            write_file(order)
    else:
        print('C命令')
        result = re.search('=', x)
        if not (result is None):
            char_idx = result.start()
            left_side = x[0:char_idx]
            right_side = x[char_idx+1:]
            dest = create_dest_binary(left_side)
            comp = create_comp_binary(right_side)
            jump = "000"
            order = "111" + comp + dest + jump
            write_file(order)
        else:
            result = re.search(';', x)
            char_idx = result.start()
            left_side = x[0:char_idx]
            right_side = x[char_idx+1:]
            dest = "000"
            comp = create_comp_binary(left_side)
            jump = create_jump_binary(right_side)
            order = "111" + comp + dest + jump
            write_file(order)

f.close()

