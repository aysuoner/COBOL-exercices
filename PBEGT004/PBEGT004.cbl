      *-------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PBEGT004.
       AUTHOR.     AYSU ONER.
       DATE-WRITTEN. 19.06.2023.
       DATE-COMPILED. 19.06.2023. 
      *-------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-WORK-AREA.
           03 WS-JUL-DATE   PIC 9(07).
           03 WS-INTGR-DATE PIC 9(07).
           03 WS-GREG-DATE  PIC 9(08).
           03 WS-GREG       PIC 9(08).
           03 WS-GREGX      PIC X(08).
           03 WS-INT        PIC 9(09).
           03 WS-INT-DATE   PIC 9(08).
      *-------------------------
       PROCEDURE DIVISION.
       0000-MAIN.
      * WS-INT-DATE'E YYYY.MMM.DD formatında bir tarih atılır.
           MOVE 20230619 TO WS-INT-DATE
      *WS-INT alanına WS-INT-DATE'in tamsayı karşılığı atanır.
           COMPUTE WS-INT = FUNCTION INTEGER-OF-DATE(WS-INT-DATE)
      *yyyy-mm-dd ve karşılığı olan int değer ekrana basırılır.
           DISPLAY '1 - DATE :' WS-INT-DATE ' - ' WS-INT
      *yyyy.mm.dd'in karşılığı olan int değere 60 gün eklenir.
           ADD +60 TO WS-INT
      *int değere eklenen 60gün yyyy.mm.dd karşılığa da eklenir
           COMPUTE WS-INT-DATE = FUNCTION DATE-OF-INTEGER(WS-INT)
      *eklenen 60 gün yyyy.mm.dd ve int olarak ekrana bastırılır.
           DISPLAY '1 - INT DATE + 60: ' WS-INT-DATE ' - ' WS-INT
      *
      *-----
      *
      *int değerin(+60day) tarihsel karşılığı greg-date alanına atalır
           COMPUTE WS-GREG-DATE = FUNCTION DATE-OF-INTEGER(WS-INT)
           DISPLAY '2 - GREG DATE + 60: ' WS-GREG-DATE ' - ' WS-INT
      *
      *-----
      *
      *WS-JUL-DATE alanına 2100060 değeri atanır.
      *Bu bir Julian tarih değeridir.
           COMPUTE WS-JUL-DATE = 2100060
           COMPUTE WS-INTGR-DATE = FUNCTION INTEGER-OF-DAY(WS-JUL-DATE)
           DISPLAY 'WS-INTGR-DATE:' WS-INTGR-DATE
           COMPUTE WS-GREG-DATE =
           FUNCTION DATE-OF-INTEGER(WS-INTGR-DATE)
           DISPLAY 'WS-GREG-DATE :' WS-GREG-DATE
           STOP RUN.
      