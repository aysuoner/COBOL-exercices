//SORTREP3 JOB ' ',
//         CLASS=A,
//         MSGLEVEL=(1,1),
//         MSGCLASS=X,
//         NOTIFY=&SYSUID
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95610.QSAM.AA NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
20002949AYSU           ONER           19950506
10001840SEZEN          AKSU           19540713
63441834MEHMET         AYDIN          19231029
50001949TARKAN         TEVETOGLU      19721017
40002978ASIK           VEYSEL         18941025
30002848ALEYNA         TILKI          20000321
//SORTOUT  DD DSN=&SYSUID..QSAM.AA,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=60)
//* 1,7,CH,A) -> ilk karakterin char(CH) formatinda
//*kucukten buyuge sirala
//* (1,38,...) -> ilk 38 karakteri ayni sekilde kopyala
//* (39,8,Y4T,TOJUL=Y4T, ...) -> sonraki 8 karakterin
//* gregorian formatinda oldugu ve JULIAN formata
//* cevrilmesi gerektigini belirtir.
//* (15C'0') -> her kaydin sonuna 15 adet char olarak '0'
//* eklenmesi gerektigini belirtir.
//SYSIN    DD *
  SORT FIELDS=(1,7,CH,A)
  OUTREC FIELDS=(1,38,39,8,Y4T,TOJUL=Y4T,15C'0')
//*
//DELET300 EXEC PGM=IEFBR14
//FILE01   DD DSN=&SYSUID..QSAM.BB,
//            DISP=(MOD,DELETE,DELETE),
//            SPACE=(TRK,0)
//SORT0400 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=&SYSUID..QSAM.AA,DISP=SHR
//SORTOUT  DD DSN=&SYSUID..QSAM.BB,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=47)
//SYSIN    DD *
  SORT FIELDS=COPY
  OUTREC FIELDS=(1,5,ZD,TO=PD,LENGTH=3,
                 6,3,ZD,TO=BI,LENGTH=2,
                 9,30,
                 39,7,ZD,TO=PD,LENGTH=4,
                 46,15,ZD,TO=PD,LENGTH=8)
