@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_2
D;JEQ
@SP
A=M
M=0
@AFTER_NOT_TRUE_2
0;JMP
(IF_TRUE_2)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_2)
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_5
D;JEQ
@SP
A=M
M=0
@AFTER_NOT_TRUE_5
0;JMP
(IF_TRUE_5)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_5)
@SP
M=M+1
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_8
D;JEQ
@SP
A=M
M=0
@AFTER_NOT_TRUE_8
0;JMP
(IF_TRUE_8)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_8)
@SP
M=M+1
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_11
D;JLT
@SP
A=M
M=0
@AFTER_NOT_TRUE_11
0;JMP
(IF_TRUE_11)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_11)
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_14
D;JLT
@SP
A=M
M=0
@AFTER_NOT_TRUE_14
0;JMP
(IF_TRUE_14)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_14)
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_17
D;JLT
@SP
A=M
M=0
@AFTER_NOT_TRUE_17
0;JMP
(IF_TRUE_17)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_17)
@SP
M=M+1
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_20
D;JGT
@SP
A=M
M=0
@AFTER_NOT_TRUE_20
0;JMP
(IF_TRUE_20)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_20)
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_23
D;JGT
@SP
A=M
M=0
@AFTER_NOT_TRUE_23
0;JMP
(IF_TRUE_23)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_23)
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@IF_TRUE_26
D;JGT
@SP
A=M
M=0
@AFTER_NOT_TRUE_26
0;JMP
(IF_TRUE_26)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_26)
@SP
M=M+1
@57
D=A
@SP
A=M
M=D
@SP
M=M+1
@31
D=A
@SP
A=M
M=D
@SP
M=M+1
@53
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
M=M+D
@SP
M=M+1
@112
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
M=M-D
@SP
M=M+1
@SP
M=M-1
A=M
M=-M
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
M=D&M
@SP
M=M+1
@82
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
M=M-1
A=M
M=D|M
@SP
M=M+1
@SP
M=M-1
A=M
M=!M
@SP
M=M+1