//TEACH1C      JOB (ASM), 
//             'HELLO ASM',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1),
//  USER=HERC01,PASSWORD=CUL8TR
//ASMF1     EXEC PGM=IFOX00,REGION=2048K
//SYSLIB    DD DSN=SYS1.AMODGEN,DISP=SHR
//          DD DSN=SYS1.AMACLIB,DISP=SHR
//          DD DSN=SYS2.MACLIB,DISP=SHR 
//SYSUT1    DD DISP=(NEW,DELETE),SPACE=(1700,(900,100)),UNIT=SYSDA
//SYSUT2    DD DISP=(NEW,DELETE),SPACE=(1700,(600,100)),UNIT=SYSDA
//SYSUT3    DD DISP=(NEW,DELETE),SPACE=(1700,(600,100)),UNIT=SYSDA
//SYSPRINT  DD SYSOUT=*
//SYSPUNCH  DD DSN=&&OBJ,UNIT=SYSDA,SPACE=(CYL,1),DISP=(NEW,PASS)
//SYSIN     DD * 
        PRINT NOGEN              don't show macro expansions
****************************************************************
*        FILENAME:  TEACH1C.MLC                                *
*        AUTHOR  :  Bill Qualls                                *
*        MODIFIED:  Brad Rigg to run on MVS38J                 *
*        SYSTEM  :  Compaq 286LTE, PC/370 R4.2                 *
*        REMARKS :  This program will display teacher recs.    *
****************************************************************
TEACH1C START 0                  start main code csect at base 0
        SAVE  (14,12)            Save input registers
        LR    R12,R15            base register := entry address
        USING TEACH1C,R12        declare base register
        ST    R13,SAVE+4         set back pointer in current save area
        LR    R2,R13             remember callers save area
        LA    R13,SAVE           setup current save area
        ST    R13,8(R2)          set forw pointer in callers save area
*
        OPEN  (TEACHRPT,OUTPUT)  open TEACHRPT
        LTR   R15,R15            test return code
        BNE   ABND8              abort if open failed
        OPEN  (TEACHERS,INPUT)   open TEACHERS
        LTR   R15,R15            test return code
        BNE   ABND8              abort if open failed

LOOP    GET   TEACHERS,IREC      Read a single teacher record
        PUT   TEACHRPT,IREC      write the record to TEACHRPT
        B     LOOP               Repeat

ATEND   CLOSE TEACHERS
        CLOSE TEACHRPT            close TEACHRPT
        

*
        L     R13,SAVE+4         get old save area back
        RETURN (14,12),RC=0      return to OS
*
ABND8    ABEND 8                  bail out with abend U008

*
* File and work area definitions
*
SAVE     DS    18F                local save area
IREC     DS    CL80               Teacher record     


TEACHERS DCB   DSORG=PS,MACRF=GM,EODAD=ATEND,DDNAME=TEACHERS,          X
               RECFM=FBA,LRECL=80,BLKSIZE=800  
TEACHRPT DCB   DSORG=PS,MACRF=PM,DDNAME=TEACHRPT,                      X
               RECFM=FBA,LRECL=80

        YREGS ,
        END   TEACH1C            define main entry point
/*
//LKED     EXEC PGM=IEWL,
//             COND=(5,LT,ASMF1),
//             PARM='LIST,MAP,XREF,LET,RENT'
//SYSPRINT  DD SYSOUT=*
//SYSLMOD   DD DSN=HERC01.ASMMVS.LOADLIB,DISP=SHR
//SYSUT1    DD UNIT=SYSDA,SPACE=(TRK,(5,5))
//SYSLIN    DD DSN=&&OBJ,DISP=(OLD,DELETE)
//          DD *
 NAME TEACH1C(R)
//*-------------------------------------------------------------------
//TEACH1C   EXEC PGM=TEACH1C
//STEPLIB   DD DSN=HERC01.ASMMVS.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSOUT DD SYSOUT=* 
//TEACHERS DD DSN=HERC01.TEST.SEQ(TEACHER),DISP=SHR
//TEACHRPT DD DSN=HERC01.TEST.SEQ(TEACHRPT),DISP=SHR
//