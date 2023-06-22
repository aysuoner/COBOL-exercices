//WEEK1E01 JOB 1,NOTIFY=&SYSUID
//COBRUN   EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(CBL0001),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(CBL0001),DISP=SHR
//***************************************************/
// IF RC = 0 THEN
//***************************************************/
//*COBRUN etiketindeki islemler RC=0 ise devam edilir.
//*Varsa .PRT dosyasi DISP=(MOD,DELETE,DELETE) ile silinir.
//*CBL001 programi execute edilir.
//*Programin input-file ACCTREC'in dizini gosterilir.
//*ve output-file PRTLINE acilir. DISP,SPACE ve DCB ile
//*acilan PRTLINE dosyasinin ozellikleri tanimlanir.
//DELET100  EXEC PGM=IEFBR14
//FILE01    DD DSN=&SYSUID..DATA.RPT,
//             DISP=(MOD,DELETE,DELETE),SPACE=(TRK,0)
//RUN      EXEC PGM=CBL0001
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC   DD DSN=&SYSUID..DATA,DISP=SHR
//PRTLINE   DD DSN=&SYSUID..DATA.PRT,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(5,5),RLSE),
//             DCB=(RECFM=FB,LRECL=119,BLKSIZE=0),UNIT=3390
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
