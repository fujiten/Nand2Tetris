@i
M=0
@sum
M=0

(LOOP)

@i
D=M
@R1
D=M-D
@END
D;JEQ
@R0
D=M
@sum
M=M+D
@i
M=M+1
@LOOP
0;JMP

(END)
@sum
D=M
@R2
M=D
@END
0;JMP