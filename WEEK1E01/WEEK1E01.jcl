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
//*Programin input'u olan dosya ACCTREC'in dizininde gosterilir.
//*ve output PRTLINE acilir. DISP,SPACE ve DCB ile
//*acilan PRTLINE dosyasinin ozellikleri tanimlanir.
//*NEW -> .DATA.PRT adli yeni bir dosya acilacagi 
//*CATALG -> isin basarili sonuclanirsa cataloglanacagi
//*DELETE -> isin basariz sonuclanirsa silinecegini ifade eder.
//*LRECL=119 -> Her bir kaydın uzunlugunun 119 oldugunu ifade eder.
//*SPACE=(TRK,(5,5),RLSE) -> bu data-set icin 5 trk'lik yer acilması
//* gerektigini yetmezse bir 5 trk'lik daha yer acilmasi gerektigini soyler
//*,RLSE -> eger data-set icin ayrilan yer artar ise artan alanın serbest birakilmasi
//* gerektigini ifade eder.
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
