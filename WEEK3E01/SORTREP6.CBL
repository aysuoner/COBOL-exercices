      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
       PROGRAM-ID.    SORTREP6.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  25/06/2023.
       DATE-COMPILED. 30/06/2023.
      *------------------------------
       ENVIRONMENT DIVISION.
      *------------------------------
       INPUT-OUTPUT SECTION.
      * Harici ortam ile cobol programi arasindaki veri iletimi burada
      * yapilir. input-ouptut dosyalar cobol programi ile burada
      * iliskilendirilir.
       FILE-CONTROL.
           SELECT IDX-FILE   ASSIGN TO  IDXFILE
                             ORGANIZATION INDEXED
                             ACCESS     RANDOM
                             RECORD KEY IDX-KEY
                             STATUS     IDX-ST.
           SELECT INP-FILE   ASSIGN TO  INPFILE
                             STATUS     INP-ST.
           SELECT PRINT-LINE ASSIGN TO  PRTLINE
                             STATUS     PRT-ST.
      *
      * SELECT statement -> harici data-set ile iliskilendirilecek
      * ve prog icinde kullanilacak dahili dosyayi tanimlar.
      * (IDX-FILE,INP-FILE,PRINT-LINE).
      *----
      * ASSING TO clause -> JCL'de DD DSN= olarak dizini verilen
      * //DD-name (IDXFILE, IDX-KEY, INPFILE, PRTLINE) dosya icinde
      *cagirilir.
      * Boylelikle fiziksel data-set name, dosya icinde kullanilacak
      * adiyla iliskilendirilir.
      *-----
      * ORGANIZATION clause -> data-set icindeki recordlarin dosya
      * icinde tutulma seklini belirler.
      *[INDEXED, SEQUENTIAL,RELATIVE].
      * ORGANIZATION belirtilmezse default SEQUENTIAL'dir.
      *----
      * ORGANIZATION INDEXED -> Bu organization'a gore dosyadaki her
      * record bir record-key ile iliskilendirilecek sekilde tutulur.
      * Bu INDEXED belirlenmis ORGANIZATION'larda record'lara anahtar
      * degerler uzerinden erisilebilir.
      *----
      * ACCESS clause -> ACCESS MODE ile dosyadan nasil record
      * cekilecegini yani recordlara erisim seklini belirleriz.
      * INDEXED tutulan verilere ACCESS MODE'un3 yontemi ile de
      * erisilebilir. [SEQUENTIAL, RANDOM, RELATIVE]
      *----
      * ACCESS RANDOM -> recordlarin kullanicinin belirttigi sekilde
      * okunmasini ve yazilmasini saglar. Boylelikle kullanici tanimli
      * keyler uretilir ve kayitlara bu keyler uzerinden erisilir.
      *----
      * RECORD KEY clause -> Burada belirtilen key-name bir dosyadaki
      * her bir recordu benzersiz sekilde tanimlayan bir kombinasyondur.
      * RECORD KEY clause'da tanimlanan key-name ile kayitlara dogrudan
      * erismek mumkun hale gelir.
      *----
      * Sonuc olarak -> indexed tutulan verileri keyler araciligiyla
      * bulmak, yeni kayitlar eklemek, silmek ve guncellemek mumkundur.
      *----
      * STATUS dosya islemlerinde dosyanin ne sekilde acildigina dair
      * return-code'lari tutar
      *------------------------------
        DATA DIVISION.
      *------------------------------
      *----
      * Program tarafindan islenecek tum verileri tanimlamak icin
      * kullanilan divisiondir.
      *----
      * FILE SECTION -> Harici olarak depolanan verilerin tanimlandigi
      * sectiondur.
      *----
      * WORKING-STORAGE SECTION -> Dahili verilen tanimlandigi section.
      * Harici bir dosyanin parcasi olmayan, programin isleyisinde
      * kullanilan gecici tüm degiskenlerin tanimlandigi yerdir.
      *----
      * FD file-name clause -> belirtilen file-name'in ozelliklerinin
      * tanimlanmaya baslanacagi belirtir.
      *----
      * RECORDING MODE -> dosyadaki kayitlarin uzunluk tipini belirtir.
      * RECORDING MODE F -> sabit uzunlukta kayit dosyalari icin
      * RECORDING MODE V -> degisken uzunlukta kayit dosyalari icin
      * VSAM dosyalarinda RECORDING MODE belirtilmez.
      *----
      * COMP-3 -> numeric verileri Binary-Coded-Decimal formatinda
      * depolar.Ondalikli sayilar bu formatta yapisi bozulmadan saklanir
      * Bu formatta her rakam yarim byte(4 bit) seklinde depolanir.
      * Bu yuzden 1 byte'a 1 degil 2 rakam depolanir.
      * orn: 126 sayisi comp-3 formatinda su sekilde tutulur.
      *     0001    0010   0110   1111
      *      (1)    (2)    (6)   (fill area)
      * Boylelikle degiskenin size'i azalmis olur. Size'i ise
      * (len + 1) / 2 seklinde hesaplanir.
      *----
      * COMP -> numaric veriler COMP. formatinda bellekte pure-binary
      * seklinde depolanir. Degiskendeki basamak sayisina gore depolama
      * alani degisir.
      * orn 4 basamak 2byte yer kaplarken 5 basamak 4byte
      * Ondalikli sayilari tutabilir ama binary seklinde tutugu icin
      * yazdirilirken tamsayi haline gelir.
      *----
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05 PRINT-ID       PIC 9(05).
           05 SPACE-X1       PIC X(02).
           05 PRINT-DVZ      PIC 9(03).
           05 SPACE-X2       PIC X(02).
           05 PRINT-FULLN    PIC X(30).
           05 PRINT-BRTHDAY  PIC 9(08).
           05 SPACE-X3       PIC X(02).
           05 PRINT-TUTAR    PIC 9(13)V99.
      *****
       FD  IDX-FILE.
       01  IDX-REC.
           05 IDX-KEY.
              10  IDX-ID    PIC 9(05) COMP-3.
              10  IDX-DVZ   PIC 9(03) COMP.
           05 IDX-FULLN     PIC X(30).
           05 IDX-JUL       PIC 9(07) COMP-3.
           05 IDX-TUTAR     PIC 9(13)V99 COMP-3.
      *****
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
           05 INP-ID        PIC 9(05) COMP-3.
           05 INP-DVZ       PIC 9(03) COMP.
      *****
       WORKING-STORAGE SECTION.
      *----
      * bir harici dosya tanimlanirken belirtilen STATUS'u
      * 88 condition-lvl ile birlikte flaglarin tespitinde kullandim.
      * eger STATUS 88 yaninda belirtilen value'lardan biri ise
      * 88-condition-lvl boolen gibi calisir ve TRUE olur.
      * Eger STATUS belirtilen valuelardan degil ise FALSE olur.
      *----
       01  EXIT-FLAG            PIC X(01) VALUE 'N'.
       01  FILE-FLAGS.
           05 PRT-ST            PIC 9(02).
              88 PRT-SUCCESS    VALUE 00 97.
           05 INP-ST            PIC 9(02).
              88 INP-EOF        VALUE 10.
              88 INP-SUCCESS    VALUE 00 97.
           05 IDX-ST            PIC 9(02).
              88 IDX-SUCCESS    VALUE 00 97.
       01  WS-DATE.
           05 WS-GR-DATE       PIC 9(08) COMP-3.
           05 WS-INT-DATE      PIC 9(07) COMP-3.
      *------------------------------
        PROCEDURE DIVISION.
      *------------------------------
      *----
       FILE-OPEN.
           OPEN INPUT IDX-FILE
           OPEN INPUT INP-FILE
           OPEN OUTPUT PRINT-LINE.
       FILE-OPEN-END. EXIT.
      *-------
      * OPEN islemi yapilan her dosyanin 88 condition-lvl-flag ile
      * acilip acilmadigina bakilmistir.
      * biri bile acilmadiysa SYSOUT dosyasina DISPLAY verileri
      * yazdirilir. programin return code'u 99 olarak belirlenir
      * ve programdan cikis yapilir.
      *----
       FILE-OPEN-CONTROL.
           IF (NOT PRT-SUCCESS OR NOT INP-SUCCESS OR NOT IDX-SUCCESS)
             DISPLAY 'FILE CANNOT OPEN'
             DISPLAY 'PRT-ST: ' PRT-ST
             DISPLAY 'INP-ST: ' INP-ST
             DISPLAY 'IDX-ST: ' IDX-ST
             MOVE 'Y' TO EXIT-FLAG
             MOVE 99 TO RETURN-CODE
             PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *-------
       READ-NEXT-RECORD.
           PERFORM READ-INP-ASSING-KEY
           PERFORM UNTIL INP-EOF
              PERFORM READ-IDX-FIND-KEY
              PERFORM READ-INP-ASSING-KEY
           END-PERFORM
           MOVE 'Y' TO EXIT-FLAG
           MOVE 00 TO RETURN-CODE
           PERFORM PROGRAM-EXIT.
       READ-NEXT-RECORD-END. EXIT.
      *----
      * READ-INP-ASSING-KEY her calistiginda INP-FILE'DAN bir satir
      * okunur ve okunan satir IDX-KEY degerine atanir.
      *----
       READ-INP-ASSING-KEY.
           READ INP-FILE
           MOVE INP-ID  TO IDX-ID
           MOVE INP-DVZ TO IDX-DVZ
           MOVE INP-REC TO IDX-KEY.
       READ-INP-ASSING-KEY-END. EXIT.
      *----
      * READ-IDX-FIND-KEY paragrafinda IDX-FILE'dan bir satir oku degil
      * IDX-FILE'dan bu IDX-KEY'e sahip olan satiri oku diyorum
      *----
      * INVALID KEY - NOT INVALID KEY -> READ VE WRITE yapilan
      * dsoyalarda belirli bir recordun durumunu kontrol etmek icin
      * kullanilir.
      * Belirtilen key'e sahip bir record bulunamazsa veya islem
      * sirasinda bir hata gerceklesirse INVALID KEY'de belirtilen
      * durum gerceklesir. Aksi halde NOT INVALID KEY DURUMU gerceklesir
      *----
       READ-IDX-FIND-KEY.
           READ IDX-FILE KEY IS IDX-KEY
              INVALID KEY
                 DISPLAY "Record Undefined: " INP-ID INP-DVZ
              NOT INVALID KEY
                 PERFORM WRITE-RECORD.
       READ-IDX-FIND-KEY-END. EXIT.
      *----
      * WRITE-RECORD PARAG -> JCL'de jul olarak (yyyyddd)
      * olarak tutulan tarih tekrardan gregoryan (yyyymmdd) sekline
      * cevrilir.
      * Istenilen keyden okunan record bilgileri PRINT-REC.'a aktarilir
      * ve aktarilan bilgiler JCL'de belirtilen output-file dosyasina
      * yazilir.
      *----
       WRITE-RECORD.
           COMPUTE WS-INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-JUL)
           COMPUTE WS-GR-DATE = FUNCTION DATE-OF-INTEGER(WS-INT-DATE)
           MOVE IDX-ID       TO PRINT-ID
           MOVE IDX-DVZ      TO PRINT-DVZ
           MOVE IDX-FULLN    TO PRINT-FULLN
           MOVE IDX-TUTAR    TO PRINT-TUTAR
           MOVE WS-GR-DATE   TO PRINT-BRTHDAY
           MOVE SPACES       TO SPACE-X1
           MOVE SPACES       TO SPACE-X2
           MOVE SPACES       TO SPACE-X3
           WRITE PRINT-REC
           INITIALIZE PRINT-REC.
       WRITE-RECORD-EXIT. EXIT.
      *----
       PROGRAM-EXIT.
           IF EXIT-FLAG = 'Y' THEN
               CLOSE IDX-FILE
               CLOSE INP-FILE
               CLOSE PRINT-LINE
               STOP RUN
           END-IF.
      *----
