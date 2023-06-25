      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
       PROGRAM-ID.    BDAYCALC.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  20/06/2023.
       DATE-COMPILED. 21/06/2023.
      *------------------------------
       ENVIRONMENT DIVISION.
      *------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE
                             STATUS    PRT-ST.
           SELECT ACCT-REC   ASSIGN TO ACCTREC
                             STATUS    ACCT-ST.
      * SELECT dahili bir file-name yaratir PRINT-LINE adinda
      * ASSIGN JCL dosyasinda yazan PRTLINE ile baglanti kurar
      *------------------------------
        DATA DIVISION.
      *------------------------------
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
      * input dosyasi readonly oldugu icin recording mode
      * F(fixed lenght) olarak ayarlandi.
       01  PRINT-REC.
           05  PRINT-SEQ       PIC X(04).
           05  SPACE-X         PIC X(02) VALUE SPACES.
           05  PRINT-NAME      PIC X(15).
           05  PRINT-LASTN     PIC X(15).
           05  PRINT-BRTHDAY   PIC 9(08).
           05  SPACE-X1        PIC X(02) VALUE SPACES.
           05  PRINT-TODAY     PIC 9(08).
           05  SPACE-X2        PIC X(02) VALUE SPACES.
           05  DAY-DIFF      PIC 9(08).
      *
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05  ACCT-SEQ        PIC X(04).
           05  ACCT-NAME       PIC X(15).
           05  ACCT-LASTN      PIC X(15).
           05  ACCT-BRTHDAY    PIC 9(08).
           05  ACCT-TODAY      PIC 9(08).
      *
       WORKING-STORAGE SECTION.
       01 EXIT-FLAG            PIC X(1) VALUE 'N'.
       01  FILE-FLAGS.
           05 PRT-ST           PIC 9(02).
              88 PRT-SUCCESS   VALUE 00 97.
           05 ACCT-ST          PIC 9(02).
              88 ACCT-EOF      VALUE 10.
              88 ACCT-SUCCESS  VALUE 00 97.
       01  VALID-DATE-FLAGS.
           05 WS-GREG-DATE     PIC 9(10).
		     05 DATE-RC          PIC 9(05).
       01  WS-DATE.
           05 WS-INT-D         PIC 9(08).
           05 WS-INT-T         PIC 9(08).
      *------------------------------
        PROCEDURE DIVISION.
      *------------------------------
       FILE-OPEN-CONTROL.
           OPEN INPUT  ACCT-REC.
           IF ACCT-SUCCESS
            OPEN OUTPUT PRINT-LINE
             IF NOT PRT-SUCCESS   
              DISPLAY 'Output-File cannot be opened RC: ' PRT-ST
              MOVE 'Y' TO EXIT-FLAG
              PERFORM PROGRAM-EXIT
             END-IF
           ELSE
            DISPLAY 'Input-File cannot be opened RC: ' ACCT-ST
            MOVE 'Y' TO EXIT-FLAG
            PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
       READ-NEXT-RECORD.
           PERFORM READ-RECORD
           PERFORM UNTIL ACCT-EOF
               PERFORM WRITE-RECORD
               PERFORM READ-RECORD
           END-PERFORM.
       READ-NEXT-RECORD-END. EXIT.
      *----
       READ-RECORD.
           READ ACCT-REC.
       READ-NEXT-RECORD-END. EXIT.
      *----
       WRITE-RECORD.
           MOVE ACCT-SEQ      TO PRINT-SEQ
           MOVE ACCT-NAME     TO PRINT-NAME
           MOVE ACCT-LASTN    TO PRINT-LASTN
           MOVE ACCT-BRTHDAY  TO PRINT-BRTHDAY
           MOVE ACCT-BRTHDAY  TO PRINT-BRTHDAY
           MOVE ACCT-TODAY    TO PRINT-TODAY
           MOVE SPACES        TO SPACE-X
           MOVE SPACES        TO SPACE-X2
           MOVE SPACES        TO SPACE-X1
           PERFORM  DATE-HANDLE.
           WRITE   PRINT-REC
           INITIALIZE PRINT-REC.
       WRITE-RECORD-EXIT. EXIT.
      *----
       DATE-HANDLE.
           MOVE ACCT-BRTHDAY TO WS-GREG-DATE
           COMPUTE DATE-RC = FUNCTION TEST-DATE-YYYYMMDD(WS-GREG-DATE)
           IF DATE-RC = 0
            COMPUTE WS-INT-D = FUNCTION INTEGER-OF-DATE(ACCT-BRTHDAY)
            COMPUTE WS-INT-T = FUNCTION INTEGER-OF-DATE(ACCT-TODAY)
            COMPUTE DAY-DIFF = WS-INT-T - WS-INT-D
           ELSE
            DISPLAY "INVALID DATE!LINE: " ACCT-SEQ
            MOVE 'Y' TO EXIT-FLAG
            PERFORM PROGRAM-EXIT.
      *----
       PROGRAM-EXIT.
           IF EXIT-FLAG = 'Y' THEN
               CLOSE ACCT-REC
               CLOSE PRINT-LINE
               STOP RUN
           END-IF.
      *----
