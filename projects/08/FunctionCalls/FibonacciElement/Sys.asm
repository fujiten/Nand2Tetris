@Main.fibonacci
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
@2
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
@IF_TRUE_3
D;JLT
@SP
A=M
M=0
@AFTER_NOT_TRUE_3
0;JMP
(IF_TRUE_3)
@SP
A=M
M=-1
(AFTER_NOT_TRUE_3)
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@IF_TRUE
D;JNE
@IF_FALSE
0;JMP
(IF_TRUE)
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@13
M=D
@13
D=M
@5
D=D-A
A=D
D=M
@14
M=D
@SP
A=M-1
D=M
@ARG
A=M
M=D
@SP
M=M-1
@ARG
D=M+1
@SP
M=D
@13
A=M-1
D=M
@THAT
M=D
@13
D=M
@2
A=D-A
D=M
@THIS
M=D
@13
D=M
@3
A=D-A
D=M
@ARG
M=D
@13
D=M
@4
A=D-A
D=M
@LCL
M=D
@14
A=M
0;JMP
(IF_FALSE)
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
@2
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
@RETURN_ADDRESS_13
D=A
@LCL
D=A
@ARG
D=M
@THIS
D=M
@THAT
D=M
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(RETURN_ADDRESS_13)
@ARG
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
@1
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
@RETURN_ADDRESS_17
D=A
@LCL
D=A
@ARG
D=M
@THIS
D=M
@THAT
D=M
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(RETURN_ADDRESS_17)
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
@LCL
D=M
@13
M=D
@13
D=M
@5
D=D-A
A=D
D=M
@14
M=D
@SP
A=M-1
D=M
@ARG
A=M
M=D
@SP
M=M-1
@ARG
D=M+1
@SP
M=D
@13
A=M-1
D=M
@THAT
M=D
@13
D=M
@2
A=D-A
D=M
@THIS
M=D
@13
D=M
@3
A=D-A
D=M
@ARG
M=D
@13
D=M
@4
A=D-A
D=M
@LCL
M=D
@14
A=M
0;JMP
@256
D=A
@SP
M=D
@return-address-sysinit
@LCL
D=A
@ARG
D=M
@THIS
D=M
@THAT
D=M
@SP
D=M
@5
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.init
0;JMP
(return-address-sysinit)
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
@RETURN_ADDRESS_22
D=A
@LCL
D=A
@ARG
D=M
@THIS
D=M
@THAT
D=M
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(RETURN_ADDRESS_22)
(WHILE)
@WHILE
0;JMP
