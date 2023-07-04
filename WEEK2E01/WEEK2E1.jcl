//BDAYCALC JOB 1,NOTIFY=&SYSUID
//***************************************************/
//COBRUN   EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(WEEK2E1),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(WEEK2E1),DISP=SHR
//***************************************************/
// IF RC < 5 THEN
//***************************************************/
//*-------------------------------------
//* DELET100->  varsa QSAM.AA uzantili dosya silinir
//*--------------------------------------
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95610.QSAM.AA NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
/*
//*--------------------------------------
//* SORT0200-> sort programi sortin'de verilen inputlari alip
//* QSAM.AA, uzantili yeni bir data-set olusturup onun 
//* icine copyalar.
//*--------------------------------------
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
0001AYSU           ONER           19950506
0003SEZEN          AKSU           19540713
0008TARKAN         TEVETOGLU      19721017
0007ASIK           VEYSEL         20230230
//SORTOUT  DD DSN=Z95610.QSAM.AA,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=42)
//SYSIN    DD *
  SORT FIELDS=COPY
/*
//*--------------------------------------
//* DELET300 -> QSAM.BB uzantili dosya varsa siler
//*--------------------------------------
//DELET300 EXEC PGM=IEFBR14
//FILE01   DD DSN=Z95610.QSAM.BB,
//            DISP=(MOD,DELETE,DELETE),
//            SPACE=(TRK,0)
//*--------------------------------------
//* SORT0400 -> input olarak QSAM.AA data-setindeki
//* recordlari alir
//* //SYSIN'de verilen talimatlari gerceklestirerek
//* ilk 4 karakteri karsilastirarak sıralama islemi yapar.
//* olusan output recordlar, QSAM.BB uzantili yeni
//* olusturulan output dosyasina kaydedilir.
//*--------------------------------------
//SORT0400 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=Z95610.QSAM.AA,DISP=SHR
//SORTOUT  DD DSN=Z95610.QSAM.BB,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=50)
//SYSIN    DD *
  SORT FIELDS=(1,4,CH,A)
  INCLUDE COND=(1,1,CH,EQ,C'0')
  OUTREC FIELDS=(1,42,DATE1)
/*
//*--------------------------------------
//* DELET300 -> varsa .QSAM.CC uzantili data-set silinir
//*--------------------------------------
//DELET300  EXEC PGM=IEFBR14
//FILE01    DD DSN=Z95610.QSAM.CC,
//             DISP=(MOD,DELETE,DELETE),SPACE=(TRK,0)
//*--------------------------------------
//* PGM=WEEK2E1 programi -> QSAM.BB uzantili data-set
//* input olarak kullanilarak calistirlir
//* programin calismasindan sonra olusan 
//* output dosyalari yeni olusturulan .QSAM.CC
//* uzantili data-set'e yazdirilir.
//*--------------------------------------
//RUN       EXEC PGM=WEEK2E1
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC   DD DSN=&SYSUID..QSAM.BB,DISP=SHR
//PRTLINE   DD DSN=&SYSUID..QSAM.CC,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(5,5),RLSE),
//             DCB=(RECFM=FB,LRECL=64,BLKSIZE=0),UNIT=3390
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
