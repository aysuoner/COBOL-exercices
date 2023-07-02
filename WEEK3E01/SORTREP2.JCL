//* Main programimizda kullanilan INP-FILE'in uretildigi job klasoru.
//* JOB NAME SORTREP2 olarak belirlenmistir.
//* CLASS=A -> JOBlari siniflandirmak icin kullanilan bir parametre
//* sirketler joblari gruplandirmak icin classlar kullanir. Burada
//* JOB A classina atanmistir.
//* MSGCLASS=A -> JOB tamamlandiginda jCL ve system mesajloglari
//* icin output hedefini belirlemek icin kullanilir.
//* MSGCLASS opsiyonaldir belirtilmezse default A kabul edilir.
//* MSGLEVEL=(1,1) -> Allacation ve terminated mesajlarinin
//* SYSOUT dosyasinda nasil yazdirilacagini belirler.
//* MSGLEVEL=(1,1) -> tum statementlarin tüm basarili/basarisiz
//* mesajlarini gosterir.
//* NOTIFY=Z95610 -> JOB durumu hakkinda burada belirtilen kullaniciya
//* mesaj gonderilir.
//*----------
//* DELET100 yurutulacek JOB'a verilen isimdir.
//* execute edilecek program IDCAMS adli yardimci bir programdir.
//* VSAM veri kumelerini olusturma,degistirme,silme icin kullanilir
//*----------
//* SYSPRINT DD SYSOUT=* -> delete100 adli JOB'in loglari MSGCLASS
//* nereye belirtildiyse oraya yazilir.(SYSOUT=*  yazdigi icin)
//*----------
//* SYSIN  DD * -> yurutulen programin (PGM=IDCAMS) ihtiyac
//* duydugu input akisi saglanir. burada belirtilen isimli bir
//* dosya varsa silinmesi gerektigini belirtir.
//*-----------
//* SORT0200 EXEC PGM=SORT -> yeni bir JOBSTEP'e gecilir.
//* Burada yardimci program olarak SORT kullanilir.
//*-------
//* SYSOUT   DD SYSOUT=* -> JOB'in yurutulmesi esnasinda olusan
//* loglar yine MSGCLASS nereye belirtildiyse oraya yazdirlir.
//*-------
//* //SORTIN   DD * ->  PGM=SORT'un ihtiyac duydugu inputlardir.
//*------
//* SORTOUT  DD DSN=Z95610.QSAM.INP -> PGM=SORT inputlari alip
//* calistiktan sonra olusan output'u DD DSN='de belirtilen
//* dosyaya yazar.
//*---------
//* DISP=(NEW,CATLG,DELETE) bunlar data-setin
//* (mevcut status, normal-end st, abnormal-end st)'unu belirtir.
//* NEW ile dosyasinin yeni olusturulacagi belirtiliyor. O yuzden
//* yukarida //DELET100 ile bu dosya varsa silindiginden emin olduk
//* CATLG ile PGM=SORT basarili data-set'in kataloglanacagi soylenir.
//* DELETE ile cikti abnormal sekilde sonlanirsa silinecegi soylenir.
//*--------
//* SPACE=(TRK,(5,5),RLSE) -> dosyanin kaplayacagi alan icin 5 TRK'lik
//* yer ayir yetmezse bir 5 TRK'lik yer daha ayir denir. RLESE ile
//* belirtilenden az kullanildiysa fazla alanin serbest birakilacagi
//* belirtilir.
//*-----
//* DCB=(RECFM=FB,LRECL=5) dataset'in fiziksel ozellikleri
//* detaylandirilir. olusturulan data-setin
//* type'i, record uzunlugu, bloksize'i belirtilir.
//* Burada dataset'in type FixedBlocked
//* record lenght'i 5 belirlenmistir.
//*------
//*   OUTREC FIELDS=(1,5,ZD,TO=PD,LENGTH=3,
//*              6,3,ZD,TO=BI,LENGTH=2)
//* outputrecord'un ilk 5 karakterinin zoned decimal'den
//* packed decimal'a
//* 6'dan itibaren 3 karakterin zoned decimal'den
//* binary (BI) formata donusturulmesi gerektigini belirtir
//*------
//* bu donusumu yapma sebebim main cobol dosyasinda kullandigim
//* diger record kayitlarinin da ayni ture sahip olmalari.
//* bu dosyadaki verileri diger veriler ile karsilastirdigim
//* ve birbirlerine esitledigim icin hepsini ayni ture esitledim
//* boylelikle maincobol programimda packed decimal'a cevirdigim
//* turleri COMP-3
//* binary(BI) türe cevirdigin degiskenleri COMP. seklinde tutacagim
//SORTREP2 JOB ' ',CLASS=A,MSGLEVEL=(1,1),MSGCLASS=A,NOTIFY=Z95610
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95610.QSAM.INP NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
30002848
25002949
10001840
93441834
50001949
40002978
63441834
//SORTOUT  DD DSN=Z95610.QSAM.INP,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=5)
//SYSIN    DD *
  SORT FIELDS=COPY
  OUTREC FIELDS=(1,5,ZD,TO=PD,LENGTH=3,
                 6,3,ZD,TO=BI,LENGTH=2)
