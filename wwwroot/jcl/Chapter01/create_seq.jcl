//HCREAPDS JOB (COBOL), 
//             'Create PDS',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1),
//  USER=HERC01,PASSWORD=CUL8TR
//IDCAMS  EXEC PGM=IDCAMS                                               
//SYSPRINT DD SYSOUT=*                                                  
//SYSIN    DD *                                                         
 DELETE 'HERC01.TEST.SEQ' NONVSAM PURGE
 SET MAXCC = 0                                                          
//*                                                                     
//STEP011  EXEC PGM=IEFBR14                     
//SYSUT2   DD DSN=HERC01.TEST.SEQ,DISP=(NEW,CATLG,DELETE),             
//         UNIT=DISK,SPACE=(TRK,(1,1,1)),VOL=SER=PUB012,               
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120,DSORG=PO)               
//SYSPRINT DD SYSOUT=*                                                 
//SYSIN    DD *                                                        
/*