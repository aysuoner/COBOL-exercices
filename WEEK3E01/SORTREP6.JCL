//*-----
//*maincobol programimin JCL dosyasi.
//*-----
//* COBRUN   EXEC IGYWCL ile programi compile edilir
//* ve load klasorunde nesne kodu olusturulur. JCL
//* programi calistirirlen klasordeki prgrami degil
//* bu makine diline cevrilmis load klasorundeki nesne
//* kodunu calistirir.
//*COBOL.SYSIN  DD DSN=&SYSUID..CBL(SORTREP6)
//* ile nesne koduna cevrilecek kaynakkodun dizini verilir.
//* LKED.SYSLMOD DD DSN=&SYSUID..LOAD(SORTREP6), ile
//* bu kaynakkodun olusturacagi nesne kodunun oldugu
//* dizin verilir.
//* DISP=SHR ile bu dizinlerin ozel bir yetki olmaksizin
//* paylasildigi belirtilir.
//*-----
//*IDXFILE, INPFILE, PRTLINE bunlar main-cobol programinda
//* ASSIGN TO ile cagirilan ve program icindeki isimleri ile
//* iliskilendirilen fiziksel dosyalarin dizinleridir.
//*
//SORTREP6 JOB 1,NOTIFY=&SYSUID
//COBRUN   EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(SORTREP6),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(SORTREP6),DISP=SHR
//***************************************************/
// IF RC < 5 THEN
//***************************************************/
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95610.QSAM.ZZ NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
/*
//* asagida  DISP=(NEW,CATLG,CATLG) yaptigimiz
//* icin varolan dosyayi sildigimizden emin olmaliyiz
//* o yüzden burada PGM=IDCAMS yardimci programi ile silme
//* islemi yapiyoruz.
//* EXEC PGM=SORTREP6 ile main-cobol programini calistiriyoruz
//* kullandigi dosya dizinlerini tanitip
//* son olarak da programin ciktilarinin yazdirilacagi
//* output klasoru PRTLINE olusturulur dizini ve dosya
//* ozellikleri belirtilir.
//RUN      EXEC PGM=SORTREP6
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//IDXFILE   DD DSN=&SYSUID..VSAM.AA,DISP=SHR
//INPFILE   DD DSN=&SYSUID..QSAM.INP,DISP=SHR
//PRTLINE   DD DSN=&SYSUID..QSAM.ZZ,
//            DISP=(NEW,CATLG,CATLG),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=67,BLKSIZE=0)
//SYSOUT    DD SYSOUT=*,OUTLIM=1000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
