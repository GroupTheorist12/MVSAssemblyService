//MOV4  JOB (BAL),
//             'HELLO ASM2',
//             CLASS=A,
//             MSGCLASS=A,
//             TIME=1440,
//             MSGLEVEL=(1,1)
//MOV4  EXEC ASMFCG,PARM.ASM=(OBJ,NODECK),MAC1='SYS2.MACLIB',
//             REGION.GO=128K,PARM.GO='/2000'
//ASM.SYSIN DD *
*        1         2         3         4         5         6         71
*23456789*12345*789012345678901234*678901234567890123456789012345678901
        PRINT NOGEN              don't show macro expansions
MOV4   START 0                  start main code csect at base 0
        SAVE  (14,12)            Save input registers
        LR    R12,R15            base register := entry address
        USING MOV4,R12          declare base register
        ST    R13,SAVE+4         set back pointer in current save area
        LR    R2,R13             remember callers save area
        LA    R13,SAVE           setup current save area
        ST    R13,8(R2)          set forw pointer in callers save area
*
        OPEN  (SYSPRINT,OUTPUT)  open SYSPRINT
        LTR   R15,R15            test return code
        BNE   ABND8              abort if open failed

        PUT   SYSPRINT,IPHONE
        MVC   OPFX,IPFX
        MVI   OHYPHEN,HYPHEN
        MVC   OLINE,ILINE
        PUT   SYSPRINT,OPHONE

ATEND   CLOSE SYSPRINT            close SYSPRINT
        

*
        L     R13,SAVE+4         get old save area back
        RETURN (14,12),RC=0      return to OS
*
ABND8    ABEND 8                  bail out with abend U008

*
* File and work area definitions
*
SAVE     DS    18F                local save area

HYPHEN   EQU   C'-'
*                                 INPUT RECORD 
IPHONE   DS    0CL80
IPFX     DC    CL4' 555'
ILINE    DC    CL4'1212'
IFILL    DC    CL72' '

*                                 OUTPUT RECORD
OPHONE   DS    0CL80
OPFX     DS    CL4
OHYPHEN  DS    CL1
OLINE    DS    CL4
OFILL    DC    CL71' '

*                                 File defs
SYSPRINT DCB   DSORG=PS,MACRF=PM,DDNAME=SYSPRINT,                      X
               RECFM=FBA,LRECL=80,BLKSIZE=800
        YREGS ,
        END   MOV4              define main entry point
/*
//GO.SYSPRINT DD SYSOUT=*
//
