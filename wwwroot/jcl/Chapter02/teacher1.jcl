//SEQA1  JOB (BAL),
//             'HELLO ASM2',
//             CLASS=A,
//             MSGCLASS=A,
//             TIME=1440,
//             MSGLEVEL=(1,1)
//SEQA1  EXEC ASMFCG,PARM.ASM=(OBJ,NODECK),MAC1='SYS2.MACLIB',
//             REGION.GO=128K,PARM.GO='/2000'
//ASM.SYSIN DD *
*        1         2         3         4         5         6         71
*23456789*12345*789012345678901234*678901234567890123456789012345678901
        PRINT NOGEN              don't show macro expansions
SEQA1   START 0                  start main code csect at base 0
        SAVE  (14,12)            Save input registers
        LR    R12,R15            base register := entry address
        USING SEQA1,R12          declare base register
        ST    R13,SAVE+4         set back pointer in current save area
        LR    R2,R13             remember callers save area
        LA    R13,SAVE           setup current save area
        ST    R13,8(R2)          set forw pointer in callers save area
*
        OPEN  (SYSPRINT,OUTPUT)  open SYSPRINT
        LTR   R15,R15            test return code
        BNE   ABND8              abort if open failed
        OPEN  (TEACHERS,INPUT)   open TEACHERS
        LTR   R15,R15            test return code
        BNE   ABND8              abort if open failed

LOOP    GET   TEACHERS,IREC      Read a single teacher record
        PUT   SYSPRINT,IREC      write the record to SYSPRINT
        B     LOOP               Repeat

ATEND   CLOSE TEACHERS
        CLOSE SYSPRINT            close SYSPRINT
        

*
        L     R13,SAVE+4         get old save area back
        RETURN (14,12),RC=0      return to OS
*
ABND8    ABEND 8                  bail out with abend U008

*
* File and work area definitions
*
SAVE     DS    18F                local save area
IREC     DS    0CL80              Teacher record     
ITID     DS    CL3                Teacher ID nbr
ITNAME   DS    CL15               Teacher name
ITDEG    DS    CL4                Highest degree
ITTEN    DS    CL1                Tenured?
ITPHONE  DS    CL4                Phone nbr
FILL     DS    CL53               Fill   

SYSPRINT DCB   DSORG=PS,MACRF=PM,DDNAME=SYSPRINT,                      X
               RECFM=FBA,LRECL=80,BLKSIZE=800
TEACHERS DCB   DSORG=PS,MACRF=GM,EODAD=ATEND,DDNAME=TEACHERS,          X
               RECFM=FBA,LRECL=80,BLKSIZE=0               
        YREGS ,
        END   SEQA1              define main entry point
/*
//GO.SYSPRINT DD SYSOUT=*
//TEACHERS DD DSN=HERC01.TEST.SEQDATA(TEACHER),DISP=SHR
//
